# Populates a custom i3status widget with a hint that tells
# whether a reboot is needed.
#
# Usage:
# __widget__pending_reboot PLACEHOLDER SERVICE [--] NAME
#
# where:
#   PLACEHOLDER the ID of the custom i3status widget we want to patch
#   NAME an arbitrary string that should appear in the status widget
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
function __widget__pending_reboot {
  local placeholder_id
  local flavor

  placeholder_id="${1?}"
  shift

  if [[ "${1?}" == '--' ]]; then
    shift
  fi

  flavor="${1?}"

  args=("${args[@]}" --arg
    "${placeholder_id}" "$((RANDOM % 1000)): ${flavor}")
}

export -f __widget__pending_reboot
