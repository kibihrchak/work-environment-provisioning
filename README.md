# Work Environment Provisioning

A set of Packer templates and accompanying files to provision a needed
Ubuntu VM work environment step-by-step.

## Overview

Provisioning is done in several stages, through VM snapshots for
connecting steps, for example -

1.  Minimum Ubuntu installation in VM - Creates a VM with `base`
    snapshot.
2.  Provisioning minimum VM - Install needed packages, config files,
    etc. Process starts from `base` snapshot, going through intermediate
    custom-named snapshots, and finally creates `provisioned` snapshot.
3.  Prepare for export, perform export - Do cleanup, minimization of
    `provisioned` snapshot, then export VM to OVF.

This staging is done in order to:

1.  Speed up learning how to use Packer - Snapshots allow for faster
    retrying of a certain provisioning phase.
2.  To eliminate duplicated provisioning for different VMs that share a
    common basis.

### Components

1.  Packer template - Specifies the particular provisioning phase.
2.  Machine type - Set of Packer variables that describe a particular
    machine (eg. Ubuntu 19.10) for the given Packer template. Used to
    perform different provisioning phases on the same machine.
3.  VM name - Name for the VM on which Packer will operate. Defaults to
    the machine type.

### File Structure

1.  Packer templates are provided as `.json` files in the repo root.
    They may be grouped through naming convention (see bellow on that).
2.  You can find a template-accompanying stuff in the repo root: 
    1.  `scripts` - Scripts to be executed during provisioning, as
        needed by a given template.
    2.  `files` - Files that may be deployed on the target, either by
        these scripts, or manually.
3.  Each template (or a template group) has a same-named directory with
    accompanying stuff, as described for the repo root. In addition,
    there is:
    1.  `var-files` - Machine types.
4.  VM disks are located in `output` directory
5.  Output is generated in the following directories:
    1.  `output-<machine-name>` for OVA files.

Packer templates are grouped through a naming scheme -
`<category>_<name>.*`. This is a pure syntactical thing used to more
easily find necessary files.

## Getting Started

### Prerequisites

You'll need to have on your machine installed -

1.  Packer (<https://www.packer.io/>) - Tested with `>= 1.4.4`.
2.  VirtualBox (<https://www.virtualbox.org/>) - Tested with `>= 6.1.2`.

### Running

Run Packer by providing:

1.  A template name for the desired operation.
2.  A var file for selecting the machine.

Example for Ubuntu 19.10 (preseed) initial setup  -

```bash
packer build \
    -var 'shared_folder_path=/c/temp' \
    -var-file=minimum-ubuntu-install/var-files/preseed/ubuntu1910-desktop.json \
    minimum-ubuntu-install_preseed.json
```

For Ubuntu 22.04 (autoinstall) it is -

```bash
packer build \
    -var 'shared_folder_path=/c/temp' \
    -var-file='minimum-ubuntu-install/var-files/autoinstall/ubuntu2204-desktop.pkr.hcl' \
    -only "virtualbox-iso.autoinstall" \
    .
```

These may be followed by setup, and export runs. Here's an example for
19.10, to set up graphical interface, do Buildroot build and network
boot setup for RPi, and export the machine -

```bash
packer build \
    -var 'attach_snapshot=base' -var 'target_snapshot=xfce' \
    -var-file=provision-ubuntu-vm/var-files/ubuntu1910-desktop.json \
    -var 'ansible_playbooks=xfce4,doublecmd' \
    ansible-provision-ubuntu-vm.json
packer build \
    -var 'attach_snapshot=xfce' \
    -var-file=provision-ubuntu-vm/var-files/ubuntu1910-desktop.json \
    provision-ubuntu-vm_rpi-buildroot.json
packer build \
    -var-file=export-ubuntu-ovf/var-files/ubuntu1910-desktop.json \
    export-ubuntu-ovf.json
```

#### Two Ways of Provisioning VM Components

Note in the previous example that there are two ways provisioning how
provisioning was done:

1.  Through standalone Packer template running shell scripts -
    `provision-ubuntu-vm_rpi-buildroot.json`.
2.  Through common Ansible provisioning template running provisioning
    for the given components - `ansible-provision-ubuntu-vm.json`. In
    this case provisioned components are `xfce4`, and `doublecmd`.

Ansible-way is preferred for anything but the base provisioning. The
first way was the original one and will be fully transitioned to Ansible
with time.

#### Customizing Build

For intermediate provisioning, snapshot names have to be changed from
the default ones (`base` as an attach, `provisioned` as a target
snapshot). Sample - 

```bash
packer build \
    -var 'attach_snapshot=xfce' -var 'target_snapshot=rpi' \
    -var 'buildroot_archive_path=//media/sf_virtualbox/buildroot.tgz' \
    -var-file=provision-ubuntu-vm/var-files/ubuntu1910-desktop.json \
    provision-ubuntu-vm_rpi-buildroot.json
```

This sample also contains an additional configuration var,
`buildroot_archive_path`.

#### `minimum-ubuntu-install_*.json`

For building up the VM, it is useful to have a shared directory
attached. So, this template requires specifying a shared directory to be
mounted to the VM, host path specified as a `shared_folder_path` var.

#### Vagrant Box Export

Vagrant box export is optional. In order to get it, it is necessary to:

1.  Set `install_vagrant_key` to `true` when provisioning the VM.
2.  Run:
    ```base
    packer build \
        -var-file=export-vagrant-box/var-files/ubuntu1910-desktop.json \
        export-vagrant-box.json
    ```

## [TODO] Contributing

## [TODO] Versioning

## Authors

*   **Marko Oklobdzija** - <https://github.com/kibihrchak>

See also the list of [GitHub
contributors](https://github.com/kibihrchak/work-environment-provisioning/contributors)
who participated in this project.

## Acknowledgments

*   Base Packer templates by fasmat -
    <https://github.com/fasmat/ubuntu>
*   Readme file basis by PurpleBooth -
    <https://gist.github.com/PurpleBooth/109311bb0361f32d87a2>
*   Ubuntu 20.04 image link -
    <https://github.com/boxcutter/ubuntu/blob/master/ubuntu2004.json>
