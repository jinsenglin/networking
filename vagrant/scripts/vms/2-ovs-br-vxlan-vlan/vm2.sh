#!/bin/bash

set -e

ovs-vsctl add-br br0
echo "$(date) | created ovs bridge br0"

ip addr flush dev enp0s8
echo "$(date) | cleared dev enp0s8"

ovs-vsctl add-port br0 enp0s8
echo "$(date) | attached dev enp0s8 to ovs br br0"

ip addr add 192.168.33.102/24 dev br0
echo "$(date) | assigned ip 192.168.33.102 to ovs br br0"

ip link set dev br0 up
echo "$(date) | brought up ovs br br0"

#echo "ping vm1"
#ping -c 1 192.168.33.101

ovs-vsctl add-br br1
echo "$(date) | created ovs bridge br1"

ip addr add 10.10.10.102/24 dev br1
echo "$(date) | assigned ip 10.10.10.102 to ovs br br1"

ovs-vsctl set port br1 tag=100
echo "$(date) | assigned vlan tag 100 to ovs port br1"

ip link set dev br1 up
echo "$(date) | brought up ovs br br1"

ovs-vsctl add-port br1 vx1 -- set interface vx1 type=vxlan options:remote_ip=192.168.33.101
echo "$(date) | created vxlan port vx1 to ovs br br1"

#echo "ping vm1 via vxlan"
#ping -c 1 10.10.10.101

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 

ip link add tap0 type veth peer name tap1
ip link set dev tap0 up
ip link set dev tap1 up
ip addr add 10.10.10.104/24 dev tap1
ip route del 10.10.10.0/24 dev tap1
ovs-vsctl add-port br1 tap0 tag=100
#ping -c 1 10.10.10.103
