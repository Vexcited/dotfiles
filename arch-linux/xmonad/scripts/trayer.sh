#!/bin/bash
which trayer
trayer \
  --edge top \
  --align right \
  --widthtype request \
  --margin 8 \
  --padding 0 \
  --SetDockType true \
  --SetPartialStrut true \
  --expand true \
  --transparent true \
  --alpha 0 \
  --tint 0x2E3440 \
  --height 30 # `bar height - 2` - Height found in ~/.config/xmobar/xmobarrc
  --iconspacing 10