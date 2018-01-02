# networking

1. http://vcpu.me/network1/
2. http://plasmixs.github.io/network-namespaces-ovs.html
3. https://www.rdoproject.org/networking/networking-in-too-much-detail/

# commands I

create ns, e.g. ns1

```
ip netns add ns1
```

turn on kernel ip forwarding

```
sysctl net.ipv4.ip_forward=1
```

turn on nic promisc mode, e.g. enp0s3

```
ifconfig enp0s3 promisc
```

create alias, e.g. enp0s3:0, with another IP, e.g., 192.168.168.1.6

```
ifconfig enp0s3:0 192.168.1.6 up 
```

create veth pair, e.g. veth0 and veth1

```
ip link add veth0 type veth peer name veth1
```

create tap, e.g. tap0

```
ip tuntap add name tap0 mode tap
```

create tun, e.g. tun0

```
ip tuntap add name tun0 mode tun
```

create route, e.g. default gw via 10.0.2.2

```
ip route add default via 10.0.2.2
```

create firewall rule, e.g. default policy of FORWARD chain

```
iptables -P FORWARD ACCEPT
```

create linux br, e.g. br0

```
brctl addbr br0
```

create linux br if, e.g. if0

```
?
```

create ovs br, e.g. br1

```
ovs-vsctl add-br br1
```

create ovs br port, e.g. port0

```
?
```

create ovs br flow, e.g. ?

```
?
```

# commands II

move device, e.g. tap0, from current ns to another ns, e.g. ns1

```
#ip link add tap0 type veth peer name tap1          # create veth pair
#ip netns add ns1                                   # create ns
ip link set dev tap0 netns ns1
#ip link exec ns1 ip link set dev tap0 name eth0    # rename tap0 -> eth0
#ip link exec ns1 ip addr add 10.0.1.2/24 dev eth0  # i.e. ifconfig eth0 10.0.1.2
#ip link exec ns1 ip link set dev eth0 up           # i.e. ifconfig eth0 up
```

attach virtual device, e.g. tap0, to linux bridge, e.g. br0

```
#ip link add tap0 type veth peer name tap1          # create veth pair
#brctl addbr br0                                    # create linux bridge
ip link set dev tap0 master br0
```

attach physical device, e.g. enp0s8, to linux bridge, e.g. br0

```
#ip addr flush dev enp0s8                           # clear physical device
#brctl addbr br0                                    # create linux bridge
brctl addif br0 enp0s8
```

# Difference between SNAT and Masquerade

REF https://unix.stackexchange.com/questions/21967/difference-between-snat-and-masquerade

```
The SNAT target requires you to give it an IP address to apply to all the outgoing packets. The MASQUERADE target lets you give it an interface, and whatever address is on that interface is the address that is applied to all the outgoing packets. In addition, with SNAT, the kernel's connection tracking keeps track of all the connections when the interface is taken down and brought back up; the same is not true for the MASQUERADE target.
```

```
Basically SNAT and MASQUERADE do the same source NAT thing in the nat table within the POSTROUTING chain.

Differences
* MASQUERADE does not require --to-source as it was made to work with dynamically assigned IPs
* SNAT works only with static IPs, that's why it has --to-source
* MASQUERADE has extra overhead and is slower than SNAT because each time MASQUERADE target gets hit by a packet, it has to check for the IP address to use.
```

# Linux Creating or Adding New Network Alias To a Network Card (NIC)

REF https://www.cyberciti.biz/faq/linux-creating-or-adding-new-network-alias-to-a-network-card-nic/

```
Linux allows you to add additional network address using alias feature. Please note that all additional network IP address must be in same subnet. For example if your eth0 using 192.168.1.5 IP address then alias must be setup using 192.168.1.0/24 subnet.
```

```
# ifconfig eth0:0 192.168.1.6 up
# eth0:0 first NIC alias: 192.168.1.6

ifconfig eth0:0 192.168.1.6 up
```
