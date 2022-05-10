#!/bin/bash

LAYOUT=$(setxkbmap -query | grep layout | awk '{print $2}')

if [ $LAYOUT == "us" ]; then
  echo "US"
else
  echo "FR"
fi

