#!/bin/bash

# Run apt update and count upgradable packages
if ! sudo -n /usr/bin/apt update >/dev/null 2>&1; then
    echo " APT Err"
    exit 1
fi
apt_count=$(/usr/bin/apt list --upgradeable 2>/dev/null | grep -c upgradable)

# Check for phased updates (deferred)
phased_output=$(/usr/bin/apt upgrade --dry-run 2>/dev/null | sed -n '/deferred due to phasing:/,/^[0-9] upgraded/p' | grep -v "deferred due to phasing" | grep -v "^[0-9] upgraded")
phased_count=$(echo "$phased_output" | tr ' ' '\n' | grep -v "^$" | wc -l)
apt_count=$((apt_count - phased_count))

# Run flatpak update and count upgradable apps
if ! flatpak update --appstream >/dev/null 2>&1; then
    echo " Flatpak Err"
    exit 1
fi
flatpak_count=$(flatpak remote-ls --updates 2>/dev/null | wc -l)

# Sum total updates
total_count=$((apt_count + flatpak_count))

if [ "$total_count" -gt 0 ]; then
    echo " $total_count"
else
    echo ""
fi
