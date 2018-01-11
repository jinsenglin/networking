Print Route Table (IPv4 Only)

```
netstat -nr -f inet
```

Add Static Route

```
sudo route -n add -net 192.168.10.0/24  192.168.140.81
```

Delete Static Route

```
sudo route -n delete -net 192.168.10.0/24  192.168.140.81
```
