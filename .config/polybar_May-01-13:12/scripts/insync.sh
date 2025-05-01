#!/bin/bash

# Check if InSync is running
if pgrep -x "insync" > /dev/null; then
    echo "%{A1:insync show;:}%{F#5be610}%{A}%{A2:insync quit;:}%{A}"
else
    echo "%{F#FF0000}"
fi
