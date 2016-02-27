#!/bin/bash
#Mounting CU-Boulder shares
echo -n "Enter your username: "
read user
echo -n "Enter your password: "
read -s pass
echo "Creating directories in /mnt"
#mkdir /mnt/{sheol,brain}
#mkdir /mnt/sheol/{hive,dist,loadsets,backups,}
#mkdir /mnt/brain/{groups,users,}
##Mount Sharepoints on sheol
###Hive
#mount -t cifs //sheol.colorado.edu/Hive /mnt/sheol/hive/ -o
#,domain=ad,username=$user,password=$pass

###Dist
mkdir -p /mnt/sheol/dist
mount -t cifs //sheol.colorado.edu/dist /mnt/sheol/dist/ -o\
  domain=ad,username=$user,password=$pass

###Loadsets
mkdir /mnt/sheol/loadsets
mount -t cifs //sheol.colorado.edu/loadsets /mnt/sheol/loadsets/ -o\
  domain=ad,username=$user,password=$pass

###backups
mkdir /mnt/sheol/backups
mount -t cifs //sheol.colorado.edu/backups /mnt/sheol/backups -o\
  domain=ad,username=$user,password=$pass

##Mount Sharepoints from brain: 

#mount //thebrain.colorado.edu/groups /mnt/brain/groups -o
#ip=128.138.110.12,domain=ad,username=$user,password=$pass
#mount //thebrain.colorado.edu/users /mnt/brain/users -o
#ip=128.138.110.12,domain=ad,username=$user,password=$pass

#echo "Giving $user proper access..."
#chmod 111 /mnt/sheol/*
#chmod 111 /mnt/brain/*
#&>/dev/null
#echo "done!"

