#cloud-config
autoinstall:
  version: 1
  locale: ${locale}
  keyboard:
    layout: ${keyboard_layout}
    variant: ""
  timezone: ${time_zone}
  user-data:
    users:
    - name: ${ssh_username}
      plain_text_passwd: ${ssh_password}
      gecos: ${ssh_fullname}
      shell: /bin/bash
      lock_passwd: false
      sudo: ALL=(ALL) NOPASSWD:ALL
      groups: users, admin
