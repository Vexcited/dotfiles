#!/bin/bash
# See https://github.com/hyprwm/Hyprland/discussions/830
WINDOW=$(hyprctl clients | grep "class: " | awk '{gsub("class: ", "");print}' | wofi --show dmenu)
if [ "$WINDOW" = "" ]; then
    exit
fi

hyprctl dispatch focuswindow $WINDOW
