#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""ssb_tuner_v21.py - STM32H750 SSB/SDR 收发机 上位机 (v21)

v21 重大界面重构:
  * 发射/接收两套完整 UI (QStackedWidget 切换, 不再是只换频谱窗格)
  * 发射页: 只显示发射控制 + 发射频谱; 校准滑块/参数全部移入
            "校准"按钮触发的二级窗口 (CalibrationDialog)
  * 接收页: 波形 + 频谱 + 瀑布图
  * 频谱/波形缩放交互: 鼠标拖动只平移横轴(频率), 滚轮只缩放横轴,
            纵轴上下限由窗口右侧两个竖向滑块控制 (类似主流 SDR)
  * 瀑布图: 频谱下方, 频率坐标与频谱对应, 永远下落不清空 (频谱移动不影响)
  * 保留全部原有功能: SSB 上下边带/纯载波/1k单音/静音/CW/NFM/AM、
            TX 按住发射、PC13 同步、频谱流回传、串口调参、导出 C 配置

命令 (与固件一致):
  IGAIN/QGAIN/PHASE/QUAD/IDC/QDC/AGAIN/MODE/TONE/STREAM/SIDE/TX/STAT/HELP
  RX <0|1>  (v20: 发射/接收切换)
帧协议:
  STREAM 包: AA 55 seq count + 4*count (I,Q int16)
  接收帧  : AA 5A seq [N_lo N_hi] + 2048 x int16 (RX_FS=1.2MHz)
"""
import sys
import math
import time
import threading
from collections import deque

import numpy as np
import serial
from serial.tools import list_ports

from PyQt5 import QtCore, QtGui, QtWidgets
import pyqtgraph as pg

# ------------------------- 常量 (与固件一致) -------------------------
CARRIER_FREQ   = 465000.0        # 显示中心频率
SPECTRUM_SPAN  = 6000.0          # 发射频谱 ±6k
RX_FS          = 1200000.0       # 接收采样率 (TIM2 2.4MHz 隔点抽取 -> 1.2MHz)
RX_RING_N      = 8192            # 接收滑窗缓冲长度 (FFT 分辨率 146Hz)
RX_SPAN        = 100000.0        # 接收频谱默认显示 ±100k
SPLIT_OUT_FS   = 18750.0         # 分路器输出采样率 (原生, DECIM=1)
PKT_SAMPLES    = 32              # 每包样本数
PHASE_UNIT     = 1000.0          # 1.0° = 1000 个 0.001° 单位
FW_GAIN_Q15    = 32767

# 瀑布图
WF_ROWS        = 256             # 瀑布图行数 (时间轴)
WF_NBINS       = 1366            # 接收频谱 ±100k 的 bin 数 (8192 点 FFT @1.2M)

# 固件启动默认配置 (用户实测校准值)
CFG_LSB_DEFAULT = {'IGAIN': 12976, 'QGAIN': 38862, 'PHASE': 0,   'QUAD': -8127,
                   'IDC': 0, 'QDC': 0, 'AGAIN': 100}
CFG_USB_DEFAULT = {'IGAIN': 10944, 'QGAIN': 32767, 'PHASE': 0, 'QUAD': 6487,
                   'IDC': 0, 'QDC': 0, 'AGAIN': 64}

PARAM_ORDER = ['IGAIN', 'QGAIN', 'PHASE', 'QUAD', 'IDC', 'QDC', 'AGAIN']
MODE_NAMES  = {0: 'SSB', 1: '纯载波', 4: '1k单音', 5: '静音', 6: 'CW', 7: 'NFM', 8: 'AM'}
MODE_CMDS   = {'SSB': 0, '纯载波': 1, '1k单音': 4, '静音': 5,
               'CW': 6, 'NFM': 7, 'AM': 8}

# 频谱/波形默认 y 轴 (dB / LSB)
TX_YLO_LIM, TX_YHI_LIM = -120.0, 10.0     # 发射频谱 y 滑块范围
TX_YDEF_LO, TX_YDEF_HI = -90.0, 5.0
RX_YLO_LIM, RX_YHI_LIM = -120.0, 10.0     # 接收频谱 y 滑块范围
RX_YDEF_LO, RX_YDEF_HI = -90.0, 5.0
WV_YLO_LIM, WV_YHI_LIM = 0.0, 4095.0      # 波形 y 滑块范围
WV_YDEF_LO, WV_YDEF_HI = 0.0, 4095.0


def clamp(v, lo, hi):
    return max(lo, min(hi, v))


# ------------------------- 串口线程 -------------------------
class SerialWorker(QtCore.QThread):
    packet   = QtCore.pyqtSignal(int, list)     # STREAM 包: (seq, [(I,Q)...])
    waveform = QtCore.pyqtSignal(int, np.ndarray)  # 接收帧: (seq, int16[2048])
    line     = QtCore.pyqtSignal(str)           # 文本行
    error    = QtCore.pyqtSignal(str)
    disconnected = QtCore.pyqtSignal()

    def __init__(self, port, baud, parent=None):
        super().__init__(parent)
        self.port = port
        self.baud = baud
        self.ser = None
        self.running = False
        self._lock = threading.Lock()
        self._buf = bytearray()

    def open_port(self):
        self.ser = serial.Serial(self.port, self.baud, timeout=0.1,
                                 write_timeout=1)
        self.running = True

    def send(self, data):
        if self.ser is None:
            return
        try:
            with self._lock:
                self.ser.write(data.encode('ascii', 'ignore') + b'\n')
        except Exception as e:
            self.error.emit('写串口失败: %s' % e)

    def run(self):
        while self.running and self.ser:
            try:
                n = self.ser.in_waiting
                if n > 0:
                    chunk = self.ser.read(n)
                    self._buf.extend(chunk)
                    self._parse()
                else:
                    self.msleep(2)
            except serial.SerialException as e:
                if self.running:
                    self.error.emit('串口错误: %s' % e)
                break
        self.disconnected.emit()

    def _parse(self):
        while True:
            b = self._buf
            if len(b) >= 2 and b[0] == 0xAA and b[1] == 0x55:
                # STREAM 包: AA 55 seq count + 4*count (I,Q int16)
                if len(b) < 4:
                    return
                count = b[3]
                total = 4 + 4 * count
                if len(b) < total:
                    return
                seq = b[2]
                smp = []
                for i in range(count):
                    off = 4 + 4 * i
                    iv = b[off] | (b[off + 1] << 8)
                    qv = b[off + 2] | (b[off + 3] << 8)
                    if iv >= 32768: iv -= 65536
                    if qv >= 32768: qv -= 65536
                    smp.append((iv, qv))
                del b[:total]
                self.packet.emit(seq, smp)
                continue
            if len(b) >= 2 and b[0] == 0xAA and b[1] == 0x5A:
                # 接收帧: AA 5A seq [N_lo N_hi] + N x int16
                if len(b) < 5:
                    return
                n = b[3] | (b[4] << 8)
                total = 5 + 2 * n
                if len(b) < total:
                    return
                seq = b[2]
                data = np.frombuffer(bytes(b[5:total]), dtype='<i2').astype(
                    np.int16).copy()
                del b[:total]
                self.waveform.emit(seq, data)
                continue
            # 文本行
            nl = b.find(b'\n')
            if nl < 0:
                # 防止长垃圾数据撑爆缓冲
                if len(b) > 65536:
                    del b[:512]
                return
            line = bytes(b[:nl]).decode('utf-8', 'replace').strip('\r')
            del b[:nl + 1]
            self.line.emit(line)

    def stop(self):
        self.running = False
        if self.ser:
            try:
                self.ser.close()
            except Exception:
                pass
            self.ser = None


# ------------------------- 参数滑块控件 -------------------------
class ParamSlider(QtWidgets.QWidget):
    changed = QtCore.pyqtSignal(str, int)

    def __init__(self, name, label, lo, hi, step, unit, display_scale=1.0,
                 parent=None):
        super().__init__(parent)
        self.name = name
        self.lo, self.hi = lo, hi
        self.step = step
        self.unit = unit
        self.ds = display_scale
        lay = QtWidgets.QHBoxLayout(self)
        lay.setContentsMargins(2, 0, 2, 0)
        self.lbl = QtWidgets.QLabel(label)
        self.lbl.setMinimumWidth(56)
        lay.addWidget(self.lbl)
        self.slider = QtWidgets.QSlider(QtCore.Qt.Horizontal)
        self.slider.setRange(0, 1000)
        lay.addWidget(self.slider, 1)
        self.spin = QtWidgets.QSpinBox()
        self.spin.setRange(int(lo / display_scale), int(hi / display_scale))
        self.spin.setValue(int(lo / display_scale))
        lay.addWidget(self.spin)
        self._updating = False
        self.slider.valueChanged.connect(self._slider_changed)
        self.spin.valueChanged.connect(self._spin_changed)

    def _to_disp(self, v):
        return int(round(v * self.ds))

    def _from_disp(self, d):
        return clamp(int(round(d / self.ds)), self.lo, self.hi)

    def _spin_changed(self, d):
        if self._updating:
            return
        v = self._from_disp(d)
        self._updating = True
        self.slider.setValue(int((v - self.lo) / max(1, (self.hi - self.lo)) * 1000))
        self._updating = False
        self._emit(v)

    def _slider_changed(self, sv):
        if self._updating:
            return
        v = self.lo + int(round((self.hi - self.lo) * sv / 1000.0 / self.step)) * self.step
        v = clamp(v, self.lo, self.hi)
        self._updating = True
        self.spin.setValue(self._to_disp(v))
        self._updating = False
        self._emit(v)

    def _emit(self, v):
        self.changed.emit(self.name, v)

    def set_value(self, val, send=False):
        val = clamp(int(round(val)), self.lo, self.hi)
        self._updating = True
        self.slider.setValue(int((val - self.lo) / max(1, (self.hi - self.lo)) * 1000))
        self.spin.setValue(self._to_disp(val))
        self._updating = False
        if send:
            self._emit(val)

    def value(self):
        return self._from_disp(self.spin.value())


# ------------------------- 频谱/波形交互视图 -------------------------
class XZoomPlot(pg.PlotWidget):
    """鼠标: 左键拖动平移横轴, 滚轮以光标为中心缩放横轴; 纵轴由右侧滑块控制"""
    xrange_changed = QtCore.pyqtSignal(float, float)

    def __init__(self, *a, **k):
        super().__init__(*a, **k)
        self.setBackground('#0d1820')
        self.showGrid(x=True, y=True, alpha=0.25)
        self.setMouseEnabled(x=False, y=False)
        self.setMenuEnabled(False)
        self.setFocusPolicy(QtCore.Qt.StrongFocus)
        self._drag_pix = None
        self._drag_x0 = None
        # 任何 x 范围变化 (拖动/滚轮/程序化) 都转发, 瀑布图永远跟随
        self.getPlotItem().vb.sigXRangeChanged.connect(self._on_xrange)

    def _on_xrange(self, vb, r):
        self.xrange_changed.emit(float(r[0]), float(r[1]))

    # ---- 坐标换算: viewport 像素 -> 数据 x ----
    def _x_at(self, pos):
        vb = self.getPlotItem().vb
        try:
            sc = self.mapToScene(pos)
            vp = vb.mapSceneToView(sc)
            return float(vp.x())
        except Exception:
            return None

    def _x_span(self):
        r = self.getPlotItem().vb.viewRange()[0]
        return float(r[1] - r[0])

    def mousePressEvent(self, ev):
        if ev.button() == QtCore.Qt.LeftButton:
            self._drag_pix = ev.pos()
            self._drag_x0 = self._x_at(ev.pos())
            ev.accept()
            return
        super().mousePressEvent(ev)

    def mouseMoveEvent(self, ev):
        if self._drag_pix is not None and self._drag_x0 is not None:
            x0 = self._x_at(ev.pos())
            if x0 is not None:
                dx = self._drag_x0 - x0
                r = self.getPlotItem().vb.viewRange()[0]
                self.getPlotItem().vb.setXRange(r[0] + dx, r[1] + dx, padding=0)
                self._drag_x0 = x0
                r2 = self.getPlotItem().vb.viewRange()[0]
                self.xrange_changed.emit(float(r2[0]), float(r2[1]))
            ev.accept()
            return
        super().mouseMoveEvent(ev)

    def mouseReleaseEvent(self, ev):
        self._drag_pix = None
        self._drag_x0 = None
        ev.accept()

    def wheelEvent(self, ev):
        # 滚轮: 以光标为锚点缩放横轴
        xc = self._x_at(ev.pos())
        if xc is None:
            ev.accept()
            return
        span = self._x_span()
        factor = 1.3 if ev.angleDelta().y() > 0 else 1.0 / 1.3
        new_span = span / factor
        # 防止过度放大 (最小跨度约 1Hz) 与过度缩小
        new_span = clamp(new_span, 1.0, 3e6)
        lo = xc - (xc - (xc - span / 2.0)) / factor
        # 保持 xc 位置固定: 新范围 = [xc - (span/2)/factor, xc + (span/2)/factor]
        lo = xc - new_span / 2.0
        hi = xc + new_span / 2.0
        self.getPlotItem().vb.setXRange(lo, hi, padding=0)
        self.xrange_changed.emit(float(lo), float(hi))
        ev.accept()


# ------------------------- 右侧纵轴双滑块 -------------------------
class YAxisSliders(QtWidgets.QWidget):
    yrange_changed = QtCore.pyqtSignal(float, float)

    def __init__(self, lo_lim, hi_lim, def_lo, def_hi, unit='dB',
                 label1='上限', label2='下限', parent=None):
        super().__init__(parent)
        self.lo_lim, self.hi_lim = lo_lim, hi_lim
        lay = QtWidgets.QVBoxLayout(self)
        lay.setContentsMargins(0, 4, 2, 4)
        lay.setSpacing(2)
        self.lbl_top = QtWidgets.QLabel(label1)
        self.lbl_top.setAlignment(QtCore.Qt.AlignCenter)
        self.lbl_top.setStyleSheet('color:#888; font-size:9pt;')
        lay.addWidget(self.lbl_top)
        self.sl_top = QtWidgets.QSlider(QtCore.Qt.Vertical)
        self.sl_top.setRange(0, 1000)
        self.sl_top.setInvertedAppearance(True)
        lay.addWidget(self.sl_top, 3)
        self.lbl_bot = QtWidgets.QLabel(label2)
        self.lbl_bot.setAlignment(QtCore.Qt.AlignCenter)
        self.lbl_bot.setStyleSheet('color:#888; font-size:9pt;')
        lay.addWidget(self.lbl_bot)
        self.sl_bot = QtWidgets.QSlider(QtCore.Qt.Vertical)
        self.sl_bot.setRange(0, 1000)
        self.sl_bot.setInvertedAppearance(True)
        lay.addWidget(self.sl_bot, 3)
        # 默认值
        self._set_from_val(self.sl_top, def_hi)
        self._set_from_val(self.sl_bot, def_lo)
        self._emit_y()
        self.sl_top.valueChanged.connect(self._on_top)
        self.sl_bot.valueChanged.connect(self._on_bot)

    def _val(self, sv):
        return self.lo_lim + (self.hi_lim - self.lo_lim) * sv / 1000.0

    def _set_from_val(self, sl, val):
        v = int(clamp((val - self.lo_lim) / max(1e-9, (self.hi_lim - self.lo_lim)) * 1000, 0, 1000))
        sl.blockSignals(True)
        sl.setValue(v)
        sl.blockSignals(False)

    def _on_top(self):
        self._emit_y()

    def _on_bot(self):
        self._emit_y()

    def _emit_y(self):
        top = self._val(self.sl_top.value())
        bot = self._val(self.sl_bot.value())
        if top <= bot:
            top = bot + (self.hi_lim - self.lo_lim) * 0.05
        self.yrange_changed.emit(bot, top)


# ------------------------- 绘图面板 (图 + 右侧纵轴滑块) -------------------------
class PlotPanel(QtWidgets.QWidget):
    xrange_changed = QtCore.pyqtSignal(float, float)

    def __init__(self, title, xlabel, ylabel, xrange, ylo_lim, yhi_lim,
                 ydef_lo, ydef_hi, pen='#66ff66', unit='dB',
                 parent=None):
        super().__init__(parent)
        self.title = title
        lay = QtWidgets.QVBoxLayout(self)
        lay.setContentsMargins(0, 0, 0, 0)
        lab = QtWidgets.QLabel(title)
        lab.setStyleSheet('font-weight:bold; color:#aaddff;')
        lay.addWidget(lab)
        h = QtWidgets.QHBoxLayout()
        h.setSpacing(2)
        self.plot = XZoomPlot()
        self.plot.setLabel('bottom', xlabel, units='Hz')
        self.plot.setLabel('left', ylabel, units=unit)
        self.plot.setXRange(xrange[0], xrange[1], padding=0)
        self.plot.setYRange(ydef_lo, ydef_hi)
        self.curve = self.plot.plot(pen=pg.mkPen(pen, width=1.5))
        h.addWidget(self.plot, 1)
        self.ys = YAxisSliders(ylo_lim, yhi_lim, ydef_lo, ydef_hi, unit=unit)
        self.ys.yrange_changed.connect(self._set_y)
        h.addWidget(self.ys)
        lay.addLayout(h, 1)
        self.plot.xrange_changed.connect(self.xrange_changed)

    def _set_y(self, lo, hi):
        self.plot.setYRange(lo, hi)

    def setData(self, x, y):
        self.curve.setData(x, y)

    def clear_curve(self):
        self.curve.setData([], [])


# ------------------------- 瀑布图 -------------------------
class WaterfallView(QtWidgets.QWidget):
    """频谱下方瀑布图: 频率坐标与频谱对应, 永远下落不清空"""

    def __init__(self, freq_lo, freq_hi, parent=None):
        super().__init__(parent)
        self.freq_lo, self.freq_hi = freq_lo, freq_hi
        self.nbins = WF_NBINS
        self.data = np.full((WF_ROWS, self.nbins), -100.0, dtype=np.float32)
        self.paused = False
        self._frame = 0

        lay = QtWidgets.QVBoxLayout(self)
        lay.setContentsMargins(0, 0, 0, 0)
        top = QtWidgets.QHBoxLayout()
        lab = QtWidgets.QLabel('瀑布图 (永远下落, 频谱移动不清空)')
        lab.setStyleSheet('font-weight:bold; color:#aaffaa;')
        top.addWidget(lab)
        top.addStretch(1)
        self.lbl_info = QtWidgets.QLabel('')
        self.lbl_info.setStyleSheet('color:#888;')
        top.addWidget(self.lbl_info)
        lay.addLayout(top)

        self.wf_plot = pg.PlotWidget()
        self.wf_plot.setBackground('#080d14')
        self.wf_plot.setMenuEnabled(False)
        self.wf_plot.setMouseEnabled(x=True, y=False)
        self.wf_plot.setLabel('bottom', '频率', units='Hz')
        self.wf_plot.setLabel('left', '时间', units='帧')
        self.wf_img = pg.ImageItem()
        self.wf_plot.addItem(self.wf_img)
        self.wf_plot.setXRange(freq_lo, freq_hi, padding=0)
        self.wf_plot.setYRange(0, WF_ROWS)
        self._update_rect()
        lay.addWidget(self.wf_plot, 1)

        ctrl = QtWidgets.QHBoxLayout()
        self.btn_pause = QtWidgets.QPushButton('暂停')
        self.btn_pause.setCheckable(True)
        self.btn_pause.toggled.connect(self._on_pause)
        ctrl.addWidget(self.btn_pause)
        self.btn_clear = QtWidgets.QPushButton('清空')
        self.btn_clear.clicked.connect(self.clear)
        ctrl.addWidget(self.btn_clear)
        ctrl.addWidget(QtWidgets.QLabel('配色'))
        self.cmb_cmap = QtWidgets.QComboBox()
        for name in ('jet', 'viridis', 'inferno', 'plasma', 'gray', 'turbo'):
            self.cmb_cmap.addItem(name)
        self.cmb_cmap.setCurrentText('jet')
        self.cmb_cmap.currentIndexChanged.connect(self._on_cmap)
        ctrl.addWidget(self.cmb_cmap)
        ctrl.addWidget(QtWidgets.QLabel('范围'))
        self.spin_lo = QtWidgets.QSpinBox()
        self.spin_lo.setRange(-140, 0)
        self.spin_lo.setValue(-90)
        self.spin_lo.setSuffix(' dB')
        self.spin_lo.valueChanged.connect(self._on_levels)
        ctrl.addWidget(self.spin_lo)
        self.spin_hi = QtWidgets.QSpinBox()
        self.spin_hi.setRange(-100, 20)
        self.spin_hi.setValue(0)
        self.spin_hi.setSuffix(' dB')
        self.spin_hi.valueChanged.connect(self._on_levels)
        ctrl.addWidget(self.spin_hi)
        ctrl.addStretch(1)
        lay.addLayout(ctrl)
        self._apply_cmap()

    def _update_rect(self):
        self.wf_img.setRect(QtCore.QRectF(self.freq_lo, 0,
                                          self.freq_hi - self.freq_lo,
                                          WF_ROWS))

    def set_freq_range(self, lo, hi):
        """频谱 x 窗口变化时调用 (不改变累积数据, 只改显示范围)"""
        self.freq_lo, self.freq_hi = lo, hi
        self.wf_plot.setXRange(lo, hi, padding=0)

    def add_row(self, db):
        """db: 长度 = self.nbins 的 dB 行 (与频率范围对应)"""
        if self.paused:
            self._frame += 1
            return
        if db.shape[0] > self.nbins:
            db = db[:self.nbins]
        elif db.shape[0] < self.nbins:
            pad = self.nbins - db.shape[0]
            db = np.concatenate([db, np.full(pad, -100.0, dtype=np.float32)])
        db = np.asarray(db, dtype=np.float32)
        # 新行在最上方, 旧行向下落
        self.data = np.roll(self.data, 1, axis=0)
        self.data[0] = db
        self._frame += 1
        self.wf_img.setImage(self.data.T, autoLevels=False)
        self.lbl_info.setText('%d 帧 (%ds)' % (
            min(self._frame, WF_ROWS),
            int(min(self._frame, WF_ROWS) / 20.0)))

    def _on_pause(self, p):
        self.paused = p
        self.btn_pause.setText('继续' if p else '暂停')

    def clear(self):
        self.data.fill(-100.0)
        self.wf_img.setImage(self.data.T, autoLevels=False)

    def _on_cmap(self):
        self._apply_cmap()

    def _apply_cmap(self):
        try:
            cm = pg.colormap.get(self.cmb_cmap.currentText())
            self.wf_img.setColorMap(cm)
        except Exception:
            pass

    def _on_levels(self):
        self.wf_img.setLevels([self.spin_lo.value(), self.spin_hi.value()])


# ------------------------- 校准二级窗口 -------------------------
class CalibrationDialog(QtWidgets.QDialog):
    """校准参数二级窗口: 所有 I/Q 校准滑块 + 读取/应用/导出"""

    def __init__(self, owner, parent=None):
        super().__init__(parent)
        self.owner = owner            # TunerWindow
        self.setWindowTitle('校准参数 (I/Q 边带校准)')
        self.setMinimumWidth(560)
        self._updating = False

        lay = QtWidgets.QVBoxLayout(self)
        top = QtWidgets.QHBoxLayout()
        top.addWidget(QtWidgets.QLabel('当前边带:'))
        self.btn_lsb = QtWidgets.QPushButton('下边带 LSB')
        self.btn_lsb.setCheckable(True)
        self.btn_usb = QtWidgets.QPushButton('上边带 USB')
        self.btn_usb.setCheckable(True)
        self.btn_lsb.setChecked(owner.side == 0)
        self.btn_usb.setChecked(owner.side == 1)
        self.btn_lsb.clicked.connect(lambda: self._set_side(0))
        self.btn_usb.clicked.connect(lambda: self._set_side(1))
        top.addWidget(self.btn_lsb)
        top.addWidget(self.btn_usb)
        top.addStretch(1)
        lay.addLayout(top)

        grid = QtWidgets.QGridLayout()
        spec = [
            ('IGAIN', 'IGAIN', 0, 65535, 1, '', 1.0),
            ('QGAIN', 'QGAIN', 0, 65535, 1, '', 1.0),
            ('PHASE', 'PHASE', 0, 360000, 1, '°', 1.0 / PHASE_UNIT),
            ('QUAD',  'QUAD',  -32768, 32767, 1, '', 1.0),
            ('IDC',   'IDC',   -1024, 1024, 1, '', 1.0),
            ('QDC',   'QDC',   -1024, 1024, 1, '', 1.0),
            ('AGAIN', 'AGAIN', 0, 1024, 1, '', 1.0),
        ]
        self.ctrl = {}
        for i, (name, label, lo, hi, step, unit, ds) in enumerate(spec):
            ps = ParamSlider(name, label, lo, hi, step, unit, display_scale=ds)
            ps.changed.connect(self.owner.on_param_changed)
            self.ctrl[name] = ps
            grid.addWidget(ps, i, 0)
        lay.addLayout(grid)

        info = QtWidgets.QLabel(
            'PHASE 单位 0.001° (0.1° = 100)\n'
            'QUAD/IDC/QDC 为 Q15 定点\n'
            'IGAIN/QGAIN 0~65535 (Q15)\n'
            'AGAIN 0~1024 (音量)\n'
            '滑块变化实时下发固件')
        info.setStyleSheet('color:#888;')
        lay.addWidget(info)

        btns = QtWidgets.QHBoxLayout()
        self.btn_read = QtWidgets.QPushButton('读取当前参数 (STAT)')
        self.btn_read.clicked.connect(owner.cmd_stat)
        btns.addWidget(self.btn_read)
        self.btn_apply = QtWidgets.QPushButton('下发当前参数')
        self.btn_apply.clicked.connect(owner.apply_all_params)
        btns.addWidget(self.btn_apply)
        self.btn_export = QtWidgets.QPushButton('导出 C 配置')
        self.btn_export.clicked.connect(owner.export_c_config)
        btns.addWidget(self.btn_export)
        self.btn_close = QtWidgets.QPushButton('关闭')
        self.btn_close.clicked.connect(self.accept)
        btns.addWidget(self.btn_close)
        lay.addLayout(btns)

        self._sync_from_owner()

    def _set_side(self, side):
        if self.owner.side == side:
            return
        self.owner.set_side(side)
        self.btn_lsb.setChecked(side == 0)
        self.btn_usb.setChecked(side == 1)
        self._sync_from_owner()

    def _sync_from_owner(self):
        """用 owner.cfg 当前边带的值刷新滑块"""
        key = 'LSB' if self.owner.side == 0 else 'USB'
        self._updating = True
        for name in ('IGAIN', 'QGAIN', 'PHASE', 'QUAD', 'IDC', 'QDC', 'AGAIN'):
            self.ctrl[name].set_value(self.owner.cfg[key][name])
        self._updating = False


# ------------------------- 主窗口 -------------------------
class TunerWindow(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle('SSB-IQ-TUNER v21 — STM32H750 SDR 收发机')
        self.resize(1280, 860)

        self.connected = False
        self.worker = None
        self.side = 0                 # 0=LSB 1=USB
        self.rx_mode = False          # False=发射 True=接收
        self.stream_on = False
        self.decim = 1
        self.cfg = {'LSB': dict(CFG_LSB_DEFAULT), 'USB': dict(CFG_USB_DEFAULT)}
        self._last_stats = None

        # 数据缓冲
        self.iq = deque(maxlen=16384)          # 发射 STREAM I/Q
        self.rx_ring = deque(maxlen=RX_RING_N) # 接收波形滑窗
        self._pkt_count = 0
        self._last_pkt_t = time.time()
        self.pkt_rate = 0.0
        self._last_wf_t = time.time()

        self._build_ui()

        # 频谱刷新定时器 ~10Hz
        self.timer = QtCore.QTimer(self)
        self.timer.timeout.connect(self.on_tick)
        self.timer.start(100)

        self.log('就绪. 选择串口后点"连接".')
        self.refresh_ports()

    # ---------------------------------------------------------- UI
    def _build_ui(self):
        cw = QtWidgets.QWidget()
        self.setCentralWidget(cw)
        root = QtWidgets.QVBoxLayout(cw)
        root.setContentsMargins(6, 6, 6, 6)
        root.setSpacing(6)

        # ---- 顶栏: 串口 + 模式切换 + 状态 ----
        bar = QtWidgets.QHBoxLayout()
        bar.addWidget(QtWidgets.QLabel('串口'))
        self.cmb_port = QtWidgets.QComboBox()
        self.cmb_port.setMinimumWidth(200)
        bar.addWidget(self.cmb_port)
        self.cmb_baud = QtWidgets.QComboBox()
        for b in (921600, 460800, 230400, 115200):
            self.cmb_baud.addItem(str(b))
        self.cmb_baud.setCurrentText('921600')
        bar.addWidget(self.cmb_baud)
        self.btn_conn = QtWidgets.QPushButton('连接')
        self.btn_conn.clicked.connect(self.toggle_connect)
        bar.addWidget(self.btn_conn)
        bar.addWidget(QtWidgets.QLabel('状态:'))
        self.lbl_status = QtWidgets.QLabel('未连接')
        self.lbl_status.setStyleSheet('color:gray; font-weight:bold;')
        bar.addWidget(self.lbl_status)
        bar.addSpacing(12)
        # 发射/接收切换
        self.btn_tx_mode = QtWidgets.QPushButton('发射 TX')
        self.btn_tx_mode.setCheckable(True)
        self.btn_tx_mode.setChecked(True)
        self.btn_tx_mode.clicked.connect(lambda: self.set_rt_mode(False))
        self.btn_rx_mode = QtWidgets.QPushButton('接收 RX')
        self.btn_rx_mode.setCheckable(True)
        self.btn_rx_mode.clicked.connect(lambda: self.set_rt_mode(True))
        bar.addWidget(self.btn_tx_mode)
        bar.addWidget(self.btn_rx_mode)
        self.lbl_rt = QtWidgets.QLabel('● 发射')
        self.lbl_rt.setStyleSheet('color:#33ff33;font-weight:bold')
        bar.addWidget(self.lbl_rt)
        bar.addStretch(1)
        self.lbl_side = QtWidgets.QLabel('边带: LSB')
        self.lbl_side.setStyleSheet('font-size:12pt; font-weight:bold; color:#0066cc;')
        bar.addWidget(self.lbl_side)
        root.addLayout(bar)

        # ---- 两套 UI (QStackedWidget) ----
        self.stack = QtWidgets.QStackedWidget()
        self.stack.addWidget(self._build_tx_page())   # 页0 = 发射
        self.stack.addWidget(self._build_rx_page())   # 页1 = 接收
        root.addWidget(self.stack, 3)

        # ---- 日志 ----
        lg = QtWidgets.QGroupBox('日志')
        lv = QtWidgets.QVBoxLayout(lg)
        lv.setContentsMargins(4, 4, 4, 4)
        self.log_view = QtWidgets.QPlainTextEdit()
        self.log_view.setReadOnly(True)
        self.log_view.setMaximumBlockCount(1000)
        self.log_view.setFixedHeight(110)
        lv.addWidget(self.log_view)
        root.addWidget(lg, 0)

    def _build_tx_page(self):
        """发射页: 发射控制 + 发射频谱 + 校准按钮"""
        page = QtWidgets.QWidget()
        lay = QtWidgets.QVBoxLayout(page)
        lay.setContentsMargins(2, 2, 2, 2)

        # 控制行1: 边带 + 调制方式
        r1 = QtWidgets.QHBoxLayout()
        grp_side = QtWidgets.QGroupBox('边带 (SIDE)')
        h = QtWidgets.QHBoxLayout(grp_side)
        self.btn_lsb = QtWidgets.QPushButton('LSB')
        self.btn_usb = QtWidgets.QPushButton('USB')
        self.btn_lsb.setCheckable(True)
        self.btn_usb.setCheckable(True)
        self.btn_lsb.setChecked(True)
        self.btn_lsb.clicked.connect(lambda: self.set_side(0))
        self.btn_usb.clicked.connect(lambda: self.set_side(1))
        h.addWidget(self.btn_lsb)
        h.addWidget(self.btn_usb)
        r1.addWidget(grp_side)

        grp_mode = QtWidgets.QGroupBox('调制方式')
        h = QtWidgets.QHBoxLayout(grp_mode)
        self.mode_btns = {}
        for name in MODE_CMDS:
            b = QtWidgets.QPushButton(name)
            b.setCheckable(True)
            b.clicked.connect(lambda _=False, n=name: self.set_mode(n))
            self.mode_btns[name] = b
            h.addWidget(b)
        self.mode_btns['SSB'].setChecked(True)
        r1.addWidget(grp_mode)
        r1.addStretch(1)
        lay.addLayout(r1)

        # 控制行2: TX + 单音 + DECIM + 频谱流 + 校准
        r2 = QtWidgets.QHBoxLayout()
        grp_tx = QtWidgets.QGroupBox('CW 发射 (TX)')
        h = QtWidgets.QHBoxLayout(grp_tx)
        self.btn_tx = QtWidgets.QPushButton('TX 按住发射')
        self.btn_tx.setStyleSheet(
            'QPushButton:pressed{background:#ff6666;font-weight:bold}')
        self.btn_tx.pressed.connect(self.on_tx_press)
        self.btn_tx.released.connect(self.on_tx_release)
        h.addWidget(self.btn_tx)
        self.lbl_tx = QtWidgets.QLabel('● 静音')
        self.lbl_tx.setStyleSheet('color:#33ff33;font-weight:bold')
        h.addWidget(self.lbl_tx)
        h.addWidget(QtWidgets.QLabel('PC13 同步'))
        r2.addWidget(grp_tx)

        grp_tone = QtWidgets.QGroupBox('单音')
        h = QtWidgets.QHBoxLayout(grp_tone)
        self.spin_tone = QtWidgets.QSpinBox()
        self.spin_tone.setRange(100, 3000)
        self.spin_tone.setValue(1000)
        self.spin_tone.setSuffix(' Hz')
        self.spin_tone.valueChanged.connect(self.on_tone_changed)
        h.addWidget(self.spin_tone)
        r2.addWidget(grp_tone)

        grp_dec = QtWidgets.QGroupBox('频谱流')
        h = QtWidgets.QHBoxLayout(grp_dec)
        self.btn_stream = QtWidgets.QPushButton('开启频谱流')
        self.btn_stream.clicked.connect(self.toggle_stream)
        h.addWidget(self.btn_stream)
        h.addWidget(QtWidgets.QLabel('DECIM'))
        self.cmb_decim = QtWidgets.QComboBox()
        for d in (1, 2, 4, 8, 16, 32):
            self.cmb_decim.addItem(str(d))
        self.cmb_decim.setCurrentText('1')
        self.cmb_decim.currentIndexChanged.connect(self.on_decim_changed)
        h.addWidget(self.cmb_decim)
        self.lbl_fs = QtWidgets.QLabel('18750Hz')
        h.addWidget(self.lbl_fs)
        self.lbl_pr = QtWidgets.QLabel('0/s')
        h.addWidget(self.lbl_pr)
        r2.addWidget(grp_dec)

        self.btn_calib = QtWidgets.QPushButton('校准参数...')
        self.btn_calib.setStyleSheet(
            'background:#3a3a5a; font-weight:bold; padding:6px;')
        self.btn_calib.clicked.connect(self.open_calibration)
        r2.addWidget(self.btn_calib)
        r2.addStretch(1)
        lay.addLayout(r2)

        # 发射频谱
        self.tx_grp = QtWidgets.QGroupBox('发射频谱 (STREAM 直接相加合成)')
        tv = QtWidgets.QVBoxLayout(self.tx_grp)
        self.panel_tx = PlotPanel(
            '频谱 (中心 %.0fkHz ±%.0fkHz, 拖动平移/滚轮缩放横轴, 右侧滑块控纵轴)'
            % (CARRIER_FREQ / 1000, SPECTRUM_SPAN / 1000),
            '频率', '幅度', (CARRIER_FREQ - SPECTRUM_SPAN, CARRIER_FREQ + SPECTRUM_SPAN),
            TX_YLO_LIM, TX_YHI_LIM, TX_YDEF_LO, TX_YDEF_HI, pen='#ff6666')
        tv.addWidget(self.panel_tx, 1)
        lay.addWidget(self.tx_grp, 1)
        return page

    def _build_rx_page(self):
        """接收页: 波形 + 频谱 + 瀑布图"""
        page = QtWidgets.QWidget()
        lay = QtWidgets.QVBoxLayout(page)
        lay.setContentsMargins(2, 2, 2, 2)

        top = QtWidgets.QHBoxLayout()
        self.lbl_rx = QtWidgets.QLabel(
            '接收模式: 连续回传 2048 点帧 (1.2MHz), 实时波形+频谱+瀑布图')
        top.addWidget(self.lbl_rx)
        top.addStretch(1)
        lay.addLayout(top)

        split = QtWidgets.QSplitter(QtCore.Qt.Horizontal)
        # 左: 波形
        wg = QtWidgets.QWidget()
        wl = QtWidgets.QVBoxLayout(wg)
        wl.setContentsMargins(0, 0, 0, 0)
        self.panel_wave = PlotPanel(
            '时域波形 (拖动平移/滚轮缩放横轴, 右侧滑块控纵轴)',
            '时间', 'ADC', (0, 2048.0 / RX_FS * 1000.0),
            WV_YLO_LIM, WV_YHI_LIM, WV_YDEF_LO, WV_YDEF_HI,
            pen='#66ccff', unit='LSB')
        self.panel_wave.plot.setLabel('bottom', '时间', units='ms')
        self.panel_wave.plot.setXRange(0, 2048.0 / RX_FS * 1000.0, padding=0)
        wl.addWidget(self.panel_wave, 1)
        split.addWidget(wg)

        # 右: 频谱 + 瀑布图
        rg = QtWidgets.QWidget()
        rl = QtWidgets.QVBoxLayout(rg)
        rl.setContentsMargins(0, 0, 0, 0)
        self.panel_rx = PlotPanel(
            '频谱 (中心 %.0fkHz ±%.0fkHz, 拖动平移/滚轮缩放横轴)'
            % (CARRIER_FREQ / 1000, RX_SPAN / 1000),
            '频率', '幅度', (CARRIER_FREQ - RX_SPAN, CARRIER_FREQ + RX_SPAN),
            RX_YLO_LIM, RX_YHI_LIM, RX_YDEF_LO, RX_YDEF_HI, pen='#66ff66')
        rl.addWidget(self.panel_rx, 3)
        # 瀑布图 (频率坐标与频谱对应)
        self.waterfall = WaterfallView(CARRIER_FREQ - RX_SPAN,
                                       CARRIER_FREQ + RX_SPAN)
        rl.addWidget(self.waterfall, 2)
        # 频谱 x 窗口变化 -> 瀑布图跟随 (数据不清空)
        self.panel_rx.xrange_changed.connect(self.waterfall.set_freq_range)
        split.addWidget(rg)
        split.setSizes([380, 900])
        lay.addWidget(split, 1)
        return page

    # ---------------------------------------------------------- 日志/串口
    def log(self, s):
        self.log_view.appendPlainText(s)

    def refresh_ports(self):
        cur = self.cmb_port.currentText()
        self.cmb_port.clear()
        for p in list_ports.comports():
            self.cmb_port.addItem('%s  %s' % (p.device, p.description))
        if cur:
            self.cmb_port.setCurrentText(cur)

    def toggle_connect(self):
        if self.connected:
            self.disconnect()
        else:
            self.connect_port()

    def connect_port(self):
        txt = self.cmb_port.currentText()
        if not txt:
            self.log('未选择串口')
            return
        port = txt.split()[0]
        baud = int(self.cmb_baud.currentText())
        try:
            self.worker = SerialWorker(port, baud)
            self.worker.open_port()
        except Exception as e:
            self.log('连接失败: %s' % e)
            return
        self.worker.line.connect(self.on_line)
        self.worker.packet.connect(self.on_packet)
        self.worker.waveform.connect(self.on_waveform)
        self.worker.error.connect(self.on_error)
        self.worker.disconnected.connect(self.on_disconnected)
        self.worker.start()
        self.connected = True
        self.btn_conn.setText('断开')
        self.lbl_status.setText('已连接 %s @%d' % (port, baud))
        self.lbl_status.setStyleSheet('color:green; font-weight:bold;')
        self.log('已连接 %s @%d' % (port, baud))
        self.send_cmd('HELP')
        self.cmd_stat()
        if self.stream_on:
            self.send_cmd('STREAM 1 %d' % self.decim)

    def disconnect(self):
        if self.worker:
            self.worker.stop()
            self.worker.wait(500)
            self.worker = None
        self.connected = False
        self.btn_conn.setText('连接')
        self.lbl_status.setText('未连接')
        self.lbl_status.setStyleSheet('color:gray; font-weight:bold;')

    def on_disconnected(self):
        self.connected = False
        self.btn_conn.setText('连接')
        self.lbl_status.setText('已断开')
        self.lbl_status.setStyleSheet('color:red; font-weight:bold;')

    def on_error(self, msg):
        self.log('ERR: %s' % msg)

    def send_cmd(self, cmd):
        if self.worker:
            self.worker.send(cmd)
        else:
            self.log('(未连接) %s' % cmd)

    # ---------------------------------------------------------- 命令
    def set_side(self, side):
        if self.side == side and self.connected:
            self.btn_lsb.setChecked(side == 0)
            self.btn_usb.setChecked(side == 1)
            return
        self.side = side
        self.btn_lsb.setChecked(side == 0)
        self.btn_usb.setChecked(side == 1)
        self.lbl_side.setText('边带: %s' % ('LSB' if side == 0 else 'USB'))
        self.log('切换边带 -> %s' % ('LSB' if side == 0 else 'USB'))
        self.send_cmd('SIDE %d' % side)
        QtCore.QTimer.singleShot(60, self.cmd_stat)

    def set_mode(self, name):
        for k, b in self.mode_btns.items():
            b.setChecked(k == name)
        self.send_cmd('MODE %d' % MODE_CMDS[name])
        self.log('MODE -> %s' % name)

    def on_tone_changed(self, v):
        self.send_cmd('TONE %d' % v)

    def on_tx_press(self):
        self.send_cmd('TX 1')
        self.lbl_tx.setText('● 发射中')
        self.lbl_tx.setStyleSheet('color:#ff8800;font-weight:bold')

    def on_tx_release(self):
        self.send_cmd('TX 0')
        self.lbl_tx.setText('● 静音')
        self.lbl_tx.setStyleSheet('color:#33ff33;font-weight:bold')

    def on_decim_changed(self):
        self.decim = int(self.cmb_decim.currentText())
        self.lbl_fs.setText('%dHz' % int(SPLIT_OUT_FS / self.decim))
        if self.stream_on and self.connected:
            self.send_cmd('STREAM 1 %d' % self.decim)

    def on_param_changed(self, name, val):
        # 更新当前边带的本地配置
        self.cfg['LSB' if self.side == 0 else 'USB'][name] = int(round(val))
        v = int(round(val))
        self.send_cmd('%s %d' % (name, v))

    def apply_all_params(self):
        key = 'LSB' if self.side == 0 else 'USB'
        for name in ('IGAIN', 'QGAIN', 'PHASE', 'QUAD', 'IDC', 'QDC', 'AGAIN'):
            self.send_cmd('%s %d' % (name, self.cfg[key][name]))
        self.log('已下发当前 %s 配置' % key)

    def cmd_stat(self):
        self.send_cmd('STAT')

    def toggle_stream(self):
        self.stream_on = not self.stream_on
        self.btn_stream.setText('停止频谱流' if self.stream_on else '开启频谱流')
        if self.stream_on:
            self.iq.clear()
            self.send_cmd('STREAM 1 %d' % self.decim)
            self.log('开启频谱流 (DECIM=%d, fs=%d Hz)'
                     % (self.decim, int(SPLIT_OUT_FS / self.decim)))
        else:
            self.send_cmd('STREAM 0')
            self.log('停止频谱流')

    def open_calibration(self):
        dlg = CalibrationDialog(self, self)
        dlg.exec_()

    # ---------------------------------------------------------- 接收/模式切换
    def set_rt_mode(self, rx):
        if rx == self.rx_mode:
            return
        self.rx_mode = rx
        self.btn_tx_mode.setChecked(not rx)
        self.btn_rx_mode.setChecked(rx)
        self.stack.setCurrentIndex(1 if rx else 0)
        # 发射控件在接收模式下禁用
        for b in self.mode_btns.values():
            b.setEnabled(not rx)
        self.btn_tx.setEnabled(not rx)
        self.spin_tone.setEnabled(not rx)
        self.btn_stream.setEnabled(not rx)
        self.btn_calib.setEnabled(not rx)
        self.btn_lsb.setEnabled(not rx)
        self.btn_usb.setEnabled(not rx)
        if rx:
            self.rx_ring.clear()
            self.lbl_rt.setText('● 接收')
            self.lbl_rt.setStyleSheet('color:#ffaa33;font-weight:bold')
            self.lbl_rx.setText('接收中... 等待波形帧')
            self.lbl_rx.setStyleSheet('color:#ff8800;font-weight:bold')
            self.send_cmd('RX 1')
        else:
            self.lbl_rt.setText('● 发射')
            self.lbl_rt.setStyleSheet('color:#33ff33;font-weight:bold')
            self.lbl_rx.setText(
                '接收模式: 连续回传 2048 点帧 (1.2MHz), 实时波形+频谱+瀑布图')
            self.lbl_rx.setStyleSheet('')
            self.send_cmd('RX 0')
            if self.stream_on and self.connected:
                self.send_cmd('STREAM 1 %d' % self.decim)

    def on_waveform(self, seq, data):
        """v21: 接收帧 -> 波形 + 频谱 + 瀑布图"""
        n = len(data)
        if n == 0:
            return
        self.rx_ring.extend(data.tolist())
        # 波形: 最近 2048 点
        w = np.array(list(self.rx_ring)[-2048:], dtype=np.float64)
        t = np.arange(len(w)) / RX_FS * 1000.0
        self.panel_wave.setData(t, w)
        self.lbl_rx.setText(
            '接收中: 缓冲 %d 点 (%.2f ms)  幅值 %d~%d' % (
                len(self.rx_ring), len(self.rx_ring) / RX_FS * 1000.0,
                int(w.min()), int(w.max())))
        self.lbl_rx.setStyleSheet('color:#33cc33;font-weight:bold')
        # 频谱 + 瀑布图: 滑窗全缓冲 FFT
        if len(self.rx_ring) >= 2048:
            d = np.array(list(self.rx_ring), dtype=np.float64)
            m = len(d)
            win = np.hanning(m)
            F = np.abs(np.fft.fft((d - 2048.0) * win))
            f = np.fft.fftfreq(m, 1.0 / RX_FS)
            mask = (f >= CARRIER_FREQ - RX_SPAN) & (f <= CARRIER_FREQ + RX_SPAN)
            fm = f[mask]
            scale = 2.0 / (m * win.sum()) * 2.0
            db = 20 * np.log10(F[mask] * scale + 1e-9)
            pz = db.max()
            if pz > -100:
                db -= pz
            self.panel_rx.setData(fm, db)
            # 瀑布图: 映射到固定 bin 数 (频率轴固定 ±100k)
            wdb = np.interp(
                np.linspace(CARRIER_FREQ - RX_SPAN, CARRIER_FREQ + RX_SPAN,
                            WF_NBINS), fm, db).astype(np.float32)
            self.waterfall.add_row(wdb)

    # ---------------------------------------------------------- 频谱 (发射)
    def on_packet(self, seq, samples):
        self._pkt_count += len(samples)
        for iv, qv in samples:
            self.iq.append((iv, qv))

    def on_line(self, line):
        self.log('< ' + line)
        if line.startswith('STAT'):
            kv = line.split()
            d = {}
            for item in kv[1:]:
                if '=' in item:
                    k, _, v = item.partition('=')
                    try:
                        d[k.upper()] = int(v)
                    except ValueError:
                        pass
            self._last_stats = d
            self.apply_stats(d)

    def apply_stats(self, d):
        if 'SIDE' in d and d['SIDE'] != self.side:
            self.side = d['SIDE']
            self.btn_lsb.setChecked(self.side == 0)
            self.btn_usb.setChecked(self.side == 1)
            self.lbl_side.setText('边带: %s' % ('LSB' if self.side == 0 else 'USB'))
            # 若校准窗口开着, 同步
            if hasattr(self, '_calib_dlg') and self._calib_dlg is not None:
                self._calib_dlg._sync_from_owner()
        key = 'LSB' if self.side == 0 else 'USB'
        for name in ('IGAIN', 'QGAIN', 'PHASE', 'QUAD', 'IDC', 'QDC', 'AGAIN'):
            if name in d:
                self.cfg[key][name] = d[name]
                if hasattr(self, '_calib_dlg') and self._calib_dlg is not None:
                    self._calib_dlg.ctrl[name].set_value(d[name])
        if 'MODE' in d and d['MODE'] in MODE_NAMES:
            for k, b in self.mode_btns.items():
                b.setChecked(k == MODE_NAMES[d['MODE']])
        if 'TONE' in d:
            self.spin_tone.blockSignals(True)
            self.spin_tone.setValue(d['TONE'])
            self.spin_tone.blockSignals(False)
        if 'DECIM' in d and d['DECIM']:
            self.cmb_decim.blockSignals(True)
            self.cmb_decim.setCurrentText(str(d['DECIM']))
            self.cmb_decim.blockSignals(False)
        if 'STREAM' in d:
            self.stream_on = (d['STREAM'] != 0)
            self.btn_stream.setText('停止频谱流' if self.stream_on else '开启频谱流')
        if 'TX' in d:
            if d['TX']:
                self.lbl_tx.setText('● 发射中 (PC13/外部)')
                self.lbl_tx.setStyleSheet('color:#ff8800;font-weight:bold')
            else:
                self.lbl_tx.setText('● 静音')
                self.lbl_tx.setStyleSheet('color:#33ff33;font-weight:bold')

    def on_tick(self):
        now = time.time()
        if now - self._last_pkt_t >= 1.0:
            self.pkt_rate = self._pkt_count / (now - self._last_pkt_t)
            self._pkt_count = 0
            self._last_pkt_t = now
            self.lbl_pr.setText('%.0f/s' % self.pkt_rate)
        if self.stream_on and len(self.iq) >= 2048:
            self.update_spectrum()

    def update_spectrum(self):
        fs = SPLIT_OUT_FS / self.decim
        n = 8192 if self.decim == 1 else 4096
        if len(self.iq) < n:
            return
        arr = np.array(list(self.iq)[-n:], dtype=np.float64)
        I = arr[:, 0]
        Q = arr[:, 1]
        win = np.hanning(n)
        sign = 1.0 if self.side == 1 else -1.0   # USB 翻转 Q
        Z = I + sign * 1j * Q
        FZ = np.abs(np.fft.fft(Z * win))
        f = np.fft.fftfreq(n, 1.0 / fs)
        rf = CARRIER_FREQ + f
        mask = (rf >= CARRIER_FREQ - SPECTRUM_SPAN) & (rf <= CARRIER_FREQ + SPECTRUM_SPAN)
        rf_m = rf[mask]
        scale = 2.0 / (n * win.sum()) * 2.0
        dz = 20 * np.log10(FZ[mask] * scale + 1e-9)
        pz = dz.max()
        if pz > -100:
            dz -= pz
        self.panel_tx.setData(rf_m, dz)

    # ---------------------------------------------------------- 导出 C 配置
    def export_c_config(self, show_dialog=True):
        def fmt_cfg(key):
            c = self.cfg[key]
            ph = c['PHASE']
            return ('static const iq_cfg_t CFG_%s_DEFAULT = {\n'
                    '    %d, %d, PHASE_TO_OFF32(%d), %d, %d, %d, %d };'
                    % (key, c['IGAIN'], c['QGAIN'], ph, c['QUAD'],
                       c['IDC'], c['QDC'], c['AGAIN']))
        text = ('/* ---- 上位机导出的双配置 (粘贴替换 CFG_LSB/USB_DEFAULT) ---- */\n'
                + fmt_cfg('LSB') + '\n'
                + fmt_cfg('USB') + '\n')
        QtWidgets.QApplication.clipboard().setText(text)
        self.log('已导出 C 配置到剪贴板:\n' + text)
        if show_dialog:
            QtWidgets.QMessageBox.information(
                self, 'C 配置已复制',
                '两套配置已生成并复制到剪贴板.\n'
                '粘贴进 main.c 的 CFG_LSB_DEFAULT / CFG_USB_DEFAULT 即可.\n\n' + text)


def main():
    QtWidgets.QApplication.setAttribute(QtCore.Qt.AA_EnableHighDpiScaling, True)
    app = QtWidgets.QApplication(sys.argv)
    w = TunerWindow()
    w.show()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
