source libexec/widget-fan-rpm.bash
source libexec/widget-pending-reboot.bash
source libexec/widget-service-state.bash

function __build_patch_map {
  local flavor
  local args

  flavor="${1?}"
  args=()

  __widget__pending_reboot \
    'holder__pending_reboot' \
    -- \
    "${flavor}"

  __widget__service_state \
    'holder__systemd_system_instance_state' \
    'system' \
    -- \
    systemctl is-system-running

  __widget__service_state \
    'holder__systemd_user_instance_state' \
    'user' \
    -- \
    systemctl --user is-system-running

  __widget__fan_rpm 'holder__fan_rpm' 0

  # Write patch map to stdout
  jq -n "${args[@]}" '$ARGS.named'
}

export -f __build_patch_map
