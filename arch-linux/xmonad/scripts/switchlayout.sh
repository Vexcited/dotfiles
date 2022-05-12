#!/bin/bash

LAYOUT=$(setxkbmap -query | grep layout | awk '{print $2}')

if [ $LAYOUT == "us" ]; then
  setxkbmap -layout fr
else
  setxkbmap -layout us -variant intl
fi
