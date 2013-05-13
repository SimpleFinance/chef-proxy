# libraries/verifier.rb
#
# Performs some basic operations on proxy data bag items

class Simple
  module Proxy
    
    def verify(item)
      return check_key(item, 'proxy_port') || ip_match?(item) || check_hosts(item)
    end

    private

    def check_key(item, key)
      item[key]
    end

    def check_hosts(item)
      item['hosts'] || item.fetch(node[:short_environment], {})['hosts']
    end

    def ip_match?(item)
      item['proxy_host'] ? node[:ipaddress] == Resolv.getaddress(item['proxy_host']) : true
    end

  end
end

