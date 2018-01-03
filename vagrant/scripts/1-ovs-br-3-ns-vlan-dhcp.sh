#!/bin/bash

set -e

ovs-vsctl add-br br0
echo "$(date) | ovs bridge br0 created"

ip netns add ns1
echo "$(date) | networking namesapce ns1 created"

ip netns add ns2
echo "$(date) | networking namesapce ns2 created"

ip link add tap0 type veth peer name tap1
echo "$(date) | veth pair of tap0 and tap1 created"

ip link add tap2 type veth peer name tap3
echo "$(date) | veth pair of tap2 and tap3 created"

ip link set dev tap1 netns ns1
echo "$(date) | moved tap1 to ns1"

ip link set dev tap3 netns ns2
echo "$(date) | moved tap3 to ns2"

ovs-vsctl add-port br0 tap0 tag=100
echo "$(date) | attached tap0 to br0 with vlan tag 100"

ovs-vsctl add-port br0 tap2 tag=100
echo "$(date) | attached tap2 to br0 with vlan tag 100"

ip netns exec ns1 ip addr add 10.10.10.1/24 dev tap1
echo "$(date) | assigned 10.10.10.1/24 to ns1::tap1"

ip netns exec ns1 dnsmasq --dhcp-range=10.10.10.2,10.10.10.254,255.255.255.0 --interface=tap1
echo "$(date) | brought up ns1::dnsmasq dhcp server"

ip netns exec ns1 ip link set tap1 up
echo "$(date) | brought up ns1::tap1"

ip netns exec ns2 ip link set tap3 up
echo "$(date) | brought up ns2::tap3"

ip link set dev tap0 up
echo "$(date) | brought up tap0"

ip link set dev tap2 up
echo "$(date) | brought up tap2"

ip netns exec ns2 dhclient tap3
echo "$(date) | assigned ip to ns2:tap3 via dhcp server"

IP=$(ip netns exec ns2 ifconfig tap3 | grep 'inet addr' | awk '{print $2}' | awk -F ':' '{print $2}')
echo "$(date) | IP = $IP"

echo "$(date) | from ns1 ping ns2"
ip netns exec ns1 ping -c 1 $IP

echo "$(date) | from ns2 ping ns1"
ip netns exec ns2 ping -c 1 10.10.10.1
