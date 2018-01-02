https://yakking.branchable.com/posts/networking-5-dhcp/

2 networking namespaces: root ns + 1 additional one - ns1

1 veth pair
* one end is leaved in root ns
* one end is moved to ns ns1

CIDR
* 10.0.0.0/24 for the veth pair via dnsmasq

DHCP server running the ns ns1
