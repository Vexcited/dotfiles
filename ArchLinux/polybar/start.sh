#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

polybar --list-monitors | while IFS=$'\n' read line; do
      monitor=$(echo $line | cut -d':' -f1)
      primary=$(echo $line | cut -d' ' -f3)
      tray_position=$([ -n "$primary" ] && echo "right" || echo "none")
      MONITOR=$monitor TRAY_POSITION=$tray_position polybar --reload example &
done
