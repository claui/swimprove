# Populates a custom i3status widget with the current fan speed.
#
# Usage:
# __widget__fan_rpm PLACEHOLDER FAN_ID
#
# where:
#   PLACEHOLDER the ID of the custom i3status widget we want to patch
#   FAN_ID the number of the fan to query, or `all`.`
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
function __widget__fan_rpm {
  local fan_id
  local placeholder_id
  local fan_duty
  local fan_duty_percentage
  # 📌🌬

  placeholder_id="${1?}"
  shift
  fan_id="${1?}"
  shift

  if [[ ! -x '/usr/bin/ectool' ]]; then
    args=(
      "${args[@]}"
      --argjson
      "extra__${placeholder_id}" '{ "color": "#FF0000" }'
      --arg
      "${placeholder_id}" '? min⁻¹'
    )
    return
  fi

  fan_duty="$(
    sudo ectool pwmgetduty "${fan_id}" \
      | sed -n 's/Current PWM duty: //p'
  )"
  fan_duty_percentage="$(( (fan_duty + 1) * 100 / 65535 ))"
  args=("${args[@]}" --arg
    "${placeholder_id}" "${fan_duty_percentage}%")
}

export -f __widget__fan_rpm
