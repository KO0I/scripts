#!/bin/bash
#run ONLY if the drives are in their normal order
umount /home/patrick/win7 
scsiadd -p
read -r -p "Please review the above output. scsi0 should be associated with a
TOSHIBA drive. The loud disk is a Seagate ST950042AS. Do you want to
continue? [Y/N]" response
case $response in 
  [yY][eE][sS]|[yY])
    sync & sudo scsiadd -r 1 0 0 0
    ;;
  *)
    echo "Nothing has changed"
    ;;
esac
