#!/bin/zsh

sudo rm /usr/lib/jvm/default-runtime
sudo ln -s /usr/lib/jvm/java-8-openjdk /usr/lib/jvm/default-runtime
exec /home/$USER/thinkorswim/thinkorswim &;
sleep 2;
sudo rm /usr/lib/jvm/default-runtime
sudo ln -s /usr/lib/jvm/java-14-openjdk /usr/lib/jvm/default-runtime 
exec tastyworks &;
#surf https://robinhood.com
surf https://stocks.comment.ai/ # sentiment
#sleep 1;
#surf https://swaggystocks.com/dashboard/stocks/theta-gang # theta bot to watch
#sleep 1;
#surf https://fdscanner.com/unusualvolume
#sleep 1;
#surf https://www.earningswhispers.com/calendar
#sleep 1;
#surf https://ivtrades.com/unusual-options-activity-scanner-html/
