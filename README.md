# Vagrant Sandbox

This is my approach for trying out new frameworks, technologies, etc. without having to actually install and clutter up my personal laptop. Prior, I used an old desktop that I provisioned into my own home server and ended up installing and configuring it with a lot of software and development tools through the years - more than what I can manage! [Vagrant](https://www.vagrantup.com/) allows me to manage a development sandbox that is templated through various scripts that I have developed (and cleaned up) over the years. It allows me to have my own playground that I can throw away and rebuild with no overhead on my personal laptop.

## Quickstart

1. Download and install [Virtual Box](https://www.virtualbox.org/wiki/VirtualBox)
2. Download and install [Vagrant](https://www.vagrantup.com/)
3. Set `PROJECTSHOME` environment variable to an external folder that contains all projects you want synchronized with the guest machine at `/opt/projects` - i.e. Eclipse workspace. Note: The entire directory that contains the `Vagrantfile` will be synchronized at `/vagrant` in the guest machine.
4. Clone and navigate into the repository
5. Execute `vagrant up` to build/start the environment
6. Execute `vagrant ssh` to ssh into the development environment
7. Restart with a fresh image environment with `vagrant destroy` then `vagrant up`

## Configurations

1. Vagrant box image provided by [geerlingguy](https://atlas.hashicorp.com/geerlingguy/boxes/centos7)
2. From `Vangrantfile` configuration
  * the VM name `config.vm.define "centos7_h01"`
  * the hostname `virtualname = "h01"`
  * various ports are opened from the host machine that maps to the guest environment - i.e. `config.vm.network "forwarded_port", guest: 8080, host: 8000`
  * `export PROJECTSHOME=/another/path` will be mounted in `/opt/projects`
3. VirtualBox is also manually configured to save VM data files at a particular location on my laptop (i.e. `~/VirtualBox`)
4. Vagrant configurations are stored in `~/.vagrant.d` (i.e. box downloads)

## Scripts

`bootstrap.sh [hostname]`
  This script installs the base packages from yum and renames the guest machine hostname. If no arguments is passed into this script, then the default `centos7b` will the guest hostname.

`install_aws.sh [url]`
   This script installs the aws bundle. If no argument is passed into this script, then the default [latest](https://s3.amazonaws.com/aws-cli/awscli-bundle.zip) will be used. The argument must be a value URL.

`install_git.sh`
  This script installs `git` via the yum repository.

`install_gradle.sh [version]`
  This script will install the specified Gradle version. If no version is passed into the script, then the default `3.5` will be used.

 `install_java.sh [url]`
   This script will install the specified JDK download URL. If no URL is passed into this script, then the [default](http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz) will be used.

`install_node.sh`
   This script installs `nodejs`, `npm`, and `angular`.

`install_rvm.sh [version]`
  This script installs the specified RVM version. If no version is passed into the script, then the default `1.29.3` will be used. This is not configured to run with Vagrant install Source [Using RVM with Vagrant](https://rvm.io/integration/vagrant)

`install_ruby.sh [version]`
  This script installs the specified Ruby version via RVM - `install_rvm.sh` must be run prior to this script. If no version is passed into the script, then the default `2.5.0` will be used. Source [Using RVM with Vagrant](https://rvm.io/integration/vagrant)

## Common Vagrant Commands

All commands must take place in the directory where `Vagrantfile` exists. This is the root of the virtual development environment. More information can be found in the [Vagrant CLI Documentation](https://www.vagrantup.com/docs/cli/).

`vagrant up` builds and starts up the Vagrant image.

`vagrant ssh` logs into the Vagrant/VirtualBox environment.

`vagrant halt` gracefully shuts down the virtual machine.

`vagrant destroy` removes all VirtualBox image files for the environment (i.e. from ~/VirtualBox). Pass in `-f | --force` to bypass the confirmation prompt.

`vagrant box update|list|remove <box>|add <box>` manages box images.

For example, `vagrant box remove geerlingguy/centos7 --all` then inspect `~/.vagrant.d/boxes` to confirm removal

> Original project exported from a personal subversion server into a git repository, and pushed to Github.
