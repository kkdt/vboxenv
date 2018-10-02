# Vagrant Sandbox

Template for projects that utilize Vagrant.

## Quickstart

1. Download and install [Virtual Box](https://www.virtualbox.org/wiki/VirtualBox)
2. Download and install [Vagrant](https://www.vagrantup.com/)
3. Clone/fork this project and navigate into checkout
4. Execute `vagrant status` to see the available VM(s) (the base server is always available)

## Configurations

1. Vagrant box image provided by [geerlingguy](https://atlas.hashicorp.com/geerlingguy/boxes/centos7)
2. Server configurations are json-based (a ton of examples online) - use `servers/base.json` as an example
3. The `id` attribute must be unique within all the json configurations

```JSON
{
   "server": {
      "id" : "h01",
      "hostname": "h01",
      "memory": 1028,
      "network" : {
         "type" : "private_network",
         "ip" : "192.168.1.10",
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
            {
               "host": 8080,
               "guest": 80
            }
         ]
      }
   }
}
```

## Scripts

Virtual machine provisioning scripts are located in `scripts`.

## Common Vagrant Commands

More information can be found in the [Vagrant CLI Documentation](https://www.vagrantup.com/docs/cli/).

`vagrant up` builds and starts up the Vagrant image.

`vagrant ssh` logs into the Vagrant/VirtualBox environment.

`vagrant halt` gracefully shuts down the virtual machine.

`vagrant destroy` removes all VirtualBox image files for the environment (i.e. from ~/VirtualBox). Pass in `-f | --force` to bypass the confirmation prompt.

`vagrant box update|list|remove <box>|add <box>` manages box images.

For example, `vagrant box remove geerlingguy/centos7 --all` then inspect `~/.vagrant.d/boxes` to confirm removal

> Original project exported from a personal subversion server into a git repository, and pushed to Github.
