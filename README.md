# networking

1. http://vcpu.me/network1/
2. http://plasmixs.github.io/network-namespaces-ovs.html
3. https://yakking.branchable.com/posts/networking-5-dhcp/
4. https://www.rdoproject.org/networking/networking-in-too-much-detail/
5. http://blog.davidvassallo.me/2012/05/05/kvm-brctl-in-linux-bringing-vlans-to-the-guests/
6. http://www.sdnlab.com/5365.html

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

create nic alias, e.g. enp0s3:0, with another IP, e.g., 10.0.2.25

```
ifconfig enp0s3:0 10.0.2.25 up 
```

create nic vlan, e.g. enp0s3.100

```
modprobe 8021q
ip link add link enp0s3 name enp0s3.100 type vlan id 100
```

create ovs br port vlan, e.g.

```
ovs-vsctl add-port br0 tap0 tag=100
```

create ovs br port vxlan, e.g.

```
ovs-vsctl add-port br0 vx1 -- set interface vx1 type=vxlan options:remote_ip=192.168.100.102
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

create ovs br, e.g. br1

```
ovs-vsctl add-br br1
```

create ovs br flow, e.g.

```
ovs-ofctl -O openflow13 add-flow br0 "dl_vlan=100 actions=mod_vlan_vid:200,output:2"
ovs-ofctl -O openflow13 add-flow br0 "dl_vlan=200 actions=mod_vlan_vid=100,output:1"
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

attach virtual device, e.g. tap0, to ovs bridge, e.g., br0

```
#ip link add tap0 type veth peer name tap1          # create veth pair
#ovs-vsctl add-br br0                               # create ovs bridge
ovs-vsctl add-port br0 tap0
```

attach physical device, e.g. enp0s8, to ovs bridge, e.g. br0

```
#ip addr flush dev enp0s8                           # clear physical device
#ovs-vsctl add-br br0                               # create ovs bridge
ovs-vsctl add-port br0 enp0s8
```

# commands III

```
ifconfig eth0

=

ip addr show dev eth0
```

```
vconfig add enp0s3 100

=

ip link add link enp0s3 name enp0s3.100 type vlan id 100
```

```
brctl addbr br0

=

ip link add name br0 type bridge
ip link set br0 up
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

# KVM MAC Naming Pattern

Host: `fe:54:00:b1:33:46`

```
# ifconfig vnet0
vnet0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet6 fe80::fc54:ff:feb1:3346  prefixlen 64  scopeid 0x20<link>
        ether fe:54:00:b1:33:46  txqueuelen 1000  (Ethernet)
        RX packets 1362103  bytes 22112236891 (20.5 GiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 4247167  bytes 383364556 (365.6 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

Guest: `52:54:00:b1:33:46`

```
ifconfig eth0
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 101.0.202.30  netmask 255.255.255.0  broadcast 101.0.202.255
        inet6 fe80::5054:ff:feb1:3346  prefixlen 64  scopeid 0x20<link>
        ether 52:54:00:b1:33:46  txqueuelen 1000  (Ethernet)
        RX packets 4248531  bytes 383514604 (365.7 MiB)
        RX errors 0  dropped 580712  overruns 0  frame 0
        TX packets 1362740  bytes 22135848795 (20.6 GiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

OpenStack KVM :: Guest :: eth0 `fa:16:3e:24:c6:cc`

OpenStack KVM :: HOST (i.e. Compute Node) :: tapb4facc08-c9 `fe:16:3e:24:c6:cc`

* -> linux bridge :: qbrb4facc08-c9
* -> veth pair :: linux bridge port :: qvbb4facc08-c9@qvob4facc08-c9
* -> veth pair :: ovs br-int port :: qvob4facc08-c9@qvbb4facc08-c9

diagram see

* https://github.com/lorin/openstack-hackspace/blob/master/under-the-hood-network.md
* http://abregman.com/2016/01/06/openstack-neutron-troubleshooting-and-solving-common-problems/
