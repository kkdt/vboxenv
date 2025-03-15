# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# Copyright 2021 kkdt
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
  vboxversion = VagrantPlugins::ProviderVirtualBox::Driver::Meta.new.version
  vboxenvs = 'servers/local/*json'

  puts "---------------------------------"
  if Vagrant::Util::Platform.windows?
    puts "INFO: Windows host"
  elsif Vagrant::Util::Platform.linux?
    puts "INFO: Linux host"
  elsif Vagrant::Util::Platform.darwin?
    puts "INFO: Mac/Darwin host"
  end
  puts "INFO: VirtualBox #{vboxversion}"

  if ENV["VBOXENV_HOME"] != nil && ENV["VBOXENV_HOME"] != ""
    puts "INFO: VBOXENV_HOME is set to #{ENV['VBOXENV_HOME']} (on host) for JSON configurations"
    vboxenvs = ENV["VBOXENV_HOME"] + "/*.json"
  end
  
  puts "---------------------------------"

  if Dir[vboxenvs].length == 0
    raise "ERROR: Cannot locate any VirtualBox JSON configuration .json files in the #{vboxenvs} directory"
  end

  puts ""
  Dir.glob([vboxenvs]) do |file|
    json = (JSON.parse(File.read(file)))
    box = json["box"]
    box_version = json.has_key?("box_version") ? json["box_version"] : nil
    id = json.has_key?("id") ? json["id"] : "vagrant"
    hostname = json.has_key?("hostname") ? json["hostname"] : nil
    memory = json["memory"]
    cpus = json["cpus"]
    gui = json["gui"]
    vram = json.has_key?("vram") ? json["vram"] : nil
    acceleration = json.has_key?("acceleration") ? json["acceleration"] : nil
    update_vbguest = json.has_key?("update_vbguest") ? json["update_vbguest"] : false
    forward_x11 = json.has_key?("forward_x11") ? json["forward_x11"] : false
    boot_timeout = json.has_key?("boot_timeout") ? json["boot_timeout"] : 180

    config.vm.define id do |server|
      server.vm.define id
      server.vm.box = box

      if !box_version.nil? then
        server.vm.box_version = box_version
      end

      if !hostname.nil? then
        server.vm.hostname = hostname
      end

      if forward_x11 then
        server.ssh.forward_agent = true
        server.ssh.forward_x11 = true
      end

      # VirtualBox settings
      server.vm.provider "virtualbox" do |vb|
        vb.gui = gui
        vb.name = id
        vb.memory = memory
        vb.cpus = cpus

        if !vram.nil? then
          vb.customize ["modifyvm", id, "--vram", vram]
        end

        if !acceleration.nil? then
          vb.customize ["modifyvm", id, "--paravirtprovider", acceleration]
        end
      end

      # guest additions
      if Vagrant.has_plugin?("vagrant-vbguest")
        server.vbguest.auto_update = update_vbguest
      end

      # files
      files = json.has_key?("files") ? json["files"] : []
      files.each do |f|
        # puts "file: #{f["source"]} -> #{f["destination"]}"
        server.vm.provision "file", source: f["source"], destination: f["destination"]
      end

      # network
      network = json.has_key?("network") ? json["network"] : []
      network.each do |net|
        type = net['type']
        case type
        when "forwarded_port"
          host = net["host"]
          guest = net["guest"]
          if net.has_key?("id") then
            server.vm.network "forwarded_port", guest: guest, host: host, id: net["id"]
          else
            server.vm.network "forwarded_port", guest: guest, host: host
          end
        when "private_network"
          if net.has_key?("ip") then
            server.vm.network "private_network", ip: net["ip"]
          else
            server.vm.network "private_network", type: "dhcp"
          end
        end
      end

      # scripts
      scripts = json.has_key?("scripts") ? json["scripts"] : []
      scripts.each do |item|
        server.vm.provision :shell,
          run: item['run'],
          name: item['name'],
          path: item["file"],
          args: item["args"],
          upload_path: item['upload_path']
      end

      # shared folders
      shared_folders = json.has_key?("shared_folders") ? json["shared_folders"] : []
      shared_folders.each do |item|
        server.vm.synced_folder item["host"], item["guest"], :mount_options => item["options"]
      end
    end
  end

end
