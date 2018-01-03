1-linux-br-3-ns-vlan-dhcp-ns.sh FAILED

```
dhclient tap0.100 PASSED
dhclient tap2.100 FAILED
ip netns exec ns2 dhclient tap3.100 FAILED
```

2-ovs-br-3-ns-vxlan.sh FAILED

```
ovs br only exists in root ns. i.e. ovs br can not be created in other ns.
```
