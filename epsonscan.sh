#!/bin/bash
# run scan from epson nx420 on home network
echo -n "Enter name for scanned file: "
read name
echo "Scanning in progress..."
scanimage --resolution 600 -d epson2:net:192.168.5.107 --progress --format=png > ~/pictures/scan/$name.png
