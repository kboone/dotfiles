#!/usr/bin/env python
from skimage import color
import numpy as np
import os
import glob

colors = [
     ("base03",  (10., +00., -05.)),
     ("base02",  (15., +00., -05.)),
     ("base01",  (45., -01., -05.)),
     ("base00",  (50., -01., -05.)),
     ("base0",   (60., -01., -02.)),
     ("base1",   (65., -01., -02.)),
     ("base2",   (92., -00., +05.)),
     ("base3",   (97., +00., +05.)),
     ("yellow",  (60., -10., +75.)),
     ("orange",  (55., +10., +65.)),
     ("red",     (50., +30., +35.)),
     ("pink",    (50., +45., +10.)),
     ("magenta", (50., +30., -15.)),
     ("violet",  (50., +15., -35.)),
     ("blue",    (55., -10., -25.)),
     ("green",   (55., -20., +15.)),
]

lab_colors = [i[1] for i in colors]
color_labels = [i[0] for i in colors]

rgb_colors = (color.lab2rgb([lab_colors])[0] * 255).astype(int)

for label, (r, g, b) in zip(color_labels, rgb_colors):
    test_str = '███ abcdefghijklmnopqrstuvwxyz'
    print(f"\033[38;2;{int(r)};{int(g)};{int(b)}m{test_str} {label}\033[0m")

for template_path in glob.glob('**/*.template'):
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
