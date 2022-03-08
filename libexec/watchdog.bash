function __ping_watchdog {
  if [[ "${WATCHDOG_USEC:-}" ]]; then
    systemd-notify WATCHDOG=1
  fi
}

export -f __ping_watchdog
