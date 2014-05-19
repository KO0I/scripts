echo Zeroing out free space!

echo Zeroing out free space in boot...
cat /dev/zero > /boot/btdump
rm /boot/btdump
echo Zeroing out free space in root...
cat /dev/zero > /rtdump
rm /rtdump

echo Zeroing out free space in home...
cat /dev/zero > /home/hmdump
rm /home/hmdump

echo done!
