#!/bin/bash

ip netns add ns1
echo "$(date) | networking namesapce ns1 created"

ip link add tap0 type veth peer name tap1
echo "$(date) | veth pair of tap0 and tap1 created"

ip link set dev tap1 netns ns1
echo "$(date) | moved tap1 to ns1"

ip netns exec ns1 ip addr add 10.10.10.1/24 dev tap1
echo "$(date) | assigned 10.10.10.1/24 to ns1::tap1"

ip addr add 10.10.10.2/24 dev tap0
echo "$(date) | assigned 10.10.10.2/24 to tap0"

ip netns exec ns1 ip link set tap1 up
echo "$(date) | brought up ns1::tap1"

ip link set dev tap0 up
echo "$(date) | brought up tap0"

echo "$(date) | from ns1 ping root ns"
ip netns exec ns1 ping -c 1 10.10.10.2

echo "$(date) | from root ns ping ns1"
ping -c 1 10.10.10.1
