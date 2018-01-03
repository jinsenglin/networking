#!/bin/bash

set -e

    apt-get update -y

    # Install openvswitch
    apt-get install -y openvswitch-switch

    # Install linux bridge utils
    apt-get install -y bridge-utils

    # Install vlan utils
    apt-get install -y vlan

    # Print net namespace
    ip netns ls

    # Print kernel ip forwarding on/off in current net namespace
    sysctl net.ipv4.ip_forward

    # Printe links in current net namespace
    ip link

    # Printe addresses in current net namespace
    ip a

    # Print arp table in current net namespace
    arp -n

    # Print routes in current net namespace
    route -n

    # Print firewall rules in current net namespace
    iptables -L

    # Print linux bridges in current net namespace
    brctl show

    # Print ovs bridges in current net namespace
    ovs-vsctl show

    # Print flows of OVS-BRIDGE
    # ovs-ofctl dump-flows OVS-BRIDGE
