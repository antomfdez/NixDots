#!/bin/bash

# Configuration
LOW_THRESHOLD=20
HIGH_THRESHOLD=80
SLEEP_INTERVAL=60  # Check every 60 seconds
COOLDOWN=300       # 5 minutes cooldown between notifications

LAST_NOTIFICATION=0  # Time of last notification

while true; do
  BATTERY_INFO=$(acpi -b 2>/dev/null | grep -v "unavailable")
  if [[ $BATTERY_INFO =~ ([0-9]+)% ]]; then
    PERCENT=${BASH_REMATCH[1]}
    STATUS=$(echo "$BATTERY_INFO" | grep -o "Discharging\|Charged\|Charging\|Full")

    CURRENT_TIME=$(date +%s)
    TIME_SINCE_LAST=$((CURRENT_TIME - LAST_NOTIFICATION))

    if [[ $PERCENT -le $LOW_THRESHOLD && ("$STATUS" == "Discharging" || -z "$STATUS") ]]; then
      if [[ $TIME_SINCE_LAST -ge $COOLDOWN ]]; then
        notify-send -u critical "Battery Low!" "Current charge: ${PERCENT}%"
        LAST_NOTIFICATION=$CURRENT_TIME
      fi
    elif [[ $PERCENT -ge $HIGH_THRESHOLD && "$STATUS" == "Charging" ]]; then
      if [[ $TIME_SINCE_LAST -ge $COOLDOWN ]]; then
        notify-send -u normal "Battery Charged!" "Current charge: ${PERCENT}%"
        LAST_NOTIFICATION=$CURRENT_TIME
      fi
    fi
  fi

  sleep $SLEEP_INTERVAL
done
