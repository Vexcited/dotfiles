#!/usr/bin/env bash

# Check if 'WAKATIME_API_KEY' environment variable is given
# to automatically configure it for us.
if [[ -z "$WAKATIME_API_KEY" ]]; then
  echo -e "[settings]\napi_key = $WAKATIME_API_KEY" > ~/.wakatime.cfg
fi # We do this first to prevent extensions from asking it.

cat << EOF
Happy coding!
- Vexcited

EOF
