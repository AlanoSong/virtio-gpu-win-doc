#!/bin/bash

set -e

PHY_IFACE="eno1"
BRIDGE_NAME="br-qemu"
TAP_NAME="tap-qemu"

echo "cleanup bridge net for qemu..."

if [ "$EUID" -ne 0 ]; then
    echo "sudo this script"
    exit 1
fi

echo "release dhcp..."
dhclient -r ${BRIDGE_NAME} 2>/dev/null || true
dhclient -r ${PHY_IFACE} 2>/dev/null || true

echo "delete ${PHY_IFACE} from bridge net..."
ip link set ${PHY_IFACE} nomaster 2>/dev/null || true
ip link set ${PHY_IFACE} promisc off
ip link set ${PHY_IFACE} down
ip link set ${PHY_IFACE} up

echo "delete tap device ${TAP_NAME}..."
ip link delete ${TAP_NAME} 2>/dev/null || true

echo "delete net bridge ${BRIDGE_NAME}..."
ip link set ${BRIDGE_NAME} down
ip link delete ${BRIDGE_NAME} 2>/dev/null || true

echo "recover ${PHY_IFACE} dhcp..."
nmcli device connect ${PHY_IFACE} 2>/dev/null || dhclient -v ${PHY_IFACE} 2>/dev/null || true

echo -e "\nthe net bridge for qemu deleted, current status"
echo "========================================"
ip addr show ${PHY_IFACE}
echo "----------------------------------------"
ping -c 2 8.8.8.8 2>/dev/null && echo "physical net ready" || echo "physical net error"
echo "========================================"
