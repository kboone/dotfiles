#!/bin/sh
# Base16 3024 - Shell color setup script
# Jan T. Sott (http://github.com/idleberg)

if [ "${TERM%%-*}" = 'linux' ]; then
    # This script doesn't support linux console (use 'vconsole' template instead)
    return 2>/dev/null || exit 0
fi

base03="22/26/2d"
base02="2c/31/38"
base01="64/6b/73"
base00="71/78/7f"
base0="8d/91/94"
base1="9a/9e/a1"
base2="ea/e8/e4"
base3="f8/f6/f2"
yellow="bb/88/01"
orange="a4/54/31"
red="b7/5d/4e"
magenta="9d/53/74"
violet="61/65/a5"
blue="4a/8b/ae"
cyan="69/8d/69"
green="9f/93/00"

color_foreground=$base0 # Base 05
color_background=$base03 # Base 00
color_cursor=$base1 # Base 05

if [ -n "$TMUX" ]; then
  # tell tmux to pass the escape sequences through
  # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
  printf_template="\033Ptmux;\033\033]4;%d;rgb:%s\007\033\\"
  printf_template_var="\033Ptmux;\033\033]%d;rgb:%s\007\033\\"
  printf_template_custom="\033Ptmux;\033\033]%s%s\007\033\\"
elif [ "${TERM%%-*}" = "screen" ]; then
  # GNU screen (screen, screen-256color, screen-256color-bce)
  printf_template="\033P\033]4;%d;rgb:%s\007\033\\"
  printf_template_var="\033P\033]%d;rgb:%s\007\033\\"
  printf_template_custom="\033P\033]%s%s\007\033\\"
else
  printf_template="\033]4;%d;rgb:%s\033\\"
  printf_template_var="\033]%d;rgb:%s\033\\"
  printf_template_custom="\033]%s%s\033\\"
fi

# 16 color space
printf $printf_template 0  $base02
printf $printf_template 1  $red
printf $printf_template 2  $green
printf $printf_template 3  $yellow
printf $printf_template 4  $blue
printf $printf_template 5  $magenta
printf $printf_template 6  $cyan
printf $printf_template 7  $base2
printf $printf_template 8  $base03
printf $printf_template 9  $orange
printf $printf_template 10 $base01
printf $printf_template 11 $base00
printf $printf_template 12 $base0
printf $printf_template 13 $violet
printf $printf_template 14 $base1
printf $printf_template 15 $base3

# foreground / background / cursor color
if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  printf $printf_template_custom Pg a5a2a2 # forground
  printf $printf_template_custom Ph 090300 # background
  printf $printf_template_custom Pi a5a2a2 # bold color
  printf $printf_template_custom Pj 4a4543 # selection color
  printf $printf_template_custom Pk a5a2a2 # selected text color
  printf $printf_template_custom Pl a5a2a2 # cursor
  printf $printf_template_custom Pm 090300 # cursor text
else
  printf $printf_template_var 10 $color_foreground
  printf $printf_template_var 11 $color_background
  printf $printf_template_var 12 $color_cursor
fi

# clean up
unset printf_template
unset printf_template_var
unset color00
unset color01
unset color02
unset color03
unset color04
unset color05
unset color06
unset color07
unset color08
unset color09
unset color10
unset color11
unset color12
unset color13
unset color14
unset color15
unset color_foreground
unset color_background
unset color_cursor

