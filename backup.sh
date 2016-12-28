# Please run this script as an administrative user
# Check if backup disk is mounted
#backupdir=$(/media/Linux\ Backups/backups)
#if [ -d /media/Linux\ Backups/backups ]; then
if [ -d /media/Desktop\ Backup/patrick/backups ]; then
  filename=$HOST$(LC_ALL=C date +"%m_%d_%y")
  echo "Creating backup directory" $filename
  #mkdir /media/Linux\ Backups/backups/$filename
  mkdir /media/Desktop\ Backup/patrick/backups/$filename
  #if [ -d /media/Linux\ Backups/backups/$filename ]; then
  #  echo "done!"
  #  # begin backing up every important directory
  #  echo "backing up /boot ------------------------------------------------"
  #  tar -zcf /media/Linux\ Backups/backups/$filename/boot.tgz /boot
  #  echo "backing up /etc ------------------------------------------------"
  #  tar -zcf /media/Linux\ Backups/backups/$filename/etc.tgz /etc
  #  #echo "backing up /opt ------------------------------------------------"
  #  #tar -zcf /media/Linux\ Backups/backups/$filename/opt.tgz /opt
  #  echo "backing up / (as
  #  root.tgz) ------------------------------------------------"
  #  tar -zcf /media/Linux\ Backups/backups/$filename/root.tgz /
  #  --exclude='proc*'
  #  echo "backing up /home ------------------------------------------------"
  #  tar -zcf /media/Linux\ Backups/backups/$filename/home.tgz /home
  #  echo "backing up a list of all installed packages to pkglist.txt"
  #  pacman -Qqen > /media/Linux\ Backups/backups/$filename/pkglist.txt

  # USING RSYNC INSTEAD
#  rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} / /media/Linux\ Backups/backups/$filename 
  
  if [ -d /media/Desktop\ Backup/patrick/backups/$filename ]; then
    echo "Creating backup directory" $filename " on Desktop Backup"
    rsync -aAXv --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","*.git","/home/patrick/.cache"} / /media/Desktop\ Backup/patrick/backups/$filename 
    echo "backing up a list of all installed packages to pkglist.txt"
    pacman -Qqen > /media/Desktop\ Backup/patrick/backups/$filename/pkglist.txt
  else
    echo "Could not create the directory"
  fi

else
  echo "Backup disk not found!"
fi
