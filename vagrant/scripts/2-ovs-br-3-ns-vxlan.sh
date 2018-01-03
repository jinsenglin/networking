#!/bin/bash

set -e

ip netns add ns1
echo "$(date) | created networking namespace ns1"

ip netns add ns2
echo "$(date) | created networking namespace ns2"

ip link add tap0 type veth peer name tap1
echo "$(date) | created veth pair of tap0 and tap1"

ip link set dev tap0 netns ns1
echo "$(date) | moved tap0 to ns1"

ip link set dev tap1 netns ns2
echo "$(date) | moved tap1 to ns2"

ip netns exec ns1 ip addr add 10.10.10.1/24 dev tap0
echo "$(date) | assigned 10.10.10.1/24 to ns1::tap0"

ip netns exec ns2 ip addr add 10.10.10.2/24 dev tap1
echo "$(date) | assigned 10.10.10.2/24 to ns2::tap1"

ip netns exec ns1 ip link set tap0 up
echo "$(date) | brought up ns1::tap0"

ip netns exec ns2 ip link set tap1 up
echo "$(date) | brought up ns2::tap1"

ip netns exec ns1 ping -c 1 10.10.10.2
echo "$(date) | from ns1 ping ns2"

ip netns exec ns2 ping -c 1 10.10.10.1
echo "$(date) | from ns2 ping ns1"

#ip netns exec ns1 ovs-vsctl add-br br0
#echo "$(date) | created ovs bridge ns1::br0"
#
#ip netns exec ns2 ovs-vsctl add-br br0
#echo "$(date) | created ovs bridge ns2::br0"
#
#ip netns exec ns1 ip addr add 10.10.20.1/24 dev br0
#echo "$(date) | assigned 10.10.20.1/24 to ns1::br0"
#
#ip netns exec ns2 ip addr add 10.10.20.2/24 dev br0
#echo "$(date) | assigned 10.10.20.2/24 to ns2::br0"
#
#ip netns exec ns1 ovs-vsctl add-port br0 vx1 -- set interface vx1 type=vxlan options:remote_ip=10.10.10.2
#echo "$(date) | created vxlan port on ns1::br0"
#
#ip netns exec ns2 ovs-vsctl add-port br0 vx1 -- set interface vx1 type=vxlan options:remote_ip=10.10.10.1
#echo "$(date) | created vxlan port on ns2::br0"
#
#ip netns exec ns1 ping -c 1 10.10.20.2
#echo "$(date) | from ns1 ping ns2 via vxlan"
#
#ip netns exec ns2 ping -c 1 10.10.20.1
#echo "$(date) | from ns2 ping ns1 via vxlan"
