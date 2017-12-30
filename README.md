# networking

1. http://vcpu.me/network1/

# commands

create ns, e.g. ns1

```
ip netns add ns1
```

print routes in specified ns, e.g. ns1

```
ip netns exec ns1 route -n
```
