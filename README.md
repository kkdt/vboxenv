# vboxenv

> This project is used to build out personal development sandboxes.

> If you are using a Windows box, please let me know if you run into any problems.

## Quick Start

1. Download and install [Virtual Box](https://www.virtualbox.org/wiki/VirtualBox)

1. Download and install [Vagrant](https://www.vagrantup.com/)

1. Install Oracle VM VirtualBox Extension Pack

1. Install plugins

   - Execute: `vagrant plugin [install|update] vagrant-vbguest`

   - Execute: `vagrant plugin [install|update] vagrant-winnfsd`

1. Copy [centos7.json](servers/centos7.json) to `servers/local/centos7.json` and Vagrant will process it to create and 
   provision the virtual machine
   - This configuration uses [geerlingguy](https://app.vagrantup.com/geerlingguy/boxes/centos7) CentOS boxes

## JSON Configurations

### JSON Contents

```json
{
    "box": "geerlingguy/centos7",
    "id" : "centos7",
    "hostname": "centos7", 
    "gui": false,
    "memory": 2048,
    "cpus": 1,
    "vram": 8,
    "acceleration": "default|hyperv|kvm|legacy|minimal",
    "update_vbguest": true,
    "network" : [],
    "files": [],
    "scripts": []
}
```

### VirtualBox Settings

VirtualBox configurations can be set via JSON for the virtual machine.

1. `box`: Vagrant box identifier

1. `id`: VirtualBox virtual machine identifier

1. `memory`: Memory

1. `cpus`: CPU cores

1. `hostname`: The virtual machine hostname

1. `gui`: Show the virtual machine GUI on power on

1. `vram`: Video memory in MB

1. `acceleration`: VirtualBox acceleration option

1. `update_vbguest`: Set to true to update Guest Additions if plugin is available

1. `nested_virt`: true|false for nested virtualization

### Staging Files to Guest

Add to the `files` attribute a list of source-destination data. The source is the full path to the file on the host machine;
the destination is full path to the file on the guest. Staged files can be used in your custom `scripts` (below).

```
"files" : [
  {
    "source": "/Users/thinh/Downloads/jdk-8u201-linux-x64.rpm",
    "destination": "/home/vagrant/rpms/jdk.rpm"
  },
  {
    "source": "/Users/thinh/Downloads/mysql-community-common-5.7.18-1.el7.x86_64.rpm",
    "destination": "/home/vagrant/rpms/1-mysql-community-common-5.7.18-1.el7.x86_64.rpm"
  },
  {
    "source": "/Users/thinh/Downloads/mysql-community-libs-5.7.18-1.el7.x86_64.rpm",
    "destination": "/home/vagrant/rpms/2-mysql-community-libs-5.7.18-1.el7.x86_64.rpm"
  }
]
```

### Executing Scripts

Add to the `scripts` attributes a list of scripts/args that are in the current directory using relative path. Scripts will be executed in the order they are listed.

```
"scripts": [
  {
    "run": "once|always|never",
    "name": "git",
    "upload_path", "/home/vagrant/install_git.sh",
    "path": "scripts/install_git.sh",
    "args": []
  }
]
```

### Networking

Add to the `network` attribute a list of host-guest port forwarding configurations, network type, etc.

**NAT**

```
"network" : []
```

**Private Network (DHCP)**

```
"network" : [
  { "type": "private_network"}
]
```

**Private Network (Static IP)**

```
"network" : [
  { "type": "private_network", "ip": "192.168.56.101" }
]
```

**Port Forward**

Optional `id` attribute.

```
"network" : [
  { "type" : forwarded_port", "guest": 22, "host": 8022 },
  { "type" : forwarded_port", "guest": 80, "host": 8080, "id": "apache" }
]
```

## Vagrant Commands

- `vagrant reload --no-provision`

- `vagrant box add c7dev c7dev.box` - Other [Box](https://www.vagrantup.com/docs/cli/box.html) commands

- `vagrant package --base template --output c7dev.box`

- `VBoxManage modifyvm <id> --nested-hw-virt on` - Enable nested virtualization

## MacBook

When Mac updates the OS to a new version or when installing a new version of VirtualBox,

- Oracle VirtualBox must be allowed in "Privacy and Security" settints
- Rebuild all Vagrant plugins