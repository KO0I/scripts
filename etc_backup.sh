sudo cp $(sudo pacman -Qii | awk '/^MODIFIED/ {print $2}') /home/patrick/dotfiles/etc_backup/
