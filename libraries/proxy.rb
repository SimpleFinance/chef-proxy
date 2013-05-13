# libraries/proxy.rb
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
# Performs some basic operations on proxy data bag items

class Simple
  module Proxy
    
    def verify(item)
      return check_key(item, 'proxy_port') && include_ip?(item) && check_hosts(item)
    end

    private

    def check_key(item, key)
      item[key]
    end

    def check_hosts(item)
      item['hosts'] || item.fetch(node[:short_environment], {})['hosts']
    end

    def include_ip?(item)
      ip_addrs = node[:network][:interfaces].collect{|name,i| i['addresses']}.collect{|i| i.keys}.flatten
      ip_addrs.push '*'
      ip_addrs.include?(item['proxy_ip']) ? true : false
    end

  end
end

