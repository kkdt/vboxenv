# Vagrant Sandbox

> This project is used to build out personal development sandboxes.

> If you are using a Windows box, please let me know if you run into any problems.

# Prebuilt Boxes

This project uses [geerlingguy](https://app.vagrantup.com/geerlingguy/boxes/centos7) prebuilt CentOS boxes to build out boxes in [kkdt](https://app.vagrantup.com/kkdt).

# Quick Start

1. Download and install [Virtual Box](https://www.virtualbox.org/wiki/VirtualBox)

2. Download and install [Vagrant](https://www.vagrantup.com/)

3. Install Oracle VM VirtualBox Extension Pack

4. Install plugins

   - Execute: `vagrant plugin [install|update] vagrant-vbguest`

   - Execute: `vagrant plugin [install|update] vagrant-winnfsd`

5. Drop a JSON file in `servers` directory with the falling minimum contents (box and unique VM identifier) to use the default VM configurations. More information on the JSON configurations in the following section.

    dev01.json

   ```json
   {
       "server": {
           "id" : "dev01"
       }
   }
   ```

# Sandbox JSON Configurations

## Base Configuration

```json
{
  "server": {
    "box":"",
    "id" : "dev01",
    "hostname" : "dev01",
    "memory" : 2048,
    "cpus" : 1,
    "network" : {},
    "hosts" : [],
    "scripts": [],
    "files": []
  }
}
```

## Staging Files to Guest

Add to the `files` attribute a list of source-destination data. The source is the full path to the file on the host machine; the destination is full path to the file on the guest. Staged files can be used in your custom `scripts` (below).

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

## Executing Scripts

Add to the `scripts` attributes a list of scripts/args that are in the current directory using relative path. Scripts will be execute in the order they are listed.

```
"scripts": [
  {
    "file": "scripts/bootstrap.sh",
    "args": []
  },
  {
    "file": "scripts/install_git.sh",
    "args": []
  },
  {
    "file": "scripts/install_jdk.sh",
    "args": ["/home/vagrant/rpms/jdk.rpm"]
  },
  {
    "file": "scripts/install_gradle.sh",
    "args": ["4.10.2"]
  },
  {
    "file": "scripts/install_aws.sh",
    "args": [ "AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "AWS_DEFAULT_REGION" ]
  }
]
```

## Networking

Add to the `network` attribute a list of host-guest port forwarding configurations, network type, etc.

```
"network" : {
  "type" : "private_network",
  "ip" : "10.10.1.150",
  "bridge" : [
    "eth0",
    "eth1",
    "eth2",
    "eth3",
    "en1: Thunderbolt 1",
    "en2: Thunderbolt 1",
    "en0: Wi-Fi (AirPort)"
  ],
  "ports" : [
    { "host": 9000, "guest": 19000 },
    { "host": 9001, "guest": 19001 },
    { "host": 9002, "guest": 19002 },
    { "host": 8000, "guest": 3000 },
    { "host": 8008, "guest": 8080 },
    { "host": 9920, "guest": 8920 }
  ]
}
```

## Configuring /etc/hosts

Add to the `hosts` attribute a list of other Vagrant virtual machines to connect them. The example below allows the current Vagrant machine to have visibility to two other Vagrant machines - qrmi2 and qrmi3.

```
"hosts": [
    {"hostname":"qrmi2", "ip":"10.10.1.2"},
    {"hostname":"qrmi3", "ip":"10.10.1.3"}
]
```

# Creating the Box Images

Create a box image of the current state of your virtual machine

1. Use `template.json.install` and copy it to `template.json` to use for the install

2. Update `template.json` (i.e. jdk location, gradle version, etc.)

3. Execute: `vagrant up template`

4. Execute: `vagrant package --base template --output c7dev.box`

# Vagrant Commands

   - `vagrant reload --no-provision`

   - `vagrant box add c7dev c7dev.box` - Other [Box](https://www.vagrantup.com/docs/cli/box.html) commands
