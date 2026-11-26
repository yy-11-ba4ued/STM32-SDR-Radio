#!/usr/bin/env python3
"""
字库生成器 - 从TTF字体生成STM32可用的C头文件
用法: python font_generator.py
"""
import tkinter as tk
from tkinter import ttk, filedialog, messagebox
from PIL import Image, ImageDraw, ImageFont
import os

# 字符集
CHARS = " .:+-/()0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

class FontGenerator:
    def __init__(self, root):
        self.root = root
        self.root.title("字库生成器")
        self.root.geometry("700x600")
        
        # State
        self.font_path = tk.StringVar(value="C:/Windows/Fonts/segoeui.ttf")
        self.font_size = tk.IntVar(value=20)
        self.cell_w = tk.IntVar(value=13)
        self.cell_h = tk.IntVar(value=20)
        self.char_width = tk.IntVar(value=11)  # visible char width
        self.padding = tk.IntVar(value=0)
        
        self.build_ui()
        self.render_preview()
    
    def build_ui(self):
        # Top frame - controls
        top = ttk.LabelFrame(self.root, text="字体设置")
        top.pack(fill=tk.X, padx=5, pady=5)
        
        ttk.Label(top, text="字体文件:").grid(row=0, column=0, sticky=tk.W, padx=5, pady=3)
        ttk.Entry(top, textvariable=self.font_path, width=50).grid(row=0, column=1, padx=5)
        ttk.Button(top, text="浏览...", command=self.browse_font).grid(row=0, column=2, padx=5)
        
        ttk.Label(top, text="字号:").grid(row=1, column=0, sticky=tk.W, padx=5, pady=3)
        ttk.Spinbox(top, from_=8, to=40, textvariable=self.font_size, width=8,
                    command=self.render_preview).grid(row=1, column=1, sticky=tk.W, padx=5)
        
        ttk.Label(top, text="字宽(像素):").grid(row=2, column=0, sticky=tk.W, padx=5, pady=3)
        ttk.Spinbox(top, from_=6, to=20, textvariable=self.char_width, width=8,
                    command=self.render_preview).grid(row=2, column=1, sticky=tk.W, padx=5)
        
        ttk.Label(top, text="字高(像素):").grid(row=3, column=0, sticky=tk.W, padx=5, pady=3)
        ttk.Spinbox(top, from_=8, to=30, textvariable=self.cell_h, width=8,
                    command=self.render_preview).grid(row=3, column=1, sticky=tk.W, padx=5)
        
        ttk.Button(top, text="重新渲染", command=self.render_preview).grid(row=4, column=0, columnspan=3, pady=5)
        
        # Preview area
        self.preview_frame = ttk.LabelFrame(self.root, text="预览")
        self.preview_frame.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        self.preview_canvas = tk.Canvas(self.preview_frame, bg="black")
        self.preview_canvas.pack(fill=tk.BOTH, expand=True)
        
        # Export buttons
        bottom = ttk.Frame(self.root)
        bottom.pack(fill=tk.X, padx=5, pady=5)
        ttk.Button(bottom, text="生成 C 头文件 (16位宽)", command=lambda: self.export_header(16)).pack(side=tk.LEFT, padx=5)
        ttk.Button(bottom, text="生成 C 头文件 (8位宽)", command=lambda: self.export_header(8)).pack(side=tk.LEFT, padx=5)
    
    def browse_font(self):
        path = filedialog.askopenfilename(
            filetypes=[("字体文件", "*.ttf *.otf"), ("所有文件", "*.*")],
            initialdir="C:/Windows/Fonts"
        )
        if path:
            self.font_path.set(path)
            self.render_preview()
    
    def render_char(self, ch, font, cw, ch_h):
        """Render a single character to a binary bitmap"""
        tmp = Image.new('L', (cw*4, ch_h*4), 0)
        d = ImageDraw.Draw(tmp)
        bbox = d.textbbox((0,0), ch, font=font)
        tw, th = bbox[2]-bbox[0], bbox[3]-bbox[1]
        # Center
        x = (cw*4 - tw) // 2 - bbox[0]
        y = (ch_h*4 - th) // 2 - bbox[1]
        d.text((x, y), ch, fill=255, font=font)
        # Downscale to target size
        tmp = tmp.resize((cw, ch_h), Image.LANCZOS)
        return list(tmp.getdata())
    
    def render_preview(self):
        try:
            font = ImageFont.truetype(self.font_path.get(), self.font_size.get()*4)
        except:
            return
        
        cw = self.char_width.get()
        ch_h = self.cell_h.get()
        
        # Render preview
        cols = 20
        rows = (len(CHARS) + cols - 1) // cols
        pw = cols * (cw+2) + 10
        ph = rows * (ch_h+2) + 10
        self.preview_canvas.config(width=pw, height=ph)
        self.preview_canvas.delete("all")
        
        for i, ch in enumerate(CHARS):
            bitmap = self.render_char(ch, font, cw, ch_h)
            col = i % cols
            row = i // cols
            ox = 5 + col * (cw+2)
            oy = 5 + row * (ch_h+2)
            for py in range(ch_h):
                for px in range(cw):
                    if bitmap[py*cw + px] > 128:
                        self.preview_canvas.create_rectangle(
                            ox+px, oy+py, ox+px+1, oy+py+1, fill="white", outline="")
            # Label
            self.preview_canvas.create_text(ox, oy-8, text=repr(ch), fill="gray", font=("Arial", 6))
    
    def export_header(self, bits_per_pixel):
        """Generate C header file"""
        try:
            font = ImageFont.truetype(self.font_path.get(), self.font_size.get()*4)
        except Exception as e:
            messagebox.showerror("错误", f"加载字体失败: {e}")
            return
        
        cw = self.char_width.get()
        ch_h = self.cell_h.get()
        bytes_per_char = ch_h * (2 if bits_per_pixel == 16 else 1)
        
        lines = []
        lines.append(f"/* Auto-generated font: {os.path.basename(self.font_path.get())}")
        lines.append(f" * Size: {cw}x{ch_h}, {len(CHARS)} chars")
        lines.append(f" * Char order: {CHARS}")
        lines.append(f" * Each char: {ch_h} rows x {2 if bits_per_pixel==16 else 1} byte(s)")
        lines.append(f" */")
        
        if bits_per_pixel == 16:
            lines.append(f"static const uint8_t font_{cw}x{ch_h}[][{ch_h*2}] = {{")
            for ch in CHARS:
                bitmap = self.render_char(ch, font, cw, ch_h)
                row_bytes = []
                for row in range(ch_h):
                    # Pack cw bits into 2 bytes (big-endian)
                    v = 0
                    for bit in range(cw):
                        if bitmap[row*cw + bit] > 128:
                            v |= (1 << (15 - bit))
                    row_bytes.append(f"0x{(v>>8)&0xFF:02X},0x{v&0xFF:02X}")
                lines.append(f'  /* {repr(ch)} */ {{{",".join(row_bytes)}}},')
            lines.append("};")
        else:
            lines.append(f"static const uint8_t font_{cw}x{ch_h}[][{ch_h}] = {{")
            for ch in CHARS:
                bitmap = self.render_char(ch, font, cw, ch_h)
                row_bytes = []
                for row in range(ch_h):
                    v = 0
                    for bit in range(cw):
                        if bitmap[row*cw + bit] > 128:
                            v |= (1 << (7 - bit))
                    row_bytes.append(f"0x{v:02X}")
                lines.append(f'  /* {repr(ch)} */ {{{",".join(row_bytes)}}},')
            lines.append("};")
        
        out_path = filedialog.asksaveasfilename(
            defaultextension=".h",
            filetypes=[("Header file", "*.h")],
            initialfile=f"font_{cw}x{ch_h}.h"
        )
        if out_path:
            with open(out_path, 'w', encoding='utf-8') as f:
                f.write('\n'.join(lines))
            messagebox.showinfo("成功", f"字库已保存到:\n{out_path}\n{len(CHARS)} 个字符, {cw}x{ch_h}")

if __name__ == '__main__':
    root = tk.Tk()
    app = FontGenerator(root)
    root.mainloop()
