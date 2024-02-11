variable "cleanup_pause" {
  type = string
  default = ""
}

variable "cpus" {
  type = number
}

variable "disk_size" {
  type = number
}

variable "headless" {
  type = bool
  default = false
}

variable "hostname" {
  type = string
  default = "vm"
}

variable "install_vagrant_key" {
  type = bool
  default = false
}

variable "iso_checksum" {
  type = string
}

variable "iso_name" {
  type = string
}

variable "iso_url" {
  type = string
}

variable "memory" {
  type = number
}

variable "shared_folder_path" {
  type = string
}

variable "snapshot_name" {
  type = string
  default = "base"
}

variable "ssh_fullname" {
  type = string
  default = "VM user"
}

variable "ssh_username" {
  type = string
  default = "vmuser"
}

variable "ssh_password" {
  type = string
  default = "vmuser"
}

variable "uid" {
  type = string
  default = "1000"
}

variable "time_zone" {
  type = string
}

variable "upgrade" {
  type = bool
}

variable "vm_name" {
  type = string
}

variable "vram" {
  type = number
}

variable "hcl_name" {
  type = string
  default = "minimum-ubuntu-install"
}

variable "iso_path" {
  type = string
  default = "iso"
}

variable "locale" {
  type = string
}

variable "keyboard_layout" {
  type = string
}
