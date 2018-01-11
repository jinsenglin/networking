Print Route Table (IPv4 Only)

```
netstat -nr -f inet
```

Add Static Route (net)

```
sudo route add -net 192.168.10.0/24  192.168.140.81
```

Delete Static Route (net)

```
sudo route delete -net 192.168.10.0/24  192.168.140.81
```

Add Static Route (host)

```
sudo route add -host 192.168.10.10/32  192.168.140.81
```

Delete Static Route (host)

```
sudo route delete -host 192.168.10.10/32  192.168.140.81
```
