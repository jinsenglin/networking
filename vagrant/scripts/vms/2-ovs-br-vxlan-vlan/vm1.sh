#!/bin/bash

set -e

ovs-vsctl add-br br0
echo "$(date) | created ovs bridge br0"

ip addr flush dev enp0s8
echo "$(date) | cleared dev enp0s8"

ovs-vsctl add-port br0 enp0s8
echo "$(date) | attached dev enp0s8 to ovs br br0"

ip addr add 192.168.33.101/24 dev br0
echo "$(date) | assigned ip 192.168.33.101 to ovs br br0"

ip link set dev br0 up
echo "$(date) | brought up ovs br br0"

#echo "ping vm2"
#ping 192.168.33.102

ovs-vsctl add-br br1
echo "$(date) | created ovs bridge br1"

ip tuntap add name tap0 mode tap
echo "$(date) | created dev tap0"

ip link set dev tap0 up
echo "$(date) | brought up dev tap0"

ovs-vsctl add-port br1 tap0 tag=100
echo "$(date) | attached dev tap0 to ovs br br0 with vlan tag 100"

ip addr add 10.10.10.101/24 dev tap0
echo "$(date) | assigned ip to dev tap0"

ip link set dev br1 up
echo "$(date) | brought up ovs br br1"

ovs-vsctl add-port br1 vx1 -- set interface vx1 type=vxlan options:remote_ip=192.168.33.102
echo "$(date) | created vxlan port vx1 to ovs br br1"

#echo "ping vm2 via vxlan"
#ping 10.10.10.102
