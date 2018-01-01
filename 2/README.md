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

ip forwarding
* root ns do nat for ns1 and ns2

# PART II - VLAN

WIP
