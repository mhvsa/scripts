cap=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)

if [[ $cap -gt 80 && $status == "Charging" ]]; then
    dunstify -u normal "Battery life: unplug" "Battery is at ${cap}%. For best battery life charge the battery when it is at 40% and unplug the charger when it is at 80%"
fi

if [[ $cap -lt 40 && $status == "Discharging" ]]; then
    dunstify -u normal "Battery life: charge" "Battery is at ${cap}%. For best battery life charge the battery when it is at 40% and unplug the charger when it is at 80%"
fi

