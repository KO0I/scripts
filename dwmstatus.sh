while true; do
  xsetroot -name "`date -I` `acpi -b | grep Battery\ 0`" 
done
