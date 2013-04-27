#!/usr/bin/env ruby

Vagrant.configure("2") do |config|

  config.vm.hostname = 'proxy'
  config.vm.box = ENV['VAGRANT_BOX'] || 'opscode-ubuntu-12.04'
  config.vm.box_url = ENV['VAGRANT_BOX_URL'] || "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/#{config.vm.box}.box"
  config.vm.network :private_network, ip: "33.33.33.10"

  config.vm.provision :chef_solo do |chef|
    data_bags = Dir.glob(::File.join('../**', 'data/*', '*.json')).each { |dir| dir.slice!(dir.split(/\//).last) }
    Dir.mkdir('../data_bags') unless Dir.exists?('../data_bags')
    FileUtils.cp_r(data_bags, '../data_bags')
    chef.data_bags_path = "../data_bags"
    chef.run_list = [
      'recipe[proxy::server]',
      'recipe[proxy::client]'
    ]
  end
end

