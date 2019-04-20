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
        id = json['id']
        hostname = json['hostname']
        network = json['network']
        memory = json['memory']
        cpus = json['cpus']
        
        desktop = json.has_key?("desktop") ? json["desktop"] : nil
        gui = !desktop.nil? && desktop.has_key?("display") ? desktop['display'] : false
        desktop_type = !desktop.nil? && desktop.has_key?("type") ? desktop['type'] : "gnome"
        aws = json.has_key?("aws") ? json["aws"] : nil
        jdk = json.has_key?("jdk") ? json["jdk"] : ""
        gradleversion = json.has_key?("gradleversion") ? json["gradleversion"] : "4.0"

        config.vm.define id do |server|
            server.vm.box = json.has_key?('box') ? json['box'] : "geerlingguy/centos7"
            server.vm.hostname = hostname
            server.vm.define id

            server.vm.provider "virtualbox" do |vb|
                vb.gui = gui
                vb.name = id
                vb.memory = memory
                vb.cpus = cpus
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

            # stage the jdk file to /home/vagrant/jdk.rpm
            unless jdk.empty?
                server.vm.provision "file", source: "#{jdk}", destination: "jdk.rpm"
            end

            if !aws.nil? then
                accessKey = aws.has_key?('accessKey') ? aws['accessKey'] : ""
                accessSecret = aws.has_key?('accessSecret') ? aws['accessSecret'] : ""
                awsRegion = aws.has_key?('region') ? aws['region'] : ""
                server.vm.provision "aws", type: "shell", path: "scripts/install_aws.sh", env: { "AWS_ACCESS_KEY_ID" => "#{accessKey}", "AWS_SECRET_ACCESS_KEY" => "#{accessSecret}", "AWS_DEFAULT_REGION" => "#{awsRegion}"}
            end

            server.vm.provision "base-install", run: "never", type: "shell", env: { "VAGRANT_GRADLE_VERSION" => "#{gradleversion}" }, args: [], inline: <<-SHELL
                /bin/bash /vagrant/scripts/bootstrap.sh
                /bin/bash /vagrant/scripts/install_git.sh
                if [ -f "/home/vagrant/jdk.rpm" ]; then
                    /bin/bash /vagrant/scripts/install_jdk.sh "/home/vagrant/jdk.rpm"
                    /bin/bash /vagrant/scripts/install_gradle.sh "${VAGRANT_GRADLE_VERSION}"
                fi
                /bin/bash /vagrant/scripts/install_node.sh
                /bin/bash /vagrant/scripts/install_yarn.sh
            SHELL

            if !desktop.nil? && desktop["install"] == true then
                server.vm.provision "desktop", type: "shell", path: "scripts/install_desktop.sh", args: [ "#{desktop_type}" ]
            end
        end

    end

end
