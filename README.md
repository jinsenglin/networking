# networking

1. http://vcpu.me/network1/

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
