echo "Creating backup of current mirrorlist as mirrorlist.bak2"

cp -vf /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

reflector --verbose --country 'United States' -l 500 -p https --sort rate --save /etc/pacman.d/mirrorlist
#reflector --verbose --country 'Greece' -l 500 -p https --sort rate --save /etc/pacman.d/mirrorlist
#reflector --verbose --country 'Netherlands' -l 1000 -p https --sort rate --save /etc/pacman.d/mirrorlist
#reflector --verbose --country 'Germany' -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist
#reflector --verbose --country 'France' -l 200 -p http --sort rate --save /etc/pacman.d/mirrorlist
