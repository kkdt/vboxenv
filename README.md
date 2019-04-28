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
        "aws" : {},
        "rpms" : []
    }
}
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

## AWS Credentials

Include AWS credentials in the JSON configuration and your credentials will be installed as environment variables with the AWS CLI.

```
"aws": {
    "accessKey": "....",
    "accessSecret": "....",
    "region": "us-east-1"
}
```

## Installing RPMs

RPM files listed under the `rpms` attribute will be installed during a Vagrant up in the order they are specified. All files will be placed in the `/tmp` directory in the VM and removed after installation.

```
"rpms": [
    "/Users/thinh/Downloads/mysql-community-common-5.7.18-1.el7.x86_64.rpm",
    "/Users/thinh/Downloads/mysql-community-libs-5.7.18-1.el7.x86_64.rpm",
    "/Users/thinh/Downloads/mysql-community-client-5.7.18-1.el7.x86_64.rpm",
    "/Users/thinh/Downloads/mysql-community-server-5.7.18-1.el7.x86_64.rpm"
]
```

# Creating the Box Images

Create a box image of the current state of your virtual machine

1. Download the latest Oracle JDK

2. Use `template.json.install` and copy it to `template.json` to use for the install

3. Update `template.json` (i.e. jdk location, gradle version, etc.)

4. Execute: `vagrant up template --provision-with file,base-install[,rpms]`

5. Execute: `vagrant package --base template --output c7dev.box`

# Vagrant Commands

   - `vagrant reload --no-provision`

   - `vagrant box add c7dev c7dev.box` - Other [Box](https://www.vagrantup.com/docs/cli/box.html) commands
