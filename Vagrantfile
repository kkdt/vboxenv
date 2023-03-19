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

  puts "---------------------------------"
  puts "Development Sandbox"
  if Vagrant::Util::Platform.windows?
    puts "Windows"
  elsif Vagrant::Util::Platform.linux?
    puts "Linux"
  elsif Vagrant::Util::Platform.darwin?
    puts "Mac/Darwin"
  end
  puts "VirtualBox #{vboxversion}"
  puts "---------------------------------"
  puts ""

  Dir.glob('servers/local/*.json') do |file|
    json = (JSON.parse(File.read(file)))['server']
    box = json["box"]
    id = json.has_key?("id") ? json["id"] : "vagrant"
    hostname = json.has_key?("hostname") ? json["hostname"] : nil
    memory = json["memory"]
    cpus = json["cpus"]
    gui = json["gui"]
    vram = json.has_key?("vram") ? json["vram"] : nil
    acceleration = json.has_key?("acceleration") ? json["acceleration"] : nil
    update_vbguest = json.has_key?("update_vbguest") ? json["update_vbguest"] : false

    config.vm.define id do |server|
      server.vm.box = box
      if !hostname.nil? then
        server.vm.hostname = hostname
      end
      server.vm.define id

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
    end
  end

  # Shared drive with host/guest
  if Vagrant::Util::Platform.windows?
    config.vm.synced_folder ENV['USERPROFILE'], "/shared", :mount_options => ["rw"]
  else
    config.vm.synced_folder ENV['HOME'], "/shared", :mount_options => ["rw"]
  end


end
