## Check battery percentage and if it is less than 10% then send a notification

## Get battery percentage
cap=$(cat /sys/class/power_supply/BAT0/capacity)

if [ $cap -lt 10 ]; then
    dunstify -u critical "Battery is low" "Battery is at ${cap}%"
fi
