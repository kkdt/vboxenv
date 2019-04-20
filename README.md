# Vagrant Sandbox

> This project is used to build out personal development sandboxes.

> If you are using a Windows box, please let me know if you run into any problems.

# Prebuilt Boxes

This project uses [geerlingguy](https://atlas.hashicorp.com/geerlingguy/boxes/centos7) prebuilt CentOS boxes to build out development sandboxes.

| Box                     | Description   | Download                       |
| ----------------------- | ------------- | ------------------------------ |
| kkdt.box                | No desktop    | TODO       |


# Setting Up Your Development Virtual Machine

1. Download and install [Virtual Box](https://www.virtualbox.org/wiki/VirtualBox)

2. Download and install [Vagrant](https://www.vagrantup.com/)

3. Install Oracle VM VirtualBox Extension Pack

4. Install plugins

   - Execute: `vagrant plugin install vagrant-vbguest`

   - Execute: `vagrant plugin install vagrant-winnfsd`

5. Install prebuilt boxes

   - Download each box from above (or just download the one you want to use)

   - Execute: `vagrant box add kkdt kkdt.box`

# Sandbox JSON Configurations

## Base Configuration

```json
{
    "server": {
        "box":"",
        "id" : "dev01",
        "hostname": "dev01",
        "memory": 2048,
        "cpus":1,
        "network" : {},
        "aws":{}
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
        { "host": 9920, "guest": 8920 }
    ]
}
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

# Creating the Box Images

Create a box image of the current state of your virtual machine

1. Download the latest Oracle JDK

2. Use `template.json.install` and copy it to `template.json` to use for the install

3. Update `template.json` (i.e. jdk location, gradle version, etc.)

4. Execute: `vagrant up template --provision-with file,base-install`

5. Execute: `vagrant package --base template --output kkdt.box`

# Vagrant Commands

   - `vagrant reload --no-provision`

   - `vagrant box add c7dev c7dev.box` - Other [Box](https://www.vagrantup.com/docs/cli/box.html) commands
