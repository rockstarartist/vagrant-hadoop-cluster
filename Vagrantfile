# -*- mode: ruby -*-
# vi: set ft=ruby :


  #Enables proxies in the provisioning shell scripts
  WITH_PROXY = "false"
  PROXY_ADDRESS = ""
  PROXY_PORT = ""
  NAME_SERVERS = [""]

  NUMBER_OF_DATANODES = 2

  #This variable's value gets altered by the .bashrc file creator below
  #Be careful modify
  NO_PROXY_VALUES = "export no_proxy='.vm, 127.0.0.1, 192.168.70.1"

  #Create our hosts file
  open('hosts', 'w') do |f|
    f.puts "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4"
    f.puts "::1         localhost localhost.localdomain localhost6 localhost6.localdomain6"
    f.puts "192.168.70.1 masternode.vm masternode"
    (1..NUMBER_OF_DATANODES).each do |i|
      f.puts "192.168.70.#{i+1} slave#{i}.vm slave#{i}"
    end
  end

  #Create our resolv.conf file
  open('resolv.conf', 'w') do |f|
    if WITH_PROXY == "true"
      NAME_SERVERS.each { |x| f.puts "nameserver #{x}"}
    else
      f.puts "search ambari.apache.org"
      f.puts "nameserver 8.8.8.8"
    end
  end

  #Create our .bashrc file
  open('bashrc', 'w') do |f|
    f.puts "# Source global definitions"
    f.puts "if [ -f /etc/bashrc ]; then"
    f.puts "	. /etc/bashrc"
    f.puts "fi"
    if WITH_PROXY == "true"
      f.puts "export HTTP_PROXY='#{PROXY_ADDRESS}:#{PROXY_PORT}'"
      f.puts "export HTTPS_PROXY='#{PROXY_ADDRESS}:#{PROXY_PORT}'"
      f.puts "export http_proxy='#{PROXY_ADDRESS}:#{PROXY_PORT}'"
      f.puts "export https_proxy='#{PROXY_ADDRESS}:#{PROXY_PORT}'"
      noproxyvar = "export no_proxy='.vm, 127.0.0.1, 192.168.70.1"
      #Create the no_proxy export
      (1..NUMBER_OF_DATANODES).each { |x| noproxyvar << ", 192.168.70.#{x+1}"}
      f.puts noproxyvar << "'"
    end
  end

  Vagrant.configure("2") do |config|

    #Configure DNS for all the machines (Landrush setsup a private network with DHCP & DNS)
    config.landrush.enabled = false
    config.landrush.tld = ".vm"

    #Setup our masternode
    config.vm.define "master" do |master|
      master.vm.box = "centos/7"

      master.vm.provider "virtualbox" do |v|
        v.memory = 4096
      end

      master.vm.hostname = "masternode.vm"
      master.vm.network :private_network, ip: "192.168.70.1"

      #port forward Ambari to our localhost
      master.vm.network :forwarded_port, guest:8080, host: 8080

      #Provision our Masternode with its Hadoop services
      master.vm.provision :shell, path: "master-bootstrap.sh", :args => "#{WITH_PROXY} #{PROXY_ADDRESS} #{PROXY_PORT}"
    end

    #Setup our datanodes
    (1..NUMBER_OF_DATANODES).each do |i|
      config.vm.define "slave#{i}" do |slave|
        slave.vm.box = "centos/7"
        slave.vm.hostname = "slave#{i}.vm"
        slave.vm.network :private_network, ip: "192.168.70.#{i+1}"

        slave.vm.provider "virtualbox" do |v|
          v.memory = 2048
        end

        #run our bootstrap.sh file to get Hadoop Installed
        slave.vm.provision :shell, path: "slave-bootstrap.sh", :args => "#{WITH_PROXY} #{PROXY_ADDRESS} #{PROXY_PORT}"
      end
    end

  end
