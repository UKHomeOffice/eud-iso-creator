VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = 'ubuntu/xenial64'

    config.vm.define :eudisocreator

    config.vm.provision :file,
      source: "./src/",
      destination: "~/iso_creator/"

    config.vm.provision :shell,
      path: "requirements.sh"

    config.vm.provision :shell,
      inline: "/home/ubuntu/iso_creator/create_iso.sh"

    config.vm.synced_folder "iso_image", "/root/iso_image/"

end
