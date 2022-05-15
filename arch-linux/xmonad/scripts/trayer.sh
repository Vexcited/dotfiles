#!/bin/bash

# By default, my xmobar height is 32px.
# - The configuration can be found in ~/.config/xmobar/xmobarrc
# Here, my trayer will be 24px height.

# To center this, we will be using
# ((xmobar height - trayer height) / 2)px - so here, 4px - distance from top.

trayer \
  --edge top \
  --widthtype request \
  --align right \
  --expand true \
  --padding 10 \
  --SetDockType true \
  --SetPartialStrut true \
  --transparent true \
  --alpha 0 \
  --iconspacing 10 \
  --height 24 \
  --distancefrom top \
  --distance 4 \
  --tint 0x2E3440 \
