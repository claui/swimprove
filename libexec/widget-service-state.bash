# Populates a custom i3status widget with the current status of
# a given service.
#
# Usage:
# __widget__service_state PLACEHOLDER SERVICE [--] COMMAND ...
#
# where:
#   PLACEHOLDER the ID of the custom i3status widget we want to patch
#   SERVICE a service name that should appear in the status widget
#       alongside the status value
#   COMMAND a command line which, when invoked, returns:
#       - the service status on standard output; and
#       - an exit code of zero if and only if the status is ok(-ish)
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
function __widget__service_state {
  local placeholder_id
  local service_name
  local service_state

  placeholder_id="${1?}"
  shift
  service_name="${1?}"
  shift

  if [[ "${1?}" == '--' ]]; then
    shift
  fi

  if ! service_state="$(exec "$@")"; then
    args=("${args[@]}" --argjson
      "extra__${placeholder_id}" '{ "color": "#FF0000" }')
  fi
  args=("${args[@]}" --arg
    "${placeholder_id}" "${service_name} ${service_state}")
}

export -f __widget__service_state
