#!/bin/bash
CONFIG_DIR="/home/brett/protonvpn-server-configs"
VPN_FILES=("sg-89" "ca-60" "hk-47" "us-az-125" "vn-07")

# Log script start
echo "$(date): Script started with $1" >> /tmp/vpn-script.log

# Check if openvpn is running
is_openvpn_running() {
    pgrep -f "openvpn.*protonvpn" > /dev/null 2>&1
}

# Get active VPN
get_active_vpn() {
    ACTIVE_PID=$(pgrep -f "openvpn.*protonvpn")
    if [ -n "$ACTIVE_PID" ]; then
        ps -p "$ACTIVE_PID" -o args= | grep -oP "$CONFIG_DIR/.*\.ovpn" | xargs basename | cut -d'.' -f1
    fi
}

case "$1" in
    --toggle)
        if is_openvpn_running; then
            echo "$(date): Disconnecting VPN" >> /tmp/vpn-script.log
            sudo pkill -f "openvpn" >> /tmp/vpn-script.log 2>&1
            if [ $? -eq 0 ] || [ $? -eq 1 ]; then
                echo "VPN Disconnected" >> /tmp/vpn-script.log
            else
                echo "Failed to disconnect VPN" >&2 >> /tmp/vpn-script.log
                exit 1
            fi
        else
            echo "$(date): VPN_FILES: ${VPN_FILES[@]}" >> /tmp/vpn-script.log
            SELECTED_VPN=$(printf '%s\n' "${VPN_FILES[@]}" | rofi -dmenu -p "Select VPN")
            if [ -n "$SELECTED_VPN" ]; then
                echo "$(date): Connecting to $SELECTED_VPN" >> /tmp/vpn-script.log
                sudo openvpn --daemon --config "$CONFIG_DIR/$SELECTED_VPN.protonvpn.udp.ovpn" >> /tmp/vpn.log 2>&1
                sleep 2
                if pgrep -f "openvpn.*$SELECTED_VPN" > /dev/null; then
                    echo "Connecting to $SELECTED_VPN..." >> /tmp/vpn-script.log
                else
                    echo "Failed to connect to $SELECTED_VPN" >&2 >> /tmp/vpn-script.log
                    exit 1
                fi
            else
                echo "$(date): No VPN selected" >> /tmp/vpn-script.log
                exit 0
            fi
        fi
        ;;
    *)
        ACTIVE_VPN=$(get_active_vpn)
        if [ -n "$ACTIVE_VPN" ]; then
            echo "%{F#00FF00}VPN:$ACTIVE_VPN%{F-}"
        else
            echo "%{F#FF0000}VPN:Off%{F-}"
        fi
        ;;
esac
