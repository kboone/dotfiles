#!/usr/bin/env python
from skimage import color
import numpy as np
import os
import glob

colors = [
     ("base03",  (10., -00., -5.)),
     ("base02",  (15., -00., -5.)),
     ("base22",  (40., -00., -5.)),
     ("base01",  (45., -00., -5.)),
     ("base00",  (55., -00., -5.)),
     ("base0",   (60., -00., +00.)),
     ("base1",   (65., +00., +00.)),
     ("base2",   (92., -00., +05.)),
     ("base3",   (97., +00., +05.)),
     ("red",     (55., +35., +25.)),
     ("orange",  (60., +10., +50.)),
     ("yellow",  (65., -10., +55.)),
     ("green",   (60., -30., +25.)),
     ("blue",    (60., -10., -25.)),
     ("violet",  (55., +25., -45.)),
     ("magenta", (55., +40., -15.)),
]

lab_colors = [i[1] for i in colors]
color_labels = [i[0] for i in colors]

rgb_colors = (color.lab2rgb([lab_colors])[0] * 255).astype(int)

for label, (r, g, b) in zip(color_labels, rgb_colors):
    test_str = f'███ abcdefghijklmnopqrstuvwxyz {r:3d} {g:3d} {b:3d} {label}'
    print(f"\033[38;2;{int(r)};{int(g)};{int(b)}m{test_str}\033[0m")

for template_path in glob.glob('**/*.template', recursive=True):
    path, ext = os.path.splitext(template_path)
    print(f"Parsing {path} ...")

    template_file = open(template_path)

    # Read the format that the hex code should be in.
    line = template_file.readline()
    rgb_format = line.split('"')[-2]

    theme = template_file.read()

    hex_colors = []
    for r, g, b in rgb_colors:
        hex_color = rgb_format.format(r=r, g=g, b=b)
        hex_colors.append(hex_color)

    for label, hex_color in zip(color_labels, hex_colors):
        theme = theme.replace(f"@{label}", hex_color)

    outfile = open(path, "w")
    print(theme, file=outfile)
