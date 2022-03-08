source libexec/watchdog.bash
source libexec/patch_map.bash

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
          __ping_watchdog
          echo "${line}"
          __build_patch_map "${flavor}"
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
