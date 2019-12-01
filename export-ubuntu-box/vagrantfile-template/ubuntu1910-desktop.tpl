Vagrant.configure("2") do |config|
    config.vm.define "ubuntu1910-desktop"
    config.vm.box = "kibihrchak/ubuntu1910-desktop"

    config.vm.provider :virtualbox do |v, override|
        v.gui = true
        v.customize ["modifyvm", :id, "--name", "Ubuntu 19.10"]
        v.customize ["modifyvm", :id, "--memory", 2048]
        v.customize ["modifyvm", :id, "--cpus", 2]
        v.customize ["modifyvm", :id, "--vram", "32"]
        v.customize ["modifyvm", :id, "--accelerate3d", "on"]
        v.customize ["modifyvm", :id, "--ioapic", "on"]
        v.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    end
end
