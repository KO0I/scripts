#!/bin/sh

T='gYw' # Test text

for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
               '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
                                       '  36m' '1;36m' '  37m' '1;37m';

#for FGs in 'm''1m''30m''1;30m''31m''1;31''32m''1;32m''33m''1;33m'\
#           '34m''1;34m''35m''1;35m''36''1;36m''37m''1;37m'; 

  do FG=${FGs// /}
    #echo -en " $FGs \033[$FG  $T  "
    for BG in 0m 40m 41m 42m 43m 44m 45m 46m 47m;
      do 
      echo -e "\033[$FG\033[$BG $T  \033[0m";
      xsetroot -name "\033[$FG\033[$BG $T  \033[0m"
      #echo -e "\033[$BG $T  \033[0m";
      sleep 0.1
    done
  done
echo
