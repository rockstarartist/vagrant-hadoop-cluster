# Virtualized Hadoop Cluster using Hortonworks HDP 2.5

This git project sets up a 3+ node cluster using Vagrant and a bash shell script to
provision the VM's (Virtual Box is the VM Provider). Hortonworks Ambari is used
to provision the Hadoop services (using Ambari.)

The intent of this project is to setup a base Hadoop stack, using Spark2 and Kafka
for the study, testing, and researching the use of streaming only big data
architecture. The end result is a VM box ready to be used with other vagrant
setups that deploy other technology on top of this technology stack.

## Requirements

* MacOSX 10.10.5 +  (This may work on linux too, it just has not been tested)
* Vagrant 1.8.6 +
* VirtualBox 5.0.4 +

## Installation

#### 1.) Install VirtualBox
Download the latest version of VirtualBox and utilize their instructions on the
installation of their software:
```
https://www.virtualbox.org/
```
#### 2.) Install Vagrant
Download latest version of vagrant from the following site:
```
https://www.vagrantup.com/downloads.html
```
Utilize the Vagrant installer to install Vagrant.

#### 3.) Install this project
Checkout this project into a directory and run the following command in the directory:
vagrant up

This will then build the VM's in a clustered environment locally. This should take approximately
30+ minutes as it is installing the Hadoop services through the internet.

## Advanced Installation

#### Behind a Proxy wall
If you are behind a firewall you will need to open the vagrant file and modify the following
variables for your situation:
```
WITH_PROXY = "true"
PROXY_ADDRESS = "your.proxy.address.here.com"
PROXY_PORT = "80"
NAME_SERVERS = ["your.dns.nameserver.1.com", "your.dns.nameserver.2.com", "your.dns.nameserver.3.com"]
```
#### More than 2 data nodes
If you want more than 2 data nodes, alter the following value in the vagrant file:
```
NUMBER_OF_DATANODES = 2
```
