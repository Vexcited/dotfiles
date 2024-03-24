#!/bin/bash
# Inspired from <https://github.com/OctopusET/sway-contrib/blob/master/grimshot>

GEOM=$(slurp -d)
# Check if user exited slurp without selecting the area
if [ -z "$GEOM" ]; then
  exit 1
fi

grim ${CURSOR:+-c} -g "$GEOM" "-" | wl-copy --type image/png
notify-send -t 1500 -a grim "Screenshot" "Area copied to clipboard !"
