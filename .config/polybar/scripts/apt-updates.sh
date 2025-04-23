#!/bin/bash

count=$(apt list --upgradeable 2>/dev/null | grep -c upgradable)

if [ "$count" -gt 0 ]; then
    echo " $count"
else
    echo ""
fi
