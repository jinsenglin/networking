#!/bin/bash

set -e

echo "$(date) | created networking namespace ns1"
echo "$(date) | created networking namespace ns2"
echo "$(date) | created veth pair of tap0 and tap1"
echo "$(date) | moved tap0 to ns1"
echo "$(date) | moved tap1 to ns2"
echo "$(date) | assigned 10.10.10.1/24 to ns1::tap0"
echo "$(date) | assigned 10.10.10.2/24 to ns2::tap1"
echo "$(date) | from ns1 ping ns2"
echo "$(date) | from ns2 ping ns1"
echo "$(date) | created ovs bridge ns1::br0"
echo "$(date) | created ovs bridge ns2::br0"
echo "$(date) | assigned 10.10.20.1/24 to ns1::br0"
echo "$(date) | assigned 10.10.20.2/24 to ns2::br0"
echo "$(date) | created vxlan port on ns1::br0"
echo "$(date) | created vxlan port on ns2::br0"
echo "$(date) | from ns1 ping ns2 via vxlan"
echo "$(date) | from ns2 ping ns1 via vxlan"
