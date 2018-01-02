http://plasmixs.github.io/network-namespaces-ovs.html

3 networking namespaces: root ns + 2 addtional ones - ns1, ns2

1 ovs bridge (br0) in root ns

2 veth pairs
* one end of each veth pair is attached to ovs bridge
* one end of each veth pair is move to other ns
  * 1 for ns1
  * 1 for ns2

CIDR
* 1.1.1.0/24 for ns1::vpeerns1 and ns2::vpeerns2

# PART II - Allowing 2 VLAN to Communicate to Each Other

2 VLAN tags: 100, 200
* dev ns1::vpeerns1.100 vlan id 100
* dev ns2::vpeerns2.200 vlan id 200

CIDR
* 2.2.2.0/24 for ns1::vpeerns1.100 and ns2::vpeerns2.200

OpenFlow rule (default)

```
ovs-ofctl dump-flows br0

# NXST_FLOW reply (xid=0x4):
#  cookie=0x0, duration=13357.785s, table=0, n_packets=0, n_bytes=0, idle_age=13357, priority=0 actions=NORMAL
```

OpenFlow rule (new)

```
ovs-ofctl del-flows br0
ovs-ofctl -O openflow13 add-flow br0 "dl_vlan=100 actions=mod_vlan_vid:200,output:2"
ovs-ofctl -O openflow13 add-flow br0 "dl_vlan=200 actions=mod_vlan_vid=100,output:1"

ovs-ofctl dump-flows br0
# NXST_FLOW reply (xid=0x4):
#  cookie=0x0, duration=1710.499s, table=0, n_packets=14, n_bytes=1068, idle_age=21, dl_vlan=200 actions=mod_vlan_vid:100,output:1
#  cookie=0x0, duration=1687.621s, table=0, n_packets=24, n_bytes=1216, idle_age=21, dl_vlan=100 actions=mod_vlan_vid:200,output:2
```
