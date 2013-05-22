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

class Chef::Recipe
  include Simple::Proxy
end

include_recipe 'haproxy::default'

node.override[:proxy][:server] = true
proxies = data_bag(node[:proxy][:databag]).sort.collect do |name|
  item = data_bag_item(node[:proxy][:databag], name)
  item['proxy_ip'] = item['proxy_host'] ? Resolv.getaddress(item['proxy_host']) : '*'
  item
end.select do |svc|
  if !verify(svc)
    Chef::Log.warn "Rejecting proxy host IP for #{svc['id']}"
    false
  else
    Chef::Log.info "Configuring proxy host IP for #{svc['id']}"
    true
  end
end

template '/etc/haproxy/haproxy.cfg' do
  owner 'root'
  group 'root'
  mode 00640
  variables(
    :global => node[:proxy][:global],
    :defaults => node[:proxy][:defaults],
    :backend => node[:proxy][:backend],
    :env => node[:proxy][:environment],
    :services => proxies )
  notifies :reload, 'service[haproxy]', :delayed
  action :create
end

