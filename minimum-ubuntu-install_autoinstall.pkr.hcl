packer {
  required_version = ">= 1.9.4, < 2.0.0"
  required_plugins {
    virtualbox = {
      version = "~> 1"
      source  = "github.com/hashicorp/virtualbox"
    }
  }
}

source "virtualbox-iso" "autoinstall" {
  boot_command         = [
    "c<wait>",
    "linux /casper/vmlinuz autoinstall ds='nocloud;s=http://{{.HTTPIP}}:{{.HTTPPort}}/'<enter><wait>",
    "initrd /casper/initrd<enter><wait>",
    "boot<enter>",
  ]
  boot_wait            = "5s"
  disk_size            = "${var.disk_size}"
  guest_additions_path = "VBoxGuestAdditions_{{ .Version }}.iso"
  guest_os_type        = "Ubuntu_64"
  hard_drive_interface = "sata"
  headless             = "${var.headless}"
  http_content = {
    "/user-data" = templatefile("${var.hcl_name}/installer-automation/autoinstall/user-data.pkrtpl.hcl", var)
    "/meta-data" = ""
    "/vendor-data" = ""
  }
  iso_checksum            = "${var.iso_checksum}"
  iso_urls                = ["${var.iso_path}/${var.iso_name}", "${var.iso_url}"]
  keep_registered         = "true"
  output_directory        = "output/${var.vm_name}-virtualbox-iso"
  post_shutdown_delay     = "1m"
  shutdown_command        = "echo '${var.ssh_password}' | sudo -S shutdown -P now"
  skip_export             = "true"
  ssh_password            = "${var.ssh_password}"
  ssh_username            = "${var.ssh_username}"
  ssh_timeout             = "10000s"
  vboxmanage              = [
    //  TODO: <https://github.com/hashicorp/packer-plugin-virtualbox/issues/104>
    ["modifyvm", "{{ .Name }}", "--nat-localhostreachable1", "on"],

    ["modifyvm", "{{ .Name }}", "--nictype1", "virtio"],
    ["modifyvm", "{{ .Name }}", "--memory", "${var.memory}"],
    ["modifyvm", "{{ .Name }}", "--cpus", "${var.cpus}"],
    ["modifyvm", "{{ .Name }}", "--vram", "${var.vram}"],
    ["modifyvm", "{{ .Name }}", "--accelerate2dvideo", "on"],
    ["modifyvm", "{{ .Name }}", "--clipboard-mode", "bidirectional"],
    ["modifyvm", "{{ .Name }}", "--usb", "on"],
    ["modifyvm", "{{ .Name }}", "--usbxhci", "on"],
    ["modifyvm", "{{ .Name }}", "--graphicscontroller", "vmsvga"],
    ["sharedfolder", "add", "{{ .Name }}", "--name", "virtualbox", "--hostpath", "${var.shared_folder_path}", "--automount"]]
  vboxmanage_post         = [["snapshot", "{{ .Name }}", "take", "${var.snapshot_name}"]]
  virtualbox_version_file = ".vbox_version"
  vm_name                 = "${var.vm_name}"
}

build {
  description = "Minimum Ubuntu VM unattended installation via autoinstall"

  sources = ["source.virtualbox-iso.autoinstall"]

  provisioner "shell" {
    environment_vars  = [
      "SSH_USERNAME=${var.ssh_username}",
      "SSH_PASSWORD=${var.ssh_password}"
    ]
    execute_command   = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    expect_disconnect = "true"
    scripts           = ["${var.hcl_name}/scripts/su_setup-user.sh"]
  }

  provisioner "shell" {
    environment_vars  = ["UPGRADE=${var.upgrade}"]
    expect_disconnect = "true"
    scripts           = ["scripts/update+upgrade.sh"]
  }

  provisioner "shell" {
    environment_vars  = [
      "CLEANUP_PAUSE=${var.cleanup_pause}",
      "DEBIAN_FRONTEND=noninteractive",
      "INSTALL_VAGRANT_KEY=${var.install_vagrant_key}",
      "SSH_USERNAME=${var.ssh_username}",
      "SSH_PASSWORD=${var.ssh_password}"
    ]
    execute_command   = "echo '${var.ssh_password}' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    expect_disconnect = "true"
    scripts           = [
      "${var.hcl_name}/scripts/su_update-disable.sh",
      "${var.hcl_name}/scripts/su_vagrant.sh",
      "${var.hcl_name}/scripts/su_sshd.sh",
      "${var.hcl_name}/scripts/su_vmware.sh",
      "${var.hcl_name}/scripts/su_virtualbox.sh",
      "${var.hcl_name}/scripts/su_grub.sh",
      "${var.hcl_name}/scripts/su_ansible.sh"
    ]
  }
}
