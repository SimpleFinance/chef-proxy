# providers/host.rb
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
# LWRP for managing /etc/hosts

require 'resolv'

def hosts_entries
  ::File.read('/etc/hosts').split("\n") if ::File.exists?('/etc/hosts')
end

action :create do
  new_resource.updated_by_last_action false
  updated = false
  ip = new_resource.ipaddr || Resolv.getaddress(new_resource.remote_host)
  to_write = "#{ip} #{new_resource.remote_host} # #{new_resource.comment}"
  text = hosts_entries || []

  if !text.include?(to_write)
    text = text.collect do |line|
      if /#{new_resource.remote_host}/.match(line) && !/#{ip}/.match(line)
        Chef::Log.info 'Replacing mismatched IP address associated with ' + new_resource.remote_host
        updated = true
        line.gsub(/\d+\.\d+\.\d+\.\d+/, ip)
      else
        line
      end
    end

    # if true, we already made a modification and are just recommitting text
    # else, we still need to update, but just append line we composed
    if updated
      ::File.open('/etc/hosts', 'w') {|f| f.puts text}
    else
      Chef::Log.info "Adding new host #{new_resource.remote_host} to hosts"
      ::File.open('/etc/hosts', 'a') {|f| f.puts to_write}
    end
    new_resource.updated_by_last_action true
  end
end

action :delete do
  new_resource.updated_by_last_action false
  updated = false
  text = hosts_entries

  if text.empty?
    Chef::Log.warn 'No /etc/hosts file found -- bailing'
    return
  end
  
  text = text.select do |line|
    if /#{new_resource.remote_host}/.match(line)
      Chef::Log.info "Deleted /etc/hosts entry #{new_resource.remote_host}"
      updated = true
      false
    else true end
  end

  if updated
    ::File.open('/etc/hosts', 'w') {|f| f.puts text}
    new_resource.updated_by_last_action true
  end
end

