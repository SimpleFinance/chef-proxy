# recipes/client.rb
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
# Configures /etc/hosts to point specific traffic to a proxy

require 'resolv'

data_bag(node[:proxy][:databag]).sort.each do |client|
  data_bag_item(node[:proxy][:databag], client)['hosts'].each do |host|
    proxy_host host do
      ipaddr ::Resolv.getaddress(client['proxy_host'] || node[:proxy][:host])
      comment 'Aim at our proxy instance'
      action :create
    end
  end
end

