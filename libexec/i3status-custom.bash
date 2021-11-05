function __i3status_custom__ping_watchdog {
  if [[ "${WATCHDOG_USEC:-}" ]]; then
    systemd-notify WATCHDOG=1
  fi
}

export -f __i3status_custom__ping_watchdog

function __i3status_custom {
  local flavor

  flavor="${1?}"

  if [[ "${NOTIFY_SOCKET:-}" ]]; then
    systemd-notify --ready
  fi

  i3status -c ~/".i3status-${flavor}.conf" \
    | {
    head -3
    sed -u -e 's/^,//' \
      | while true; do
          read line
          __i3status_custom__ping_watchdog
          echo "${line}"
          jq -nr --arg a "$((RANDOM % 1000)): ${flavor}" '$a | @json'
        done \
      | jq -cM --unbuffered \
        --arg 'instance' 'holder__pending_reboot' \
        '(.[] | select(.instance == $instance)) |=
          . + {"full_text": input}' \
      | sed -u -e 's/^/,/'
  }
}

export -f __i3status_custom
