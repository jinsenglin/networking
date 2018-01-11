三表五鏈

---

http://linux.vbird.org/linux_server/0250simple_firewall.php#netfilter

![scenario](http://linux.vbird.org/linux_server/0250simple_firewall//iptables_02.png)

![scenario](http://linux.vbird.org/linux_server/0250simple_firewall//iptables_03.gif)

---

https://vsxen.github.io/2017/08/15/iptables/

![scenario](https://s3.amazonaws.com/cp-s3/wp-content/uploads/2015/09/08085516/iptables-Flowchart.jpg)

---

# List Rule

Rules in NAT Table

```
iptables -t -nat -L --line-numbers
```

# Add Rule

SNAT

```
# -j SNAT
iptables -t nat -A POSTROUTING ! -d 10.0.3.0/24 -o enp0s3 -j SNAT --to-source 10.0.2.15

# -j MASQUERADE
iptables -t nat -A POSTROUTING ! -d 10.0.3.0/24 -o enp0s3 -j MASQUERADE
```

DNAT

```
iptables -t nat -A PREROUTING -d 192.168.100.200 -j DNAT --to-destination 192.168.100.100
```

# Delete Rule

By Line Number

```
iptables -D -t <TABLE NAME> <CHAIN NAME> <RULE LINE NUMBER>
```
