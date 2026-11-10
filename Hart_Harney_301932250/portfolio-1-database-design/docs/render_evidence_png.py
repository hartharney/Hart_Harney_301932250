#!/usr/bin/env python3
"""Render terminal-capture text files as PNG screenshots for portfolio evidence."""
from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont


def render_text_png(text: str, out_path: Path, title: str | None = None) -> None:
    font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf", 14)
    title_font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 16)
    lines = text.splitlines() or [""]
    if title:
        lines = [title, ""] + lines
    padding = 24
    line_h = 20
    width = max(900, max(len(l) for l in lines) * 9 + padding * 2)
    height = padding * 2 + line_h * len(lines)
    img = Image.new("RGB", (width, height), (18, 24, 32))
    draw = ImageDraw.Draw(img)
    y = padding
    for i, line in enumerate(lines):
        color = (120, 200, 255) if title and i == 0 else (220, 230, 240)
        draw.text((padding, y), line, fill=color, font=title_font if title and i == 0 else font)
        y += line_h
    out_path.parent.mkdir(parents=True, exist_ok=True)
    img.save(out_path)
    print(f"wrote {out_path}")


def main() -> None:
    if len(sys.argv) < 3:
        print("usage: render_evidence_png.py <input.txt> <output.png> [title]")
        sys.exit(1)
    src = Path(sys.argv[1])
    dst = Path(sys.argv[2])
    title = sys.argv[3] if len(sys.argv) > 3 else None
    render_text_png(src.read_text(encoding="utf-8", errors="replace"), dst, title)


if __name__ == "__main__":
    main()
