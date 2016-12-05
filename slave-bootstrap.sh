#!/usr/bin/env bash

#If we get a true with the first parameter, then engage proxies, otherwise
if [ "$1" = "true" ]; then

  #Export our proxies to the terminal
  export HTTP_PROXY="$2:$3"
  export HTTPS_PROXY="$2:$3"
  export http_proxy="$2:$3"
  export https_proxy="$2:$3"
  export no_proxy=".vm, 127.0.0.1, 192.168.70.100, 192.168.70.101, 192.168.70.102"

  #update the vm's bashrc file with our proxy changes
  cp /vagrant/bashrc /home/vagrant/.bashrc

  #Append the proxy info to the yum file
  sed -i -e "\$aproxy=http://$2:$3" /etc/yum.conf

  #update the DNS upstream in the resolve.conf file
  cp /vagrant/resolv.conf /etc/resolv.conf

  #Copy our hosts file into the vm
  cp /vagrant/hosts /etc/hosts

else
  #Setup Local Networking
  cp /vagrant/hosts /etc/hosts
  cp /vagrant/resolv.conf /etc/resolv.conf
fi

#Update Yum
yum update

#Install NTPD -- Needed by Hadoop
yum install ntp -y
service ntpd start

#Install Java 8
yum -y install java-1.8.0-openjdk-devel

#Install wget
yum -y install wget

#Get the Ambari Repo for Centos7
wget -nv http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.4.0.1/ambari.repo -O /etc/yum.repos.d/ambari.repo
wget -nv http://public-repo-1.hortonworks.com/HDP/centos7/2.x/updates/2.5.0.0/hdp.repo -O /etc/yum.repos.d/hdp.repo

#Install the Agent
yum -y install ambari-agent
sed -i "s/hostname=localhost/hostname=masternode.vm/g" /etc/ambari-agent/conf/ambari-agent.ini
ambari-agent start
