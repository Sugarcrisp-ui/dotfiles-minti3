#!/bin/bash

# Run apt update (silently)
/usr/bin/apt update >/dev/null 2>&1

# Count upgradable packages
apt_count=$(/usr/bin/apt list --upgradeable 2>/dev/null | grep -c upgradable)

# Check for phased updates (deferred)
phased_packages=$(/usr/bin/apt upgrade --dry-run 2>/dev/null | sed -n '/The following upgrades have been deferred due to phasing:/,/The following packages will be upgraded:/p' | grep -v "deferred due to phasing" | grep -v "The following packages will be upgraded:" | grep -v "^$" | wc -l)
phased_count=$(echo "$phased_packages")

# Subtract phased updates from the total count
effective_apt_count=$((apt_count - phased_count))

# Run flatpak update and count upgradable apps
if ! flatpak update --appstream >/dev/null 2>&1; then
    echo " Flatpak Err"
    exit 1
fi
flatpak_count=$(flatpak remote-ls --updates 2>/dev/null | wc -l)

# Sum total updates
total_count=$((effective_apt_count + flatpak_count))

if [ "$total_count" -gt 0 ]; then
    echo " $total_count"
else
    echo ""
fi
