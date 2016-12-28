#!/bin/bash

#set Statusbar
while true; do
  #This section is for displaying the state of the battery
  # For Thinkpad X250; has two batteries
  # When a battery is exhausted, it is listed as unknown, so when it is dead,
  # do not show it's charge
  plugged2=$(LC_ALL=C acpi -b | awk 'FNR == 2 {print $3}')
  #b1=$(LC_ALL=C acpi -b | grep 'Battery 0'| awk '{print $4}' | sed s/..$//)
  b1=$(LC_ALL=C acpi -b | grep 'Battery 0'| awk '{print $4}')
  b2=$(LC_ALL=C acpi -b | grep 'Battery 1'| cut -d " " -f 4 | sed s/.$//)

  case $plugged2 in
    Discharging*)
    b2="/$b2--"
    ;;
    Unknown*)
    b2=""
    b1="$b1--(!)"
    ;;
    *)
    b2="/$b2++"
    ;; 
  esac

ldate=$(date +%a\ %m.%d.%y)
ltime=$(date +%T)
#lhour=$(date +%r | awk '{print $1}' | sed 's/.//3g')
#lface="🕐";

#case $lhour in
#  01)
#  ;; 
#  02)
#  ;; 
#  03)
#  ;; 
#  04)
#  ;; 
#  05)
#  ;; 
#  06)
#  ;; 
#  07)
#  ;; 
#  08)
#  ;; 
#  09)
#  ;; 
#  10)
#  ;; 
#  11)
#  ;; 
#  12)
#  ;; 
#esac

#xsetroot -name "🔋 $b1/$b2 ::📅  $ldate ::$lface $ltime"
xsetroot -name "$b1$b2 ::  $ldate :: $ltime"

sleep 5
done &
