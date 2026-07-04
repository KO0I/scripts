sudo mount.cifs \
  -o uid=$UID,gid=$(id -g),vers=3.0,sec=ntlmv2,username=amber \
  //sobek/public \
  /mnt/sobek

