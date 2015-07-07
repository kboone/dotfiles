from skimage import color
import numpy as np

colors = [
     ("base03",  (15., +00., -05.)),
     ("base02",  (20., +00., -05.)),
     ("base01",  (45., -01., -05.)),
     ("base00",  (50., -01., -05.)),
     ("base0",   (60., -01., -02.)),
     ("base1",   (65., -01., -02.)),
     ("base2",   (92., -00., +02.)),
     ("base3",   (97., +00., +02.)),
     ("yellow",  (60., +10., +65.)),
     ("orange",  (45., +30., +35.)),
     ("red",     (50., +35., +25.)),
     ("magenta", (45., +35., -05.)),
     ("violet",  (45., +15., -35.)),
     ("blue",    (55., -10., -25.)),    # class/function name
     ("cyan",    (55., -20., +15.)),    # comments
     ("green",   (60., -10., +75.)),    # def, class, etc.
]

lab_colors = [i[1] for i in colors]
color_labels = [i[0] for i in colors]

rgb_colors = color.lab2rgb([lab_colors])[0] * 255

hex_colors = []
for rgb_color in rgb_colors:
    hex_color = ""
    for val in rgb_color:
        if hex_color:
            hex_color += "/"
        hex_color += '%02x' % int(np.round(val))
    hex_colors.append(hex_color)

color_text = []
for label, hex_color in zip(color_labels, hex_colors):
    color_text.append("%s=\"%s\"" % (label, hex_color))

template = open("set_colorscheme_template.sh")

out_str = ""
for line in template:
    if line == "COLOR_DEFINITIONS_HERE\n":
        next_line = "\n".join(color_text) + "\n"
    else:
        next_line = line
    out_str += (next_line)

out_file = open("set_colorscheme.sh", "w")
print >>out_file, out_str
