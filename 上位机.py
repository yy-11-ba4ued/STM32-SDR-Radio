#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""SSB-IQ-TUNER 主机上位机 (v3, 参照 19_上位机.py 结构)

架构: 上位机 --USART2--> 主机(屏幕驱动) --SPI--> 从机(TX)
当前阶段: 上位机直接连接主机 USART2 (115200 8N1)。
  * 屏幕测试页: 主机已实现命令, 立即可用 (PING/REDRAW/FILL/TXT/CLR)
  * 发射/接收/校准页: 命令经主机透传到从机, 覆盖 AM/FM/USB/LSB/CW/载波发射、
    五模式接收、频率、边带、PTT、音频增益、高通和 I/Q 校准。
  * 接收页不再回传频谱: 频谱直接显示在主机屏幕上(ILI9488)。

运行:  python 上位机.py     (需要 PyQt5 + pyserial; pyqtgraph 已不再使用)
"""
import sys
import time
import threading

import serial
from serial.tools import list_ports

from PyQt5 import QtCore, QtWidgets

# ------------------------- 常量 -------------------------
PHASE_UNIT  = 1000.0      # 1.0° = 1000 个 0.001° 单位
MODE_NAMES  = {0: 'SSB', 1: '纯载波', 4: '1k单音', 5: '静音', 6: 'CW', 7: 'NFM', 8: 'AM'}
MODE_CMDS   = {'FM': 7, 'AM': 8, 'USB': 0, 'LSB': 0, 'CW': 6, '载波': 1}
PARAM_ORDER = ['IGAIN', 'QGAIN', 'PHASE', 'QUAD', 'IDC', 'QDC', 'AGAIN']
CFG_LSB_DEFAULT = {'IGAIN': 12976, 'QGAIN': 38862, 'PHASE': 0,   'QUAD': -8127,
                   'IDC': 0, 'QDC': 0, 'AGAIN': 100}
CFG_USB_DEFAULT = {'IGAIN': 10944, 'QGAIN': 32767, 'PHASE': 0, 'QUAD': 6487,
                   'IDC': 0, 'QDC': 0, 'AGAIN': 64}


def clamp(v, lo, hi):
    return max(lo, min(hi, v))


# ------------------------- 串口线程 (文本行为主, 帧解析框架保留) -------------------------
class SerialWorker(QtCore.QThread):
    line = QtCore.pyqtSignal(str)
    error = QtCore.pyqtSignal(str)
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
        self.ser = serial.Serial(self.port, self.baud, timeout=0.1, write_timeout=1)
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
                    self._buf.extend(self.ser.read(n))
                    self._parse()
                else:
                    self.msleep(2)
            except serial.SerialException as e:
                if self.running:
                    self.error.emit('串口错误: %s' % e)
                break
        self.disconnected.emit()

    def _parse(self):
        """文本行解析; AA5A 二进制帧(频谱回传)解析框架保留, 待主机透传启用。"""
        while True:
            b = self._buf
            # 保留: 主机未来回传 AA 5A seq N_lo N_hi + N*int16 频谱帧时在此解析
            nl = b.find(b'\n')
            if nl < 0:
                if len(b) > 65536:
                    del b[:len(b) - 32768]
                return
            line = bytes(b[:nl]).decode('utf-8', 'replace').strip('\r')
            del b[:nl + 1]
            self.line.emit(line)

    def clear_buffer(self):
        self._buf.clear()
        if self.ser:
            try:
                self.ser.reset_input_buffer()
            except Exception:
                pass

    def stop(self):
        self.running = False
        if self.ser:
            try:
                self.ser.close()
            except Exception:
                pass
            self.ser = None


# ------------------------- 参数滑块 (校准用, 原版控件) -------------------------
class ParamSlider(QtWidgets.QWidget):
    changed = QtCore.pyqtSignal(str, int)

    def __init__(self, name, label, lo, hi, step, unit, display_scale=1.0, parent=None):
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


# ------------------------- 6 位数字频率控件 (SDR 风格, 原版控件) -------------------------
class DigitFreqWidget(QtWidgets.QWidget):
    freqChanged = QtCore.pyqtSignal(int)

    def __init__(self, parent=None):
        super().__init__(parent)
        self._freq = 465000
        self._hover = -1
        lay = QtWidgets.QHBoxLayout(self)
        lay.setContentsMargins(0, 0, 0, 0)
        lay.setSpacing(4)
        self._digits = []
        for _ in range(9):
            lab = QtWidgets.QLabel('0')
            lab.setAlignment(QtCore.Qt.AlignCenter)
            lab.setFixedSize(38, 52)
            lab.setStyleSheet(self._box_style(False))
            f = lab.font()
            f.setPointSize(16)
            f.setBold(True)
            f.setFamily('Consolas')
            lab.setFont(f)
            lab.installEventFilter(self)
            lay.addWidget(lab)
            self._digits.append(lab)
        self.setFocusPolicy(QtCore.Qt.WheelFocus)
        self._update()

    @staticmethod
    def _box_style(hot):
        if hot:
            return ('background:#ffd24d; color:#1a1a1a; border:2px solid #ffaa00; '
                    'border-radius:6px;')
        return ('background:#22262b; color:#e8e8e8; border:2px solid #3a414a; '
                'border-radius:6px;')

    def value(self):
        return self._freq

    def setValue(self, f):
        f = max(0, min(50000000, int(f)))
        if f != self._freq:
            self._freq = f
            self._update()

    def eventFilter(self, obj, ev):
        for i, lab in enumerate(self._digits):
            if obj is lab:
                if ev.type() == QtCore.QEvent.Enter:
                    self._set_hover(i)
                elif ev.type() == QtCore.QEvent.Leave:
                    if self._hover == i:
                        self._set_hover(-1)
                break
        return super().eventFilter(obj, ev)

    def wheelEvent(self, ev):
        if self._hover < 0:
            ev.ignore()
            return
        delta = ev.angleDelta().y()
        if delta == 0:
            return
        step = 10 ** (8 - self._hover)
        nf = self._freq + (step if delta > 0 else -step)
        nf = max(0, min(50000000, nf))
        if nf != self._freq:
            self._freq = nf
            self._update()
            self.freqChanged.emit(nf)
        ev.accept()

    def _set_hover(self, i):
        self._hover = i
        for k, lab in enumerate(self._digits):
            lab.setStyleSheet(self._box_style(k == i))

    def _update(self):
        txt = '%09d' % self._freq
        for k, lab in enumerate(self._digits):
            lab.setText(txt[k])
        self.setToolTip('当前频率 %d Hz, 悬停某一位滚轮调整 (0-50MHz)' % self._freq)


# ------------------------- 校准二级窗口 -------------------------
class CalibrationDialog(QtWidgets.QDialog):
    """I/Q 边带校准: 7 参数滑块 + 读取/下发/导出 C 配置"""

    def __init__(self, owner, parent=None):
        super().__init__(parent)
        self.owner = owner
        self.setWindowTitle('校准参数 (I/Q 边带校准) — 实时下发从机')
        self.setMinimumWidth(560)

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
            '滑块变化经主机 SPI 实时下发给从机')
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
        key = 'LSB' if self.owner.side == 0 else 'USB'
        for name in PARAM_ORDER:
            self.ctrl[name].set_value(self.owner.cfg[key][name])


# ------------------------- 主窗口 -------------------------
class TunerWindow(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle('SSB-IQ-TUNER — 主机上位机 v3 (参照 v21 结构)')
        self.resize(1100, 760)

        self.connected = False
        self.worker = None
        self.side = 0
        self.rx_mode = True
        self.rx_demod = 'AM'
        self.tx_mode = 'AM'
        self.freq_hz = 465000
        self.vfo_a_hz = 465000
        self.vfo_b_hz = 7051000
        self.active_vfo = 'A'
        self.nr_en = False
        self.nr_level = 1
        self.tx_key = False
        self.last_health = 0x3F
        # Full duplex is intentionally opt-in: it keeps RX ADC/PCM running
        # during TX, but must be validated on the actual SPI/audio hardware.
        self.full_duplex = False
        self.cfg = {'LSB': dict(CFG_LSB_DEFAULT), 'USB': dict(CFG_USB_DEFAULT)}

        # Tuning debounce: one TUNE command per settled frequency instead of a
        # VFO+FREQ+DEMOD burst on every wheel notch / digit step.  Created
        # before _build_ui() because the frequency widget connects to it.
        self._pending_tune = None
        self._tune_timer = QtCore.QTimer(self)
        self._tune_timer.setSingleShot(True)
        self._tune_timer.setInterval(60)
        self._tune_timer.timeout.connect(self._flush_tune)

        self._build_ui()
        self.log('就绪. 选择主机 USART2 串口后点"连接".')
        self.refresh_ports()
        self.heartbeat_timer = QtCore.QTimer(self)
        self.heartbeat_timer.setInterval(2000)
        self.heartbeat_timer.timeout.connect(self._heartbeat)
        self.heartbeat_timer.start()

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
        self.cmb_port.setMinimumWidth(220)
        bar.addWidget(self.cmb_port)
        self.btn_refresh = QtWidgets.QPushButton('刷新串口')
        self.btn_refresh.setMaximumWidth(80)
        self.btn_refresh.clicked.connect(self.refresh_ports)
        bar.addWidget(self.btn_refresh)
        self.cmb_baud = QtWidgets.QComboBox()
        for b in (921600, 115200, 460800, 230400):
            self.cmb_baud.addItem(str(b))
        self.cmb_baud.setCurrentText('921600')   # 主机 USART2 使用 921600
        bar.addWidget(self.cmb_baud)
        self.btn_conn = QtWidgets.QPushButton('连接')
        self.btn_conn.clicked.connect(self.toggle_connect)
        bar.addWidget(self.btn_conn)
        bar.addWidget(QtWidgets.QLabel('状态:'))
        self.lbl_status = QtWidgets.QLabel('未连接')
        self.lbl_status.setStyleSheet('color:gray; font-weight:bold;')
        bar.addWidget(self.lbl_status)
        bar.addSpacing(10)
        # v70: single PTT control replaces the old TX/RX selector.
        self.btn_ptt = QtWidgets.QPushButton('PTT 按住发射')
        self.btn_ptt.setAutoRepeat(False)
        self.btn_ptt.setStyleSheet(
            'QPushButton:pressed{background:#ff6666;font-weight:bold}')
        self.btn_ptt.pressed.connect(self.on_ptt_press)
        self.btn_ptt.released.connect(self.on_ptt_release)
        bar.addWidget(self.btn_ptt)
        self.btn_scr = QtWidgets.QPushButton('屏幕测试')
        self.btn_scr.setCheckable(True)
        self.btn_scr.setChecked(False)
        self.btn_scr.clicked.connect(lambda: self.set_page(2))
        bar.addWidget(self.btn_scr)
        self.lbl_rt = QtWidgets.QLabel('● 接收')
        self.lbl_rt.setStyleSheet('color:#ffaa33;font-weight:bold')
        bar.addWidget(self.lbl_rt)
        bar.addStretch(1)
        self.lbl_side = QtWidgets.QLabel('边带: LSB')
        self.lbl_side.setStyleSheet('font-size:12pt; font-weight:bold; color:#0066cc;')
        bar.addWidget(self.lbl_side)
        root.addLayout(bar)

        # ---- 三页 (发射 / 接收 / 屏幕测试) ----
        self.stack = QtWidgets.QStackedWidget()
        self.stack.addWidget(self._build_tx_page())   # 页0 = 发射
        self.stack.addWidget(self._build_rx_page())   # 页1 = 接收
        self.stack.addWidget(self._build_scr_page())  # 页2 = 屏幕测试
        root.addWidget(self.stack, 3)
        self.stack.setCurrentIndex(1)   # v3: 默认显示接收页

        # v70: independent RX/TX mode pickers, visible on every page.
        modebar = QtWidgets.QHBoxLayout()
        modebar.addWidget(QtWidgets.QLabel('RX 解调'))
        self.cmb_rx_mode = QtWidgets.QComboBox()
        self.cmb_rx_mode.addItems(['AM', 'FM', 'USB', 'LSB', 'CW'])
        self.cmb_rx_mode.setCurrentText(self.rx_demod)
        self.cmb_rx_mode.currentTextChanged.connect(self.set_rx_mode)
        modebar.addWidget(self.cmb_rx_mode)
        modebar.addSpacing(16)
        modebar.addWidget(QtWidgets.QLabel('TX 调制'))
        self.cmb_tx_mode = QtWidgets.QComboBox()
        self.cmb_tx_mode.addItems(['FM', 'AM', 'USB', 'LSB', 'CW', '载波'])
        self.cmb_tx_mode.setCurrentText(self.tx_mode)
        self.cmb_tx_mode.currentTextChanged.connect(self.set_tx_mode)
        modebar.addWidget(self.cmb_tx_mode)
        modebar.addStretch(1)
        root.insertLayout(1, modebar)

        # ---- 日志 ----
        lg = QtWidgets.QGroupBox('日志')
        lv = QtWidgets.QVBoxLayout(lg)
        lv.setContentsMargins(4, 4, 4, 4)
        self.log_view = QtWidgets.QPlainTextEdit()
        self.log_view.setReadOnly(True)
        self.log_view.setMaximumBlockCount(1000)
        self.log_view.setFixedHeight(120)
        lv.addWidget(self.log_view)
        root.addWidget(lg, 0)

    def _build_tx_page(self):
        """发射页: 调制方式 + 频率 + PTT + 校准"""
        page = QtWidgets.QWidget()
        lay = QtWidgets.QVBoxLayout(page)
        lay.setContentsMargins(2, 2, 2, 2)

        r1 = QtWidgets.QHBoxLayout()
        grp_mode = QtWidgets.QGroupBox('调制方式')
        h = QtWidgets.QHBoxLayout(grp_mode)
        self.tx_mode_btns = {}
        for name in ('FM', 'AM', 'USB', 'LSB', 'CW', '载波'):
            b = QtWidgets.QPushButton(name)
            b.setCheckable(True)
            b.clicked.connect(lambda _=False, n=name: self.set_tx_mode(n))
            self.tx_mode_btns[name] = b
            h.addWidget(b)
        self.tx_mode_btns['AM'].setChecked(True)   # v4: 发射/接收模式统一, 默认 AM
        r1.addWidget(grp_mode)
        r1.addStretch(1)
        lay.addLayout(r1)

        r2 = QtWidgets.QHBoxLayout()
        grp_tx = QtWidgets.QGroupBox('PTT 全双工发射')
        h = QtWidgets.QHBoxLayout(grp_tx)
        self.btn_tx = QtWidgets.QPushButton('按住 PTT 收发')
        self.btn_tx.setAutoRepeat(False)
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

        self.btn_calib = QtWidgets.QPushButton('校准参数...')
        self.btn_calib.setStyleSheet(
            'background:#3a3a5a; font-weight:bold; padding:6px;')
        self.btn_calib.clicked.connect(self.open_calibration)
        r2.addWidget(self.btn_calib)
        r2.addStretch(1)
        lay.addLayout(r2)

        note = QtWidgets.QLabel(
            '按住 PTT 时同时发射和接收，屏幕切到 TX；松开后只接收。\n'
            '两种状态下接收频谱持续刷新，发射波形显示已移除。')
        note.setStyleSheet('color:#888;')
        lay.addWidget(note)
        lay.addStretch(1)
        return page

    def _build_rx_page(self):
        """接收页: 解调模式 + 频率 + 音频 (频谱直接显示在主机屏幕, 不回传)"""
        page = QtWidgets.QWidget()
        lay = QtWidgets.QVBoxLayout(page)
        lay.setContentsMargins(2, 2, 2, 2)

        r1 = QtWidgets.QHBoxLayout()
        grp_mode = QtWidgets.QGroupBox('解调模式')
        h = QtWidgets.QHBoxLayout(grp_mode)
        self.rx_mode_btns = {}
        for name in ('AM', 'FM', 'USB', 'LSB', 'CW'):
            b = QtWidgets.QPushButton(name)
            b.setCheckable(True)
            b.clicked.connect(lambda _=False, n=name: self.set_rx_mode(n))
            self.rx_mode_btns[name] = b
            h.addWidget(b)
        self.rx_mode_btns['AM'].setChecked(True)
        r1.addWidget(grp_mode)
        r1.addStretch(1)
        lay.addLayout(r1)

        r2 = QtWidgets.QHBoxLayout()
        grp_freq = QtWidgets.QGroupBox('解调频率')
        h = QtWidgets.QHBoxLayout(grp_freq)
        h.addWidget(QtWidgets.QLabel('载波'))
        self.demod_freq = DigitFreqWidget()
        self.demod_freq.setValue(465000)
        self.demod_freq.freqChanged.connect(self.on_frequency_changed)
        h.addWidget(self.demod_freq)
        h.addWidget(QtWidgets.QLabel('Hz'))
        for f in (100000, 200000, 300000, 400000):
            btn = QtWidgets.QPushButton('%dk' % (f // 1000))
            btn.setMaximumWidth(50)
            btn.clicked.connect(lambda _=False, ff=f: self.set_demod_freq(ff))
            h.addWidget(btn)
        self.lbl_demod_status = QtWidgets.QLabel('待机')
        self.lbl_demod_status.setStyleSheet('color:gray;font-weight:bold')
        h.addWidget(self.lbl_demod_status)
        h.addStretch(1)
        r2.addWidget(grp_freq)
        r2.addStretch(1)
        lay.addLayout(r2)

        rv = QtWidgets.QHBoxLayout()
        grp_vfo = QtWidgets.QGroupBox('VFO A/B')
        h = QtWidgets.QHBoxLayout(grp_vfo)
        self.lbl_vfo_a = QtWidgets.QLabel('A: 465000 Hz')
        self.lbl_vfo_b = QtWidgets.QLabel('B: 7051000 Hz')
        self.btn_vfo_toggle = QtWidgets.QPushButton('切换到 VFO B')
        self.btn_vfo_toggle.clicked.connect(self.on_vfo_toggle)
        self.btn_vfo_store_b = QtWidgets.QPushButton('当前频率→B')
        self.btn_vfo_store_b.clicked.connect(self.on_vfo_store_b)
        h.addWidget(self.lbl_vfo_a)
        h.addWidget(self.lbl_vfo_b)
        h.addWidget(self.btn_vfo_toggle)
        h.addWidget(self.btn_vfo_store_b)
        h.addStretch(1)
        rv.addWidget(grp_vfo)
        rv.addStretch(1)
        lay.addLayout(rv)

        r3 = QtWidgets.QHBoxLayout()
        grp_audio = QtWidgets.QGroupBox('音频输出')
        h = QtWidgets.QHBoxLayout(grp_audio)
        h.addWidget(QtWidgets.QLabel('增益'))
        self.slider_audio_gain = QtWidgets.QSlider(1)
        self.slider_audio_gain.setRange(0, 100)
        self.slider_audio_gain.setValue(30)
        self.slider_audio_gain.setMaximumWidth(200)
        self.slider_audio_gain.valueChanged.connect(self.on_audio_gain_changed)
        h.addWidget(self.slider_audio_gain)
        self.lbl_audio_gain = QtWidgets.QLabel('-20dB')
        self.lbl_audio_gain.setMinimumWidth(55)
        h.addWidget(self.lbl_audio_gain)
        h.addSpacing(12)
        self.chk_nr = QtWidgets.QCheckBox('NR 降噪')
        self.chk_nr.stateChanged.connect(self.on_nr_changed)
        h.addWidget(self.chk_nr)
        self.sp_nr_level = QtWidgets.QSpinBox()
        self.sp_nr_level.setRange(1, 3)
        self.sp_nr_level.setValue(1)
        self.sp_nr_level.setPrefix('等级 ')
        self.sp_nr_level.valueChanged.connect(self.on_nr_changed)
        h.addWidget(self.sp_nr_level)
        h.addStretch(1)
        r3.addWidget(grp_audio)
        r3.addStretch(1)
        lay.addLayout(r3)

        r4 = QtWidgets.QHBoxLayout()
        grp_scale = QtWidgets.QGroupBox('频谱显示范围')
        h = QtWidgets.QHBoxLayout(grp_scale)
        h.addWidget(QtWidgets.QLabel('最低'))
        self.sp_sp_min = QtWidgets.QSpinBox()
        self.sp_sp_min.setRange(-140, -30)
        self.sp_sp_min.setValue(-100)
        self.sp_sp_min.setSuffix(' dBm')
        self.sp_sp_min.valueChanged.connect(self.on_spectrum_range_changed)
        h.addWidget(self.sp_sp_min)
        h.addWidget(QtWidgets.QLabel('最高'))
        self.sp_sp_max = QtWidgets.QSpinBox()
        self.sp_sp_max.setRange(-120, 20)
        self.sp_sp_max.setValue(-20)
        self.sp_sp_max.setSuffix(' dBm')
        self.sp_sp_max.valueChanged.connect(self.on_spectrum_range_changed)
        h.addWidget(self.sp_sp_max)
        h.addStretch(1)
        r4.addWidget(grp_scale)
        r4.addStretch(1)
        lay.addLayout(r4)

        # v3: 频谱区已删除 —— 频谱由主机屏幕直接显示, UART 不再回传频谱数据。
        note = QtWidgets.QLabel(
            '频谱已由主机屏幕直接显示 (ILI9488), 不再回传上位机。\n'
            '本页控制 (解调模式/频率/音频增益/高通) 通过 USART2 实时生效。')
        note.setStyleSheet('color:#888;')
        lay.addWidget(note, 1)
        return page

    def _build_scr_page(self):
        """屏幕测试页: 主机已实现命令, 立即可用"""
        page = QtWidgets.QWidget()
        lay = QtWidgets.QHBoxLayout(page)
        lay.setContentsMargins(10, 10, 10, 10)

        left = QtWidgets.QVBoxLayout()
        grp = QtWidgets.QGroupBox('通信测试')
        g = QtWidgets.QVBoxLayout(grp)
        self.btn_ping = QtWidgets.QPushButton('PING (通信测试)')
        self.btn_ping.clicked.connect(lambda: self.send_cmd('PING'))
        g.addWidget(self.btn_ping)
        self.btn_redraw = QtWidgets.QPushButton('REDRAW (重绘界面)')
        self.btn_redraw.clicked.connect(lambda: self.send_cmd('REDRAW'))
        g.addWidget(self.btn_redraw)
        self.btn_clr = QtWidgets.QPushButton('CLR (恢复频谱界面)')
        self.btn_clr.clicked.connect(lambda: self.send_cmd('CLR'))
        g.addWidget(self.btn_clr)
        left.addWidget(grp)

        grp2 = QtWidgets.QGroupBox('屏幕填充测试色')
        g2 = QtWidgets.QVBoxLayout(grp2)
        for name, rgb in (('红', (200, 40, 50)), ('绿', (40, 200, 80)),
                          ('蓝', (40, 120, 220)), ('黑', (0, 0, 0))):
            b = QtWidgets.QPushButton('FILL ' + name)
            b.clicked.connect(lambda _=False, c=rgb: self.send_cmd('FILL,%d,%d,%d' % c))
            g2.addWidget(b)
        g2.addWidget(QtWidgets.QLabel('自定义颜色'))
        row = QtWidgets.QHBoxLayout()
        self.sp_rgb = {}
        for key, dflt in (('R', 180), ('G', 120), ('B', 120)):
            row.addWidget(QtWidgets.QLabel(key))
            sp = QtWidgets.QSpinBox()
            sp.setRange(0, 255)
            sp.setValue(dflt)
            row.addWidget(sp)
            self.sp_rgb[key] = sp
        g2.addLayout(row)
        self.btn_fill_custom = QtWidgets.QPushButton('发送自定义填充')
        self.btn_fill_custom.clicked.connect(self._send_custom_fill)
        g2.addWidget(self.btn_fill_custom)
        left.addWidget(grp2)
        left.addStretch(1)

        right = QtWidgets.QVBoxLayout()
        grp3 = QtWidgets.QGroupBox('屏幕显示文字 (TXT,x,y,scale,text)')
        g3 = QtWidgets.QGridLayout(grp3)
        g3.addWidget(QtWidgets.QLabel('文字'), 0, 0)
        self.ent_txt = QtWidgets.QLineEdit()
        self.ent_txt.setPlaceholderText('Hello SSB-IQ-TUNER (ASCII)')
        g3.addWidget(self.ent_txt, 0, 1, 1, 3)
        g3.addWidget(QtWidgets.QLabel('X'), 1, 0)
        self.ent_x = QtWidgets.QSpinBox()
        self.ent_x.setRange(0, 460)
        self.ent_x.setValue(20)
        g3.addWidget(self.ent_x, 1, 1)
        g3.addWidget(QtWidgets.QLabel('Y'), 1, 2)
        self.ent_y = QtWidgets.QSpinBox()
        self.ent_y.setRange(0, 300)
        self.ent_y.setValue(120)
        g3.addWidget(self.ent_y, 1, 3)
        g3.addWidget(QtWidgets.QLabel('大小'), 2, 0)
        self.ent_sc = QtWidgets.QSpinBox()
        self.ent_sc.setRange(1, 3)
        self.ent_sc.setValue(2)
        g3.addWidget(self.ent_sc, 2, 1)
        self.btn_txt = QtWidgets.QPushButton('发送文字到屏幕')
        self.btn_txt.clicked.connect(self._send_txt)
        g3.addWidget(self.btn_txt, 2, 2, 1, 2)
        right.addWidget(grp3)
        right.addStretch(1)

        lay.addLayout(left, 1)
        lay.addLayout(right, 1)
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
        self.worker.error.connect(self.on_error)
        self.worker.disconnected.connect(self.on_disconnected)
        self.worker.start()
        self.connected = True
        self.btn_conn.setText('断开')
        self.lbl_status.setText('已连接 %s @%d' % (port, baud))
        self.lbl_status.setStyleSheet('color:green; font-weight:bold;')
        self.log('已连接 %s @%d' % (port, baud))
        self.send_cmd('HELLO')  # 双向连接握手
        self.send_cmd('PING')   # 主机连通性测试
        self.send_cmd('PTT 0')
        self.send_cmd('RX 1')
        self.send_cmd('VFO A %d' % self.vfo_a_hz)
        self.send_cmd('VFO B %d' % self.vfo_b_hz)
        self.send_cmd('VFO %s %d' % (self.active_vfo, self.freq_hz))
        self._send_mode_commands()
        self.on_audio_gain_changed(self.slider_audio_gain.value())
        self.on_nr_changed()

    def _heartbeat(self):
        if self.connected and self.worker:
            self.send_cmd('STAT')

    def disconnect(self):
        if self.worker:
            self.send_cmd('PTT 0')
            self.send_cmd('TX 0')
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
            self._apply_stats(d)

    def _apply_stats(self, d):
        if 'SIDE' in d and d['SIDE'] != self.side:
            self.side = d['SIDE']
            self.lbl_side.setText('边带: %s' % ('LSB' if self.side == 0 else 'USB'))
        if 'FREQ' in d:
            # Ignore a STAT that raced with a tuning step we have not sent yet,
            # otherwise the display snaps back to the previous frequency.
            if self._pending_tune is None and not self._tune_timer.isActive():
                self.freq_hz = clamp(int(d['FREQ']), 0, 50000000)
                self._store_active_vfo(self.freq_hz)
                self.demod_freq.setValue(self.freq_hz)
                self._update_vfo_labels()
        if 'SPMIN' in d:
            self.sp_sp_min.blockSignals(True)
            self.sp_sp_min.setValue(clamp(int(d['SPMIN']), -140, -30))
            self.sp_sp_min.blockSignals(False)
        if 'SPMAX' in d:
            self.sp_sp_max.blockSignals(True)
            self.sp_sp_max.setValue(clamp(int(d['SPMAX']), -120, 20))
            self.sp_sp_max.blockSignals(False)
        if 'NR' in d:
            self.nr_en = bool(d['NR'])
            self.chk_nr.blockSignals(True)
            self.chk_nr.setChecked(self.nr_en)
            self.chk_nr.blockSignals(False)
        if 'NRL' in d:
            self.nr_level = clamp(int(d['NRL']), 1, 3)
            self.sp_nr_level.blockSignals(True)
            self.sp_nr_level.setValue(self.nr_level)
            self.sp_nr_level.blockSignals(False)
        if 'MODE' in d:
            mode_map = {0: 'USB' if self.side else 'LSB', 1: '载波',
                        6: 'CW', 7: 'FM', 8: 'AM'}
            name = mode_map.get(int(d['MODE']))
            if name:
                self.tx_mode = name
                for k, b in self.tx_mode_btns.items():
                    b.setChecked(k == name)
                self.cmb_tx_mode.blockSignals(True)
                self.cmb_tx_mode.setCurrentText(name)
                self.cmb_tx_mode.blockSignals(False)
        if 'RXMODE' in d:
            mode_map = {0: 'AM', 1: 'FM', 2: 'USB', 3: 'LSB', 4: 'CW'}
            name = mode_map.get(int(d['RXMODE']))
            if name:
                self.rx_demod = name
                for k, b in self.rx_mode_btns.items():
                    b.setChecked(k == name)
                self.cmb_rx_mode.blockSignals(True)
                self.cmb_rx_mode.setCurrentText(name)
                self.cmb_rx_mode.blockSignals(False)
        if 'TXKEY' in d:
            self.tx_key = bool(d['TXKEY'])
            if self.tx_key:
                self.lbl_tx.setText('● 发射中')
                self.lbl_tx.setStyleSheet('color:#ff8800;font-weight:bold')
            else:
                self.lbl_tx.setText('● 静音')
                self.lbl_tx.setStyleSheet('color:#33ff33;font-weight:bold')
        if 'FDX' in d:
            self.full_duplex = bool(d['FDX'])
        if 'HEALTH' in d:
            h = int(d['HEALTH'])
            if h != self.last_health:
                self.last_health = h
                if h == 0x3F:
                    self.log('WD: all subsystems healthy')
                else:
                    self.log('WD: health=0x%02X (T2=%d T3=%d T4=%d MAIN=%d CHAIN=%d PCM=%d)'
                             % (h, h & 1, (h >> 1) & 1, (h >> 2) & 1,
                                (h >> 3) & 1, (h >> 4) & 1, (h >> 5) & 1))
        key = 'LSB' if self.side == 0 else 'USB'
        for name in PARAM_ORDER:
            if name in d:
                self.cfg[key][name] = d[name]

    # ---------------------------------------------------------- 发射/接收
    def set_page(self, idx):
        self.stack.setCurrentIndex(idx)
        self.btn_scr.setChecked(idx == 2)

    def _send_rx_mode(self):
        if self.rx_demod not in ('AM', 'FM', 'USB', 'LSB', 'CW'):
            return
        idx = {'AM': 0, 'FM': 1, 'USB': 2, 'LSB': 3, 'CW': 4}[self.rx_demod]
        self.send_cmd('DEMOD %d %d' % (self.freq_hz, idx))

    def _send_tx_mode(self):
        name = self.tx_mode
        if name == 'FM':
            self.send_cmd('MODE 7')
        elif name == 'AM':
            self.send_cmd('MODE 8')
        elif name == 'USB':
            self.send_cmd('SIDE 1')
            self.send_cmd('MODE 0')
        elif name == 'LSB':
            self.send_cmd('SIDE 0')
            self.send_cmd('MODE 0')
        elif name == 'CW':
            self.send_cmd('MODE 6')
        elif name == '载波':
            self.send_cmd('MODE 1')

    def _send_mode_commands(self):
        """Send the independent RX demod and TX modulation settings."""
        self._send_rx_mode()
        self._send_tx_mode()

    def _set_ptt_state(self, active):
        active = bool(active)
        if active == bool(self.tx_key):
            # Always repeat the release edge; this recovers a missed SPI
            # command or a PTT released while the UI was busy.
            self.send_cmd('PTT 1' if active else 'PTT 0')
            return
        self.tx_key = active
        self.rx_mode = not active
        if active:
            self.lbl_rt.setText('● 发射/接收')
            self.lbl_rt.setStyleSheet('color:#ff3333;font-weight:bold')
            self.lbl_tx.setText('● 发射中')
            self.lbl_tx.setStyleSheet('color:#ff8800;font-weight:bold')
            self.send_cmd('PTT 1')
        else:
            self.lbl_rt.setText('● 接收')
            self.lbl_rt.setStyleSheet('color:#ffaa33;font-weight:bold')
            self.lbl_tx.setText('● 静音')
            self.lbl_tx.setStyleSheet('color:#33ff33;font-weight:bold')
            self.send_cmd('PTT 0')

    def on_ptt_press(self):
        self._set_ptt_state(True)

    def on_ptt_release(self):
        self._set_ptt_state(False)

    def set_tx_mode(self, name):
        self.tx_mode = name
        for k, b in self.tx_mode_btns.items():
            b.setChecked(k == name)
        self.cmb_tx_mode.blockSignals(True)
        self.cmb_tx_mode.setCurrentText(name)
        self.cmb_tx_mode.blockSignals(False)
        if name == 'USB':
            self.side = 1
            self.lbl_side.setText('边带: USB')
        elif name == 'LSB':
            self.side = 0
            self.lbl_side.setText('边带: LSB')
        self._send_tx_mode()
        self.log('TX MODE -> %s' % name)

    def set_rx_mode(self, name):
        self.rx_demod = name
        for k, b in self.rx_mode_btns.items():
            b.setChecked(k == name)
        self.cmb_rx_mode.blockSignals(True)
        self.cmb_rx_mode.setCurrentText(name)
        self.cmb_rx_mode.blockSignals(False)
        if name == 'USB':
            self.side = 1
            self.lbl_side.setText('边带: USB')
        elif name == 'LSB':
            self.side = 0
            self.lbl_side.setText('边带: LSB')
        self._send_rx_mode()
        self.on_audio_gain_changed(self.slider_audio_gain.value())
        self.on_nr_changed()
        self.on_spectrum_range_changed()
        self.log('RX MODE -> %s' % name)

    def on_tx_press(self):
        self.on_ptt_press()

    def on_tx_release(self):
        self.on_ptt_release()

    def set_demod_freq(self, f):
        self.on_frequency_changed(f)

    def on_frequency_changed(self, value):
        f = clamp(int(value), 0, 50000000)
        self.freq_hz = f
        self._store_active_vfo(f)
        self.demod_freq.blockSignals(True)
        self.demod_freq.setValue(f)
        self.demod_freq.blockSignals(False)
        self._update_vfo_labels()
        # Debounce: send the final frequency once the control settles.
        self._pending_tune = f
        self._tune_timer.start()

    def _flush_tune(self):
        """Send a single TUNE command for the last requested frequency."""
        f = self._pending_tune
        if f is None or self.worker is None:
            return
        self._pending_tune = None
        self.send_cmd('TUNE %d' % f)
        self.lbl_demod_status.setText('调谐 %d Hz' % f)
        self.lbl_demod_status.setStyleSheet('color:#33ff33;font-weight:bold')

    def _retune_now(self, f):
        """Immediate retune (VFO switch etc.), bypassing the debounce."""
        self._pending_tune = None
        self._tune_timer.stop()
        self.send_cmd('TUNE %d' % f)
        self.on_demod_param_changed()
        self._update_vfo_labels()

    def _store_active_vfo(self, f):
        if self.active_vfo == 'A':
            self.vfo_a_hz = int(f)
        else:
            self.vfo_b_hz = int(f)

    def _update_vfo_labels(self):
        self.lbl_vfo_a.setText('A: %d Hz' % self.vfo_a_hz)
        self.lbl_vfo_b.setText('B: %d Hz' % self.vfo_b_hz)
        self.btn_vfo_toggle.setText('切换到 VFO B' if self.active_vfo == 'A'
                                    else '切换到 VFO A')

    def on_vfo_toggle(self):
        self._store_active_vfo(self.freq_hz)
        self.active_vfo = 'B' if self.active_vfo == 'A' else 'A'
        f = self.vfo_b_hz if self.active_vfo == 'B' else self.vfo_a_hz
        self.freq_hz = f
        self.demod_freq.blockSignals(True)
        self.demod_freq.setValue(f)
        self.demod_freq.blockSignals(False)
        # the host tracks which VFO is active, so it still needs the VFO line
        self.send_cmd('VFO %s %d' % (self.active_vfo, f))
        self._retune_now(f)
        self.log('VFO -> %s %d Hz' % (self.active_vfo, f))

    def on_vfo_store_b(self):
        self.vfo_b_hz = int(self.freq_hz)
        self.send_cmd('VFO B %d' % self.vfo_b_hz)
        if self.active_vfo == 'A':
            self.send_cmd('VFO A %d' % self.vfo_a_hz)
        self._update_vfo_labels()
        self.log('VFO B <- %d Hz' % self.vfo_b_hz)

    def on_spectrum_range_changed(self, _=None):
        lo = self.sp_sp_min.value()
        hi = self.sp_sp_max.value()
        if hi - lo < 10:
            if self.sender() is self.sp_sp_min:
                self.sp_sp_max.blockSignals(True)
                self.sp_sp_max.setValue(min(20, lo + 10))
                self.sp_sp_max.blockSignals(False)
            else:
                self.sp_sp_min.blockSignals(True)
                self.sp_sp_min.setValue(max(-140, hi - 10))
                self.sp_sp_min.blockSignals(False)
            lo = self.sp_sp_min.value(); hi = self.sp_sp_max.value()
        if self.connected and self.worker:
            self.send_cmd('SPMIN %d' % lo)
            self.send_cmd('SPMAX %d' % hi)

    def on_demod_param_changed(self):
        if self.worker is None:
            return
        mode_idx = 0
        mode_name = 'AM'
        for i, name in enumerate(('AM', 'FM', 'USB', 'LSB', 'CW')):
            if self.rx_mode_btns[name].isChecked():
                mode_name, mode_idx = name, i
                break
        freq = self.freq_hz
        self.send_cmd('DEMOD %d %d' % (freq, mode_idx))
        self.lbl_demod_status.setText('%s 解调中 %d Hz' % (mode_name, freq))
        self.lbl_demod_status.setStyleSheet('color:#33ff33;font-weight:bold')

    def on_audio_gain_changed(self, val):
        import math
        gain = 0.01 * (2000.0 ** (val / 100.0))
        db = 20 * math.log10(gain)
        self.lbl_audio_gain.setText('%+.0fdB' % db)
        if self.worker:
            self.send_cmd('DGAIN %d' % val)

    def on_nr_changed(self, _=None):
        self.nr_en = self.chk_nr.isChecked()
        self.nr_level = self.sp_nr_level.value()
        if self.worker:
            self.send_cmd('NR %d %d' % (1 if self.nr_en else 0, self.nr_level))

    # ---------------------------------------------------------- 校准
    def set_side(self, side):
        self.side = side
        self.lbl_side.setText('边带: %s' % ('LSB' if side == 0 else 'USB'))
        self.log('切换边带 -> %s' % ('LSB' if side == 0 else 'USB'))
        self.send_cmd('SIDE %d' % side)

    def on_param_changed(self, name, val):
        self.cfg['LSB' if self.side == 0 else 'USB'][name] = int(round(val))
        self.send_cmd('%s %d' % (name, int(round(val))))

    def apply_all_params(self):
        key = 'LSB' if self.side == 0 else 'USB'
        for name in PARAM_ORDER:
            self.send_cmd('%s %d' % (name, self.cfg[key][name]))
        self.log('已下发当前 %s 配置' % key)

    def cmd_stat(self):
        self.send_cmd('STAT')

    def open_calibration(self):
        dlg = CalibrationDialog(self, self)
        dlg.exec_()

    def export_c_config(self, show_dialog=True):
        def fmt_cfg(key):
            c = self.cfg[key]
            return ('static const iq_cfg_t CFG_%s_DEFAULT = {\n'
                    '    %d, %d, PHASE_TO_OFF32(%d), %d, %d, %d, %d };'
                    % (key, c['IGAIN'], c['QGAIN'], c['PHASE'], c['QUAD'],
                       c['IDC'], c['QDC'], c['AGAIN']))
        text = ('/* ---- 上位机导出的双配置 (粘贴替换 CFG_LSB/USB_DEFAULT) ---- */\n'
                + fmt_cfg('LSB') + '\n' + fmt_cfg('USB') + '\n')
        QtWidgets.QApplication.clipboard().setText(text)
        self.log('已导出 C 配置到剪贴板:\n' + text)
        if show_dialog:
            QtWidgets.QMessageBox.information(
                self, 'C 配置已复制', '两套配置已生成并复制到剪贴板.\n'
                '粘贴进 main.c 的 CFG_LSB_DEFAULT / CFG_USB_DEFAULT 即可.\n\n' + text)

    # ---------------------------------------------------------- 屏幕测试
    def _send_custom_fill(self):
        self.send_cmd('FILL,%d,%d,%d' % (self.sp_rgb['R'].value(),
                                         self.sp_rgb['G'].value(),
                                         self.sp_rgb['B'].value()))

    def _send_txt(self):
        txt = self.ent_txt.text().strip()
        if not txt:
            self.log('请输入要显示的文字')
            return
        self.send_cmd('TXT,%d,%d,%d,%s' % (self.ent_x.value(), self.ent_y.value(),
                                           self.ent_sc.value(), txt))


def main():
    QtWidgets.QApplication.setAttribute(QtCore.Qt.AA_EnableHighDpiScaling, True)
    app = QtWidgets.QApplication(sys.argv)
    w = TunerWindow()
    w.show()
    sys.exit(app.exec_())


if __name__ == '__main__':
    main()
