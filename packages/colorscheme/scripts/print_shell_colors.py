#!/usr/bin/env python

colors = {
    30: 'black',
    31: 'red',
    32: 'green',
    33: 'yellow',
    34: 'blue',
    35: 'magenta',
    36: 'cyan',
    37: 'white',
    90: 'bright black',
    91: 'bright red',
    92: 'bright green',
    93: 'bright yellow',
    94: 'bright blue',
    95: 'bright magenta',
    96: 'bright cyan',
    97: 'bright white',
}


for code, name in colors.items():
    test_str = f'███ {name}'
    print(f"\033[{code}m{test_str}\033[0m")
