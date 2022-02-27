# swimprove

Various helpers for my personal Sway configuration.

## Overview

- `i3status-custom` expands upon the `i3status` command and adds
  custom modules to your status bar.

## Prerequisites

This suite of helpers requires Sway or i3. It also requires Linux.

## Installation

### Manual installation

To install `swimprove` manually:

1. Make sure all dependencies are installed: Sway (or i3),
   `i3status`, `jq`, and `systemd`.

2. Copy the contents of `bin` and `libexec` into a single directory
   named `libexec`. The directory must be named `libexec`.

## Configuration

1. Create one or more i3status configuration files and put them
   into your home directory as `.i3status-${flavor}.conf`.
   For example: `~/.i3status-standard.conf` and
   `~/.i3status-hidpi.conf`.

2. In your Sway config (or i3 config), add `bar` blocks as needed.

3. Inside the `bar` blocks, set `start-i3status-custom ${flavor}`
   as the `status_command`.
   For example: `start-i3status-custom hidpi`

## Usage

Reload your Sway or i3 configuration for the custom status command
to take effect.

## License

Copyright (c) 2021 – 2022 The `swimprove` authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
