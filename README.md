# Chef Proxy cookbook

A cookbook for managing /etc/hosts.local. Wraps around the Opscode HAproxy
cookbook (https://github.com/opscode-cookbooks/haproxy)

## Use cases

We use this cookbook to trick service instances into sending traffic meant for external
/ third-party services through a proxy instance we control. The proxy instance
runs HAproxy, while the service instances have their /etc/hosts.local modified
to route endpoint traffic towards this proxy. This lets us more easily manage egress traffic.

## Recipes

#### Default
Calls the `Server` recipe

#### Server
Configures an instance to route traffic via HAproxy

#### Client
Configures an instance to send traffic destined for a host to go through a
proxy instance via the `node[:proxy][:host]` attribute.

## Resources

#### Host
This resource creates, modifies, or deletes an /etc/hosts.local entry using either
the :create (default) or :delete action. Includes the following parameters:

```
remote_host - the endpoint of the traffic (name attribute)
ipaddr - IP address to proxy the traffic through (optional)
comment - Comment for extra information appended to the entry (optional)
action - One of :create (default) or :delete
```

## Author
Simple Finance <ops@simple.com>

## License
Apache License, Version 2.0
