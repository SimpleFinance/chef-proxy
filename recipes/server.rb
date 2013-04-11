# recipes/server.rb
#
# Author: Simple Finance <ops@simple.com>
# License: Apache License, Version 2.0
#
# Copyright 2013 Simple Finance Technology Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Sets up instance as a proxy

require 'resolv'

include_recipe 'haproxy::default'

proxies = data_bag(node[:proxy][:databag]).collect do |name|
  data_bag_item(node[:proxy][:databag], name)
end.select do |svc|
  unless svc['proxy_port']
    Chef::Log.warn("#{svc['id']} has no `proxy_port`")
    false
  end
  
  unless svc['hosts'] || svc.fetch(node[:short_environment], {})['hosts']
    Chef::Log.warn("#{svc['id']} has no hosts")
    false
  end

  Chef::Log.info "Configuring proxy host IP for #{svc['id']}"
  svc['proxy_host'] = svc['proxy_host'] ? ::Resolv.getaddress(svc['proxy_host']) : '*'
  true
end

resource = resources('template[/etc/haproxy/haproxy.cfg]')
resource.cookbook 'proxy'
resource.variables(
  :global => node[:proxy][:global],
  :defaults => node[:proxy][:defaults],
  :backend => node[:proxy][:backend],
  :env => node[:proxy][:environment],
  :services => proxies.sort_by {|s| s['id']} )

