#!/bin/bash
#  Snap picture of current setup
scrot 'background.png' -e 'mv $f /home/patrick/dotfiles/'
#  Blur it a little with imagemagick
#convert /home/$USER/dotfiles/background.png -channel RGBA -blur 0x8 /home/$USER/dotfiles/background.png
#  Blur and store
# convert /home/$USER/dotfiles/background.png -channel RGBA -blur 0x8 /usr/share/slim/themes/dynamic/background.png

# Blur, darken, BW and store
convert /home/$USER/dotfiles/background.png -colorspace Gray -blur 0x6 -level 5% -fill black -colorize 20% /usr/share/slim/themes/dynamic/background.png
#  Lock the screen
slimlock
