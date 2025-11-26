#!/bin/bash

SONOS_IP="192.168.68.75"

echo "=== SONOS / HOME ASSISTANT NETWORK DIAGNOSTIC ==="

echo "[1] Checking Home Assistant host IP..."
HA_IP=$(ip route get 1 | awk '{print $7; exit}')
echo "HA Host IP: $HA_IP"
echo

echo "[2] Checking if HA and Sonos are on the same subnet..."
HA_NET=$(echo $HA_IP | cut -d. -f1-3)
SONOS_NET=$(echo $SONOS_IP | cut -d. -f1-3)

if [ "$HA_NET" != "$SONOS_NET" ]; then
    echo "❌ NOT on same subnet!"
    echo "HA network: $HA_NET.x"
    echo "Sonos network: $SONOS_NET.x"
    echo
    echo "FIX:"
    echo " - Put Sonos on the same VLAN/subnet as Home Assistant"
    echo " - OR move HA to the same network as Sonos"
    echo " - OR enable mDNS + SSDP across VLANs on Asus/Sky router"
    exit 1
else
    echo "✅ Same subnet."
fi

echo
echo "[3] Pinging Sonos speaker..."
ping -c 3 $SONOS_IP > /dev/null

if [ $? -ne 0 ]; then
    echo "❌ Sonos unreachable from HA"
    echo "Likely WiFi isolation / client isolation issue."
    exit 1
else
    echo "✅ Sonos reachable."
fi

echo
echo "[4] Checking Sonos SSDP discovery port (UDP 1900)..."
nc -zu $SONOS_IP 1900

if [ $? -ne 0 ]; then
    echo "❌ SSDP blocked (discovery won't work)"
    echo "FIX:"
    echo " - Disable AP isolation on your Asus nodes"
    echo " - Ensure multicast routing enabled on Sky and Asus"
else
    echo "✅ SSDP reachable."
fi

echo
echo "=== DIAGNOSTIC COMPLETE ==="