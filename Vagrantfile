
Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/trusty64"

  # Configure the virtual machine to use 2GB of ram
  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

  config.vm.provision :shell, path: "bootstrap.sh"

end
