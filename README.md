# Vagrant Sandbox

This is my approach for trying out new frameworks, technologies, etc. without having to actually install and clutter up my personal laptop. Prior, I used an old desktop that I provisioned into my own home server and ended up installing and configuring it with a lot of software and development tools through the years - more than what I can manage! [Vagrant](https://www.vagrantup.com/) allows me to manage a development sandbox that is templated through various scripts that I have developed (and cleaned up) over the years. It allows me to have my own playground that I can throw away and rebuild with no overhead on my personal laptop.

## Quickstart

1. Download and install [Virtual Box](https://www.virtualbox.org/wiki/VirtualBox)
2. Download and install [Vagrant](https://www.vagrantup.com/)
3. Navigate into the cloned repository
4. Execute `vagrant up` to build/start the environment
5. Execute `vagrant ssh` to ssh into the development environment
6. Start playing - any small projects/prototypes goes to the `projects` folder where development/editing typically takes place on my personal laptop that is later built/run on the Vagrant environment with any necessary tools (i.e. npm)
7. Restart with a fresh image environment with `vagrant destroy` then `vagrant up`

## Configurations

1. Vagrant box image provided by [geerlingguy](https://atlas.hashicorp.com/geerlingguy/boxes/centos7)
2. From `Vangrantfile` configuration
  * the VM name `config.vm.define "centos7_h01"`
  * the hostname `virtualname = "h01"`
  * various ports are opened from the host machine that maps to the guest environment - i.e. `config.vm.network "forwarded_port", guest: 8080, host: 8000`
  * the `scripts` folder is mounted at `/opt/scripts` and synched up with the host and guest filesystems
  * `# TODO: This is specific to my machine` that will need to be commented out if you do not have that directory `../projects` (relative to the checkout) on your host machine
  * the provisioning scripts (or templates) are configured last to install the development tools/software/etc.
3. VirtualBox is also manually configured to save VM data files at a particular location on my laptop (i.e. `~/VirtualBox`)
4. Vagrant configurations are stored in `~/.vagrant.d` (i.e. box downloads)
5. Git is configured to ignore everything in the `projects` folder because this is typically where personal projects (usually other Git repositories) are stored

## Common Vagrant Commands

All commands must take place in the directory where `Vagrantfile` exists. This is the root of the virtual development environment. More information can be found in the [Vagrant CLI Documentation](https://www.vagrantup.com/docs/cli/).

`vagrant up` builds and starts up the Vagrant image.

`vagrant ssh` logs into the Vagrant/VirtualBox environment.

`vagrant halt` gracefully shuts down the virtual machine.

`vagrant destroy` removes all VirtualBox image files for the environment (i.e. from ~/VirtualBox). Pass in `-f | --force` to bypass the confirmation prompt.

`vagrant box update|list|remove <box>|add <box>` manages box images.

For example, `vagrant box remove geerlingguy/centos7 --all` then inspect `~/.vagrant.d/boxes` to confirm removal

> Original project exported from a personal subversion server into a git repository, and pushed to Github.
