sudo cp $(sudo pacman -Qii | awk '/^MODIFIED/ {print $2}') /home/amber/dotfiles/etc_backup/
