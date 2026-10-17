#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
swf_path="${root_dir}/build/10.2/ScratchFor10.2.swf"

if [[ ! -f "${swf_path}" ]]; then
    printf 'Missing %s. Build first with: ./gradlew build -Ptarget=10.2\n' "${swf_path}" >&2
    exit 1
fi

if command -v ruffle >/dev/null 2>&1; then
    exec ruffle "${swf_path}"
fi

if command -v flatpak >/dev/null 2>&1 && flatpak info rs.ruffle.Ruffle >/dev/null 2>&1; then
    exec flatpak run rs.ruffle.Ruffle "${swf_path}"
fi

printf 'Ruffle was not found. Install the desktop app from https://ruffle.rs/downloads.\n' >&2
exit 127
