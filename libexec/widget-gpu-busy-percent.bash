# Populates a custom i3status widget with the current GPU utilization
# in percent.
#
# Usage:
# __widget_gpu_busy_percent PLACEHOLDER CARD_ID
#
# where:
#   PLACEHOLDER the ID of the custom i3status widget we want to patch
#   CARD_ID the subdirectory name under `/sys/class/drm`, e.g. `card1`
#
# Prerequisites:
#   A writeable environment variable named `args` must be in scope.
#   It must be an array.
#
# Side effect:
#   Appends one or more patch map entries to the `args` array.
#
# Returns:
#   nothing
#
function __widget_gpu_busy_percent {
  local card_id
  local gpu_busy_percentage
  local placeholder_id

  placeholder_id="${1?}"
  shift
  card_id="${1?}"
  shift

  if [[ ! -e "/sys/class/drm/${card_id}/device/gpu_busy_percent" ]]; then
    args=(
      "${args[@]}"
      --argjson
      "extra__${placeholder_id}" '{ "color": "#FF0000" }'
      --arg
      "${placeholder_id}" '? %'
    )
    return
  fi

  read -r gpu_busy_percentage < "/sys/class/drm/${card_id}/device/gpu_busy_percent"
  args=("${args[@]}" --arg
    "${placeholder_id}" "${gpu_busy_percentage}%")
}

export -f __widget_gpu_busy_percent
