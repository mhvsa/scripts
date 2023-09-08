## Check battery percentage and if it is less than 10% then send a notification

## Get battery percentage
cap=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

if [[ $cap -lt 10 && $status == "Discharging" ]]; then
    dunstify -u critical "Battery is extremely low. Please plug in the charger." "Battery is at ${cap}%"
fi

if [[ $cap -lt 20 && $status == "Discharging" ]]; then
    dunstify -u normal "Battery is low. Please plug in the charger." "Battery is at ${cap}%"
fi

