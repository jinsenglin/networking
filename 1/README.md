http://vcpu.me/network1/

![scenario](http://vcpu.me/myimages/bridge1.png)

4 networking namespaces: root ns + 3 addtional ones - net0, net1, net2

1 physical device (enp0s8) in root ns

1 linux bridge (br0) in root ns

5 veth pairs
* one end of each veth pair is attached to linux bridge
* one end of each veth pair is moved to other ns
  * 1 for net0
    * eth0
  * 3 for net1
    * eth0
    * eth1
    * eth2
  * 1 for net2
    * eth0

CIDR
* 192.168.55.0/24 for enp0s8 and net1::eth2
* 10.0.1.0/24 for net0::eth0 and net1::eth0
* 10.0.2.0/24 for net2::eth0 and net1::eth1

default gw
* root ns default gw is 92.168.55.254
* net0 default gw is 10.0.1.2
* net1 default gw is 192.168.55.254
* net2 default gw is 10.0.2.2

ip forwarding via iptables
* ns net1 do snat for net0 and net2

iptables rules
* ip netns exec net1 iptables -t nat -A POSTROUTING -s 10.0.1.0/24 -o eth2 -j MASQUERADE
* ip netns exec net1 iptables -t nat -A POSTROUTING -s 10.0.2.0/24 -o eth2 -j MASQUERADE

NOTE

Using SNAT is better than MASQUERADE

```
ip netns exec net1 iptables -t nat -A POSTROUTING -s 10.0.2.0/24 -o eth2 -j SNAT --to-source 192.168.55.233
ip netns exec net1 iptables -t nat -A POSTROUTING -s 10.0.2.0/24 -o eth2 -j SNAT --to-source 192.168.55.233
```
