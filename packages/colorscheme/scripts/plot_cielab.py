from skimage import color
import numpy as np
from matplotlib import pyplot as plt

def plot_cielab(l):
    min_range = -110
    max_range = 110
    ab_range = np.linspace(min_range, max_range, 100)

    a, b = np.meshgrid(ab_range, ab_range)
    color_cielab = np.array([np.ones(a.shape) * l, a, b]).T
    color_rgb = color.lab2rgb(color_cielab)
    print(color_cielab)
    print(color_rgb)

    fig, ax = plt.subplots()
    ax.imshow(color_rgb, extent=[min_range, max_range, min_range, max_range])

def cielab_circle(l, r_a, r_b, count=8):
    theta = np.arange(0, 2*np.pi, 2*np.pi / count)
    # ab_range = np.linspace(np.ones(100), np.sin(theta), 100)

    a = np.cos(theta) * r_a
    b = np.sin(theta) * r_b

    color_cielab = np.array([np.ones(a.shape) * l, a, b]).T
    color_rgb = color.lab2rgb([color_cielab])[0]

    fig, ax = plt.subplots()
    # ax.scatter(a, b, s=200, c=color_rgb)
    # ax.set_facecolor(color.lab2rgb([[[10, 0, -5]]])[0][0])
    ax.imshow(color_rgb[None, :, :])

    int_color_rgb = (color_rgb * 255).astype(int)

    for r, g, b in int_color_rgb:
        test_str = '███ abcdefghijklmnopqrstuvwxyz'
        print(f"\033[38;2;{r};{g};{b}m{test_str} {r:3d} {g:3d} {b:3d}\033[0m")

def cielab_line(l_start, l_end, a_start, a_end, b_start, b_end, count=100):
    l = np.linspace(l_start, l_end, count)
    a = np.linspace(a_start, a_end, count)
    b = np.linspace(b_start, b_end, count)

    color_cielab = np.array([l, a, b]).T
    print(color_cielab)
    color_rgb = color.lab2rgb([color_cielab])[0]
    print(color_rgb)

    fig, ax = plt.subplots()
    # ax.scatter(a, b, s=200, c=color_rgb)
    # ax.set_facecolor(color.lab2rgb([[[10, 0, -5]]])[0][0])
    ax.imshow(color_rgb[None, :, ::-1], aspect='auto')
