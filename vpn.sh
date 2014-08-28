# In order to get VPN running, I need to do some stupid stuff everytime

# The install script needs a file to be placed into /etc/rc.d
# Obviously, because of systemd this directory does not exist anymore

# See if rc.d is present

ETCD='~/etc/rc.d'

#If it doesn't exist, make it
if [ ! -d "$ETCD" ]; then
  echo "making vpnfile"
  mkdir -p "$ETCD"
fi

# Other items
echo "running installer"
cd /home/patrick/build/anyconnect-3.1.05152/vpn
./vpn_install.sh
./vpnui
cd /home/patrick

# Finally, clean up
if [ -d "$ETCD" ]; then
  rm -r "$ETCD"
  echo "cleaning up"
fi
