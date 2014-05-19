# Please run this script as an administrative user
# Check if backup disk is mounted
ssh patrick@sandstone.dlinkddns.com
backupdir=$(/media/Linux\ Backups/backups)
if [ -d /media/Linux\ Backups/backups ]; then
#if [ -d /media/Linux Backups/backups ]; then
  filename=$(LC_ALL=C date +"%m_%d_%y")
  echo "Creating backup directory" $filename
  mkdir /media/Linux\ Backups/backups/$filename
  if [ -d /media/Linux\ Backups/backups/$filename ]; then
    echo "done!"
    # begin backing up every important directory
    echo "backing up /boot ------------------------------------------------"
    tar -zcvf /media/Linux\ Backups/backups/$filename/boot.tgz /boot
    echo "backing up /etc ------------------------------------------------"
    tar -zcvf /media/Linux\ Backups/backups/$filename/etc.tgz /etc
    echo "backing up /opt ------------------------------------------------"
    tar -zcvf /media/Linux\ Backups/backups/$filename/opt.tgz /opt
    echo "backing up /root ------------------------------------------------"
    tar -zcvf /media/Linux\ Backups/backups/$filename/root.tgz /root
    echo "backing up /home ------------------------------------------------"
    tar -zcvf /media/Linux\ Backups/backups/$filename/home.tgz /home
    echo "backing up a list of all installed packages to pkglist.txt"
    pacman -Qqen > /media/Linux\ Backups/backups/$filename/pkglist.txt
    echo "all done!"
  else
    echo "Could not create the directory"
  fi
else
  echo "Backup disk not found!"
fi
