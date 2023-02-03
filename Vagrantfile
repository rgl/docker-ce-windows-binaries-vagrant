Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu-22.04-amd64'

  config.vm.provider :libvirt do |lv|
    lv.memory = 6*1024
    lv.cpus = 2
    lv.cpu_mode = 'host-passthrough'
    lv.nested = false
    lv.keymap = 'pt'
    config.vm.synced_folder '.', '/vagrant', type: 'nfs', nfs_version: '4.2', nfs_udp: false
  end

  config.vm.provider :virtualbox do |vb|
    vb.linked_clone = true
    vb.memory = 6*1024
  end

  config.vm.provision :shell, path: 'provision.sh'
end
