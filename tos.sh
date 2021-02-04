#!/bin/zsh

sudo rm /usr/lib/jvm/default-runtime
sudo ln -s /usr/lib/jvm/java-8-openjdk /usr/lib/jvm/default-runtime
exec /home/$USER/thinkorswim/thinkorswim &;
