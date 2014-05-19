while true 
do 
  cpu_temp=$(cat /proc/acpi/ibm/thermal | awk '{printf("\x04 cpu: "$3"*"$4" 
  ")}') 
  root_vol=$(df -h / | awk 'END {printf("\x01| root: "$5)}' | sed 's/Use%//') 
  home_vol=$(df -h /home| awk 'END {printf("\x01home: "$5)}' | sed 's/Use%//') 
  vol=$(aumix -q | awk '/vol/ {printf("\x01|\x03vol:"$3)}') 
  date=$(date | awk 'END {printf("\x01| \x01"$1" "$2" "$3)}') 
  uptime=$(uptime | awk 'BEGIN {FS = ":"}; END {printf("\x01|"$1":"$2)}') 
  taskbar_info=$(echo -e $cpu_temp $root_vol $home_vol $vol $date $uptime) 
  xsetroot -name "$taskbar_info" 
  sleep 5 
done
