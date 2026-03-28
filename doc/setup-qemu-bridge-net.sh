#!/bin/bash

set -e

PHY_IFACE="eno1"
BRIDGE_NAME="br-qemu"
TAP_NAME="tap-qemu"
NETMASK="24"

echo "setup qemu bridge network..."

if [ "$EUID" -ne 0 ]; then
    echo "sudo this script"
    exit 1
fi

# echo "Install tools..."
# apt update > /dev/null 2>&1
# apt install -y bridge-utils uml-utilities > /dev/null 2>&1

echo "config physical net card ${PHY_IFACE}..."
nmcli device disconnect ${PHY_IFACE} 2>/dev/null || true
ip addr flush dev ${PHY_IFACE} 2>/dev/null
ip link set ${PHY_IFACE} down
ip link set ${PHY_IFACE} up
ip link set ${PHY_IFACE} promisc on

echo "create net bridge ${BRIDGE_NAME}..."
ip link add name ${BRIDGE_NAME} type bridge
ip link set ${BRIDGE_NAME} up
ip link set ${BRIDGE_NAME} promisc on

echo "add ${PHY_IFACE} into net bridge..."
ip link set ${PHY_IFACE} master ${BRIDGE_NAME}

echo "create tap device ${TAP_NAME}..."
tunctl -t ${TAP_NAME} -u $(whoami)
ip link set ${TAP_NAME} up
ip link set ${TAP_NAME} promisc on
ip link set ${TAP_NAME} master ${BRIDGE_NAME}

echo "dhcp..."
dhclient -v ${BRIDGE_NAME} 2>/dev/null || true

echo -e "\ndone, current bridge net status："
echo "========================================"
brctl show
echo "----------------------------------------"
ip addr show ${BRIDGE_NAME}
echo "========================================"
echo -e "\ncancel by sudo cleanup-qemu-bridge.sh"

