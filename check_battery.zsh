#!/bin/zsh

# Path to battery status and capacity
bat0_status="/sys/class/power_supply/BAT0/status"
bat1_status="/sys/class/power_supply/BAT1/status"
bat0_capacity="/sys/class/power_supply/BAT0/capacity"
bat1_capacity="/sys/class/power_supply/BAT1/capacity"

# Check if both batteries are not charging
capacity0=$(cat $bat0_capacity)
capacity1=$(cat $bat1_capacity)

if [[ $(cat $bat0_status) != "Charging" ]] && [[ $(cat $bat1_status) != "Charging" ]]; then
    # Read the capacity of BAT0 and print with "--"
    echo "$capacity0/$capacity1(--)"
elif [[ $(cat $bat0_status) == "Charging" ]] || [[ $(cat $bat1_status) == "Charging" ]]; then  
    # If either is charging, print capacities with "++"
    echo "$capacity0/$capacity1(++)"
else
    # If either is charging, print capacities with "++"
    echo "error! :("
fi
