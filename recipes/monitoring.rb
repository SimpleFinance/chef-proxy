# recipes/monitoring.rb
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
# Use Sensu? So do we! Auto check generation

# Deploy a sensu_check per HAProxy backend
data_bag(node[:proxy][:databag]).sort.each do |item|
  client = data_bag_item(node[:proxy][:databag], item)
  user, pass = node[:proxy][:defaults][:stats_auth].split(':')

  sensu_check "#{client['id']}-backend" do
    command "haproxy-backend.rb -b #{client['id']}-backend -u #{user} -p #{pass}"
    subscribers client['proxy_host'] || node[:proxy][:host]
    handlers node[:proxy][:sensu][:handlers] || ['default']
    interval node[:proxy][:sensu][:check_interval] || 15
    additional(
      :occurrences => node[:proxy][:sensu][:occurrences] || 4 )
  end
end

