# Please run this script as an administrative user
# Simply creates a dump of all pacman packages and stamps it with the date it
# was created
  filename=$(LC_ALL=C date + "%m_%d_%y")
  echo "Creating backup of package list" $filename

  pacman -Qqen > /home/patrick/dotfiles/packages_$filename
