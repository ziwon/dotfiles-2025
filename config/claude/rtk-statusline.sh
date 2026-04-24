#!/bin/bash
# RTK token savings for ccstatusline custom-command widget
# Receives ccstatusline JSON on stdin (ignored), outputs RTK stats
cat > /dev/null  # consume stdin
rtk_json=$(rtk gain --format json 2>/dev/null) || exit 0
saved=$(echo "$rtk_json" | jq -r '.summary.total_saved // 0')
pct=$(echo "$rtk_json" | jq -r '.summary.avg_savings_pct // 0')

if [ "$saved" -gt 1000000 ] 2>/dev/null; then
  saved_fmt="$(echo "scale=1; $saved / 1000000" | bc)M"
elif [ "$saved" -gt 1000 ] 2>/dev/null; then
  saved_fmt="$(echo "scale=1; $saved / 1000" | bc)k"
else
  saved_fmt="$saved"
fi

pct_fmt=$(printf "%.1f" "$pct" 2>/dev/null || echo "$pct")
printf "RTK: %s (%s%%)" "$saved_fmt" "$pct_fmt"
