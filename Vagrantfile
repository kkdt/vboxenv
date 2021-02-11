# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# Copyright 2017 kkdt
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
# Software, and to permit persons to whom the Software is furnished to do so, subject
# to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
# CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
# OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  puts "---------------------------------"
  puts "Vagrant Sandbox"
  puts "---------------------------------"
    puts ""

  config.ssh.forward_x11 = true
  config.ssh.insert_key = false
  config.ssh.keep_alive = true

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
  #config.vm.provision :shell, path: "scripts/install_git.sh"
  #config.vm.provision :shell, path: "scripts/install_java.sh"
  #config.vm.provision :shell, path: "scripts/install_gradle.sh", args: ['3.5']
  #config.vm.provision :shell, path: "scripts/install_aws.sh"
  #config.vm.provision :shell, path: "scripts/install_node.sh"

  Dir.glob('servers/*.json') do |file|
    json = (JSON.parse(File.read(file)))['server']
    id = json.has_key?("id") ? json["id"] : "vagrant"
    network = hostname = json.has_key?("network") ? json["network"] : {}
    hostname = json.has_key?("hostname") ? json["hostname"] : "vagrant"
    memory = json.has_key?("memory") ? json["memory"] : 512
    cpus = json.has_key?("cpus") ? json["cpus"] : 1
    desktop = json.has_key?("desktop") ? json["desktop"] : nil
    gui = !desktop.nil? && desktop.has_key?("display") ? desktop['display'] : false
    desktop_type = !desktop.nil? && desktop.has_key?("type") ? desktop['type'] : "gnome"
    aws = json.has_key?("aws") ? json["aws"] : nil
    hosts = json.has_key?("hosts") ? json["hosts"] : []
    bootstrap = json.has_key?("bootstrap") ? json["bootstrap"] : nil
    files = json.has_key?("files") ? json["files"] : []
    scripts = json.has_key?("scripts") ? json["scripts"] : []

    config.vm.define id do |server|
      server.vm.box = json.has_key?('box') ? json['box'] : "kkdt/c7dev"
      server.vm.hostname = hostname
      server.vm.define id

      server.vm.provider "virtualbox" do |vb|
          vb.gui = gui
          vb.name = id
          vb.memory = memory
          vb.cpus = cpus
      end

      # stage all host files to guest location - i.e. rpms, tars, etc.
      files.each do |f|
        # puts "file: #{f["source"]} -> #{f["destination"]}"
        server.vm.provision "file", source: f["source"], destination: f["destination"]
      end

      # contains a list of possible bridge adapters and the first one to successfully
      # bridged will be used
      bridge = network.has_key?("bridge") ? true : false
      if bridge then
          server.vm.network network['type'], ip: network['ip'], bridge: network['bridge']
      elsif network.has_key?("type") && network.has_key?("ip")
          server.vm.network network['type'], ip: network['ip']
      end

      if network.has_key?("ports") then
          network['ports'].each do |p|
              server.vm.network "forwarded_port", guest: p['guest'], host: p['host']
          end
      end

      hosts.each do |h|
          hostname = h["hostname"]
          ip = h["ip"]
          server.vm.provision "hosts", type: "shell", args: [ hostname, ip ], inline: <<-SHELL
              echo "$2 $1 $1" >> /etc/hosts
          SHELL
      end

      if !aws.nil? then
          accessKey = aws.has_key?('accessKey') ? aws['accessKey'] : ""
          accessSecret = aws.has_key?('accessSecret') ? aws['accessSecret'] : ""
          awsRegion = aws.has_key?('region') ? aws['region'] : ""
          server.vm.provision "aws", type: "shell", path: "scripts/install_aws.sh", env: { "AWS_ACCESS_KEY_ID" => "#{accessKey}", "AWS_SECRET_ACCESS_KEY" => "#{accessSecret}", "AWS_DEFAULT_REGION" => "#{awsRegion}"}
      end

      # server.vm.provision "base-install", run: "never", type: "shell", env: { "VAGRANT_GRADLE_VERSION" => "#{gradleversion}" }, args: [], inline: <<-SHELL
      #     if [ -f "/home/vagrant/jdk.rpm" ]; then
      #         /bin/bash /vagrant/scripts/install_jdk.sh "/home/vagrant/jdk.rpm"
      #         /bin/bash /vagrant/scripts/install_gradle.sh "${VAGRANT_GRADLE_VERSION}"
      #     fi
      # SHELL

      # server.vm.provision "rpms", type: "shell", inline: <<-SHELL
      #     for r in $(ls /tmp/*.rpm 2>/dev/null)
      #     do
      #         echo "Installing ${r}"
      #         rpm -Uvh ${r}
      #         echo "Removing ${r}"
      #         rm -f ${r}
      #     done
      # SHELL

      # execute all configured scripts
      scripts.each do |f|
        # puts "Executing script #{f["file"]} #{f["args"]}"
        server.vm.provision :shell, path: f["file"], args: f["args"]
      end

      if !desktop.nil? && desktop["install"] == true then
          server.vm.provision "desktop", type: "shell", path: "scripts/install_desktop.sh", args: [ "#{desktop_type}" ]
      end
    end
  end

end
