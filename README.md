# Vagrant Sandbox

Template for projects that utilize Vagrant.

# Quickstart

1. Download and install [Virtual Box](https://www.virtualbox.org/wiki/VirtualBox)

2. Download and install [Vagrant](https://www.vagrantup.com/)

3. Oracle VM VirtualBox Extension Pack

3. Clone/fork this project and navigate into checkout

4. Execute `vagrant status` to see the available VM(s) (the base server is always available)

5. Execute `vagrant up <vm>` to start the pre-built VM

6. Execute `vagrant ssh <vm>` to ssh into VM

7. Once you are in, you should be logged in as the `vagrant` user (default password is `vagrant`) and you will have 

    a. full sudo to do whatever you need
    
    b. `/vagrant` is where the checkout is mounted by default, whatever you edit on your host will be reflected on the guest and vice versa 

# Configurations

1. Vagrant box image provided by [geerlingguy](https://atlas.hashicorp.com/geerlingguy/boxes/centos7)

2. Server configurations are json-based (a ton of examples online) - use `servers/base.json` as an example

3. The `id` attribute must be unique within all the json configurations

```JSON
{
    "server": {
        "id" : "h01",
        "hostname": "h01",
        "memory": 512,
        "cpus":1,
        "desktop": {
            "type":"gnome",
            "display":true
        },
        "network" : {
            "type" : "private_network",
            "ip" : "10.10.1.15",
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
              { "host": 8080, "guest": 80 }
            ]
        }
    }
}
```

## Desktop Environment

If you want Vagrant to start up with a Desktop Manager, include the following in your JSON configuration. It currently supports Gnome and Xfce environments.

```json
"desktop": {
    "type":"gnome", // gnome|xfce
    "display":true // true will display the VirtualBox destop immediate on a 'vagrant up'
}
```

## AWS Development

Your Vagrant image can be provisioned with the latest AWS CLI and your AWS developer credentials by including the following in your JSON configuration. 

```json
"aws": {
    "accessKey": "...", // i.e. the AWS_ACCESS_KEY_ID
    "accessSecret": "...", // i.e. the AWS_SECRET_ACCESS_KEY
    "region": "us-east-1"
}
```

Once you boot up your Vagrant box, log into and it test out the AWS configuration.

```bash
[vagrant@h01 ~]$ env | grep -i aws
AWS_DEFAULT_REGION=us-east-1
AWS_SECRET_ACCESS_KEY=...
AWS_ACCESS_KEY_ID=...

```


# Scripts

Virtual machine provisioning scripts are located in `scripts`.

# Common Vagrant Commands

More information can be found in the [Vagrant CLI Documentation](https://www.vagrantup.com/docs/cli/).

| Command                           | Description                     |
| --------------------------------- | ------------------------------- |
| `vagrant up`                      | Builds and starts up the Vagrant image   |
| `vagrant ssh [-- sshOptions]`     | Logs into the Vagrant/VirtualBox environment (single vm)  |
| `vagrant halt`                    | Gracefully shuts down the virtual machine        |
| `vagrant destroy [-f]`            | Removes all VirtualBox image files for the environment   |
| `vagrant box update`              | Manage box images |
| `vagrant box list`                | Manage box images |
| `vagrant box remove`              | Manage box images. For example, `vagrant box remove geerlingguy/centos7 --all` then inspect `~/.vagrant.d/boxes` to confirm removal |



> Original project exported from a personal subversion server into a git repository, and pushed to Github.
