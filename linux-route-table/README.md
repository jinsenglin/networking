Print Route Table (IPv4 Only)

```
route -n

OR

ip route
```

Add Default Gateway

```
route add default gw 10.0.2.2

OR

ip route add default via 10.0.2.2
```

Delete Default Gateway

```
route del default

OR

ip route del default
```

Add Static Route (net)

```
ip route add 192.0.2.0/24 via 192.168.33.102 [dev ifname]
```

Delete Static Route (net)

```
ip route del 192.0.2.0/24 via 192.168.33.102 [dev ifname]
```

Add Static Route (host)

```
ip route add 192.0.2.1 via 192.168.33.102 [dev ifname]
```

Delete Static Route (host)

```
ip route del 192.0.2.1 via 192.168.33.102 [dev ifname]
```
