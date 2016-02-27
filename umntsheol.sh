#!/usr/bin/env bash
#Unmounting CU-Boulder shares

umount /mnt/sheol/{dist,loadsets,backups}
rmdir /mnt/sheol/{dist,loadsets,backups,}
#umount /mnt/brain/{groups,users,}
