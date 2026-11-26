#!/usr/bin/env python3
"""
SDR 屏幕 UI 设计器
- Tkinter GUI，模拟 480x320 屏幕
- 拖拽/调整每个UI元素
- 串口实时发送命令到STM32
- 导出C布局代码
"""
import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import json
import serial
import serial.tools.list_ports

# ============ UI元素定义 ============
ELEMENTS = [
    # (id, name, type, default_x, default_y, default_w, default_h, default_color, default_text)
    ("rx_box",        "RX框",       "rect",   5,   5,  67, 47,  "red",   "RX"),
    ("pwr_text",     "PWR",        "text",  82,   6,  70, 16,  "white", "PWR: 10W"),
    ("gain_text",     "GAIN",       "text",  82,  28,  70, 16,  "white", "GAIN: +0dB"),
    ("sideband",     "边带指示",    "shape",200,  15,  60, 22,  "grey",  ""),
    ("khz_label",    "3KHz",       "text", 265,  22,  40, 12,  "white", "3KHz"),
    ("status_circle", "状态圆",      "circle",309, 17,  22, 22, "green", ""),
    ("temp",         "温度",       "text", 338,  18,  35, 12,  "white", "32C"),
    ("battery",      "电池",       "rect",380,  18,  31, 16,  "white", ""),
    ("batt_pct",     "电量%",      "text", 416,   8,  35, 10,  "white", "70%"),
    ("batt_volt",    "电压",       "text", 416,  24,  35, 10,  "white", "12.4v"),
    ("current_box",  "电流框",     "rect",438,  12,  41, 24,  "grey",  ""),
    ("current_val",  "电流值",     "text", 441,  18,  36, 12,  "white", "0.52A"),
    ("pc_icon",      "电脑图标",    "rect",  8,  70,  22, 20,  "grey",  ""),
    ("usb_box",      "USB框",      "rect", 38,  68,  50, 30,  "white", ""),
    ("usb_text",     "USB文字",    "text", 45,  76,  40, 12,  "white", "USB"),
    ("main_freq",    "主频率",     "text", 95,  56, 200, 40,  "white", "14.270.000"),
    ("freq_arrow",   "频率箭头",    "shape",235, 50,  10, 10,  "white", ""),
    ("vfo_a_tx",     "VFO A TX",   "text",395,  62,  70, 12,  "white", "VFO A TX"),
    ("xit",          "XIT",       "text",395,  82,  70, 12,  "white", "XIT +0k"),
    ("vfo_a",        "VFO A",     "text",395, 102,  70, 12,  "white", "VFO A"),
    ("spwr_label",   "S/PWR",     "text",  8, 120,  55, 12,  "white", "S/PWR"),
    ("s_meter",      "S表进度条",   "rect", 65, 122, 140, 13,  "blue",  ""),
    ("ovf_label",    "OVF",       "text", 90, 138,  30, 10,  "red",   "OVF"),
    ("s9_label",     "S9+20",     "text",120, 138,  45, 10,  "yellow","S9+20"),
    ("dbm_label",    "-74dBm",    "text",165, 138,  45, 10,  "green", "-74dBm"),
    ("vfo_b_freq",   "VFO B频率",  "text",220, 120,  55, 12,  "white", "7.050"),
    ("vfo_b_label",  "VFO B",     "text",220, 138,  50, 10,  "grey",  "VFO B"),
    ("swr_label",    "SWR",       "text",290, 120,  40, 12,  "white", "SWR"),
    ("swr_meter",    "SWR进度条",  "rect",335, 122, 140, 13,  "blue",  ""),
    ("swr_1",        "SWR 1.0",   "text",335, 138,  25, 10,  "grey",  "1.0"),
    ("swr_15",       "SWR 1.5",   "text",375, 138,  25, 10,  "grey",  "1.5"),
    ("swr_2",        "SWR 2.0",   "text",405, 138,  25, 10,  "red",   "2.0"),
    ("swr_3",        "SWR 3.0",   "text",435, 138,  25, 10,  "grey",  "3.0"),
    ("swr_high",     "SWR HIGH",  "text",445, 150,  35, 10,  "red",   "HIGH"),
    ("spectrum",     "频谱区",     "rect",  5, 155, 471, 90,  "grey",  ""),
    ("wf",           "瀑布图",     "rect",  5, 260, 471, 56,  "grey",  ""),
    ("fps",          "FPS",       "text",  2, 305,  40, 10,  "grey",  "FPS"),
]

COLORS = {
    "black": "#131313", "white": "#DDDDDD", "grey": "#888888",
    "red": "#DC3232", "green": "#28C850", "yellow": "#E6C828",
    "blue": "#2878DC", "dark": "#282828",
}

class UIDesigner:
    def __init__(self, root):
        self.root = root
        self.root.title("SDR 屏幕 UI 设计器")
        self.root.geometry("900x650")
        
        self.ser = None
        self.selected_id = None
        self.elems = {}  # id -> dict
        for e in ELEMENTS:
            self.elems[e[0]] = {
                "name": e[1], "type": e[2],
                "x": e[3], "y": e[4], "w": e[5], "h": e[6],
                "color": e[7], "text": e[8],
            }
        
        self.build_ui()
        self.redraw_canvas()
    
    def build_ui(self):
        # Left: canvas preview
        left = ttk.Frame(self.root)
        left.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        self.canvas = tk.Canvas(left, width=480, height=320, bg="#131313", cursor="crosshair")
        self.canvas.pack()
        self.canvas.bind("<Button-1>", self.on_click)
        self.canvas.bind("<B1-Motion>", self.on_drag)
        self.canvas.bind("<ButtonRelease-1>", self.on_release)
        
        # Right: controls
        right = ttk.Frame(self.root)
        right.pack(side=tk.RIGHT, fill=tk.Y, padx=5, pady=5)
        
        # Serial
        sf = ttk.LabelFrame(right, text="串口")
        sf.pack(fill=tk.X, pady=3)
        self.port_cb = ttk.Combobox(sf, width=12)
        self.port_cb.pack(side=tk.LEFT, padx=3)
        self.refresh_ports()
        ttk.Button(sf, text="刷新", command=self.refresh_ports).pack(side=tk.LEFT)
        self.conn_btn = ttk.Button(sf, text="连接", command=self.toggle_conn)
        self.conn_btn.pack(side=tk.LEFT, padx=3)
        
        # Element list
        ef = ttk.LabelFrame(right, text="元素列表")
        ef.pack(fill=tk.BOTH, expand=True, pady=3)
        self.elem_list = tk.Listbox(ef, width=25, height=20)
        self.elem_list.pack(fill=tk.BOTH, expand=True)
        for e in ELEMENTS:
            self.elem_list.insert(tk.END, e[1])
        self.elem_list.bind("<<ListboxSelect>>", self.on_select_list)
        
        # Properties
        pf = ttk.LabelFrame(right, text="属性")
        pf.pack(fill=tk.X, pady=3)
        self.props = {}
        for attr, label in [("x", "X"), ("y", "Y"), ("w", "宽"), ("h", "高")]:
            row = ttk.Frame(pf)
            row.pack(fill=tk.X, pady=1)
            ttk.Label(row, text=label, width=6).pack(side=tk.LEFT)
            var = tk.StringVar()
            ent = ttk.Entry(row, textvariable=var, width=8)
            ent.pack(side=tk.LEFT)
            ent.bind("<Return>", lambda e, a=attr: self.apply_prop(a))
            self.props[attr] = var
        
        # Buttons
        bf = ttk.Frame(right)
        bf.pack(fill=tk.X, pady=5)
        ttk.Button(bf, text="导出C代码", command=self.export_c).pack(fill=tk.X, pady=2)
        ttk.Button(bf, text="发送全部", command=self.send_all).pack(fill=tk.X, pady=2)
        ttk.Button(bf, text="保存JSON", command=self.save_json).pack(fill=tk.X, pady=2)
        ttk.Button(bf, text="加载JSON", command=self.load_json).pack(fill=tk.X, pady=2)
    
    def refresh_ports(self):
        ports = [p.device for p in serial.tools.list_ports.comports()]
        self.port_cb['values'] = ports
        if ports:
            self.port_cb.current(0)
    
    def toggle_conn(self):
        if self.ser and self.ser.is_open:
            self.ser.close()
            self.conn_btn.config(text="连接")
        else:
            try:
                self.ser = serial.Serial(self.port_cb.get(), 115200, timeout=1)
                self.conn_btn.config(text="断开")
            except Exception as e:
                messagebox.showerror("错误", str(e))
    
    def send_cmd(self, cmd):
        if self.ser and self.ser.is_open:
            self.ser.write((cmd + "\n").encode())
    
    def on_click(self, e):
        # Find element at click position
        for eid, elem in reversed(self.elems.items()):
            if elem["x"] <= e.x <= elem["x"]+elem["w"] and elem["y"] <= e.y <= elem["y"]+elem["h"]:
                self.selected_id = eid
                self.drag_start = (e.x, e.y, elem["x"], elem["y"])
                self.update_props()
                self.redraw_canvas()
                break
    
    def on_drag(self, e):
        if self.selected_id and hasattr(self, 'drag_start'):
            dx = e.x - self.drag_start[0]
            dy = e.y - self.drag_start[1]
            elem = self.elems[self.selected_id]
            elem["x"] = self.drag_start[2] + dx
            elem["y"] = self.drag_start[3] + dy
            self.update_props()
            self.redraw_canvas()
            # Send position
            self.send_cmd(f"POS,{self.selected_id},{elem['x']},{elem['y']}")
    
    def on_release(self, e):
        if hasattr(self, 'drag_start'):
            del self.drag_start
    
    def on_select_list(self, e):
        sel = self.elem_list.curselection()
        if sel:
            self.selected_id = ELEMENTS[sel[0]][0]
            self.update_props()
            self.redraw_canvas()
    
    def update_props(self):
        if not self.selected_id:
            return
        elem = self.elems[self.selected_id]
        self.props["x"].set(elem["x"])
        self.props["y"].set(elem["y"])
        self.props["w"].set(elem["w"])
        self.props["h"].set(elem["h"])
    
    def apply_prop(self, attr):
        if not self.selected_id:
            return
        try:
            val = int(self.props[attr].get())
            self.elems[self.selected_id][attr] = val
            self.redraw_canvas()
            self.send_cmd(f"POS,{self.selected_id},{self.elems[self.selected_id]['x']},{self.elems[self.selected_id]['y']}")
        except:
            pass
    
    def redraw_canvas(self):
        self.canvas.delete("all")
        for eid, elem in self.elems.items():
            x, y, w, h = elem["x"], elem["y"], elem["w"], elem["h"]
            color = COLORS.get(elem["color"], "#888")
            selected = (eid == self.selected_id)
            
            if elem["type"] == "rect":
                self.canvas.create_rectangle(x, y, x+w, y+h, outline=color, width=2 if selected else 1)
            elif elem["type"] == "circle":
                self.canvas.create_oval(x, y, x+w, y+h, fill=color, outline="white", width=2 if selected else 1)
            elif elem["type"] == "text":
                self.canvas.create_text(x, y, text=elem["text"], fill=color, anchor="nw", font=("Arial", 9))
            elif elem["type"] == "shape":
                self.canvas.create_rectangle(x, y, x+w, y+h, outline=color, width=1)
            
            if selected:
                # Resize handles
                self.canvas.create_rectangle(x+w-3, y+h-3, x+w+3, y+h+3, fill="red", outline="red")
    
    def send_all(self):
        for eid, elem in self.elems.items():
            self.send_cmd(f"POS,{eid},{elem['x']},{elem['y']},{elem['w']},{elem['h']}")
    
    def export_c(self):
        lines = ["/* Auto-generated UI layout from designer */"]
        for eid, elem in self.elems.items():
            lines.append(f'/* {elem["name"]} */')
            lines.append(f'#define {eid.upper()}_X  {elem["x"]}')
            lines.append(f'#define {eid.upper()}_Y  {elem["y"]}')
            lines.append(f'#define {eid.upper()}_W  {elem["w"]}')
            lines.append(f'#define {eid.upper()}_H  {elem["h"]}')
        code = '\n'.join(lines)
        path = filedialog.asksaveasfilename(defaultextension=".h", filetypes=[("Header", "*.h")])
        if path:
            with open(path, 'w', encoding='utf-8') as f:
                f.write(code)
            messagebox.showinfo("成功", f"已导出到 {path}")
    
    def save_json(self):
        path = filedialog.asksaveasfilename(defaultextension=".json", filetypes=[("JSON", "*.json")])
        if path:
            with open(path, 'w') as f:
                json.dump(self.elems, f, indent=2)
    
    def load_json(self):
        path = filedialog.askopenfilename(filetypes=[("JSON", "*.json")])
        if path:
            with open(path) as f:
                self.elems.update(json.load(f))
            self.redraw_canvas()

if __name__ == '__main__':
    root = tk.Tk()
    app = UIDesigner(root)
    root.mainloop()
