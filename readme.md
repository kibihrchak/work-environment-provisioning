# Work Environment Provisioning

A set of Packer templates and accompanying files to provision an Ubuntu
VM work environment in several stages with snapshots in-between.

## Overview

Provisioning is done in several stages, through VM snapshots for
connecting steps, for example -

1.  Minimum Ubuntu installation in VM - Creates a VM with `base`
    snapshot.
2.  Provisioning minimum VM - Install needed packages, config files,
    etc. Starts from `base` snapshot, creates `provisioned` snapshot.
3.  Prepare for export, perform export - Do cleanup, minimization, then
    export VM to OVF and to Vagrant Box.

This is done in order to speed up learning on Packer use, but then too
to eliminate duplicated provisioning for different VMs that share a
common basis.

### [TODO] File Structure

## Getting Started

### Prerequisites

You'll need to have on your machine installed -

1.  Packer (<https://www.packer.io/>)
2.  VirtualBox (<https://www.virtualbox.org/>)

### Running

Run Packer by providing:

1.  A template name for the desired operation.
2.  A var file for selecting the machine.

Example for Ubuntu 19.10 -

```
packer build -var-file=minimum-ubuntu-install/var-files/ubuntu1910-desktop.json minimum-ubuntu-install.json
```

Same for 18.04

```
packer build -var-file=minimum-ubuntu-install/var-files/ubuntu1804-desktop.json minimum-ubuntu-install.json
```

## [TODO] Contributing

## [TODO] Versioning

## Authors

*   **Marko Oklobdzija** - [GitHub](https://github.com/kibihrchak)

See also the list of [GitHub
contributors](https://github.com/kibihrchak/work-environment-provisioning/contributors)
who participated in this project.

## [TODO] License

## Acknowledgments

*   Base Packer templates by fasmat - [Repo on GitHub](https://github.com/fasmat/ubuntu)
*   Readme file basis by PurpleBooth - [Gist on GitHub](https://gist.github.com/PurpleBooth/109311bb0361f32d87a2)
