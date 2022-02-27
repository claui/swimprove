function __i3status_custom__ping_watchdog {
  if [[ "${WATCHDOG_USEC:-}" ]]; then
    systemd-notify WATCHDOG=1
  fi
}

export -f __i3status_custom__ping_watchdog

function __i3status_custom__build_patch_map {
  local flavor
  local user_instance_state
  local system_instance_state

  flavor="${1?}"
  set --

  # Patch pending_reboot
  set -- "$@" --arg holder__pending_reboot \
    "$((RANDOM % 1000)): ${flavor}"

  # Patch systemd_system_instance_state
  if ! system_instance_state="$(systemctl is-system-running)"; then
    set -- "$@" --argjson extra__holder__systemd_system_instance_state \
      '{ "color": "#FF0000" }'
  fi
  set -- "$@" --arg holder__systemd_system_instance_state \
    "system ${system_instance_state}"

  # Patch systemd_user_instance_state
  if ! user_instance_state="$(systemctl --user is-system-running)"; then
    set -- "$@" --argjson extra__holder__systemd_user_instance_state \
      '{ "color": "#FF0000" }'
  fi
  set -- "$@" --arg holder__systemd_user_instance_state \
    "user ${user_instance_state}"

  # Write patch map to stdout
  jq -n "$@" '$ARGS.named'
}

export -f __i3status_custom__build_patch_map

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
          __i3status_custom__build_patch_map "${flavor}"
        done \
      | jq -cM --unbuffered '
        input as $patch_map
        | ((.[] | select(.instance // empty | in($patch_map)))
        |= . + { "full_text" : $patch_map[.instance] })
        | ((.[] | select("extra__\(.instance)" | in($patch_map)))
        |= . + $patch_map["extra__\(.instance)"])
        ' \
      | sed -u -e 's/^/,/'
  }
}

export -f __i3status_custom
