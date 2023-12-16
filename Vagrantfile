Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu-22.04-amd64'

  config.vm.provider :libvirt do |lv|
    lv.memory = 6*1024
    lv.cpus = 2
    lv.cpu_mode = 'host-passthrough'
    lv.nested = false
    lv.keymap = 'pt'
    lv.machine_virtual_size = 32
    config.vm.synced_folder '.', '/vagrant', type: 'nfs', nfs_version: '4.2', nfs_udp: false
  end

  config.vm.provision :shell, path: 'provision-resize-disk.sh'
  config.vm.provision :shell, path: 'provision.sh'
end
