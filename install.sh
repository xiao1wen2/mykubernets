#!/bin/bash

yum -y install vim bash-completion net-tools expect git etcd wget
iptables -F && iptables -X
sed -i "s@SELINUX=enforcing@SELINUX=disabled@g" /etc/selinux/config
sed -i "s@BOOTPROTO=dhcp@BOOTPROTO=none@g" /etc/sysconfig/network-scripts/ifcfg-ens33



cat >> /etc/hosts << EOF
192.168.221.155 k8s-master etcd-1
192.168.221.156 k8s-node1 etcd-2
192.168.221.157 k8s-node2 etcd-3
EOF

read -p "请输入节点名[k8s-master|k8s-node1|k8s-node2]: " node
if [ "${node}" == "k8s-node1" ]
then
  yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine -y
  yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
  
  yum-config-manager \
    --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -y

  yum install docker-ce docker-ce-cli containerd.io -y

cat >> /etc/sysconfig/network-scripts/ifcfg-ens33 << EOF
IPADDR=192.168.221.156 
NETMASK=255.255.255.0 
GATEWAY=192.168.221.2 
DNS1=192.168.221.2
EOF

systemctl stop NetworkManager && systemctl disable NetworkManager

elif [ "${node}" == "k8s-node2" ]
then
  yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine -y
  yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
  
  yum-config-manager \
    --add-repo \
    http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo -y

  yum install docker-ce docker-ce-cli containerd.io -y

cat >> /etc/sysconfig/network-scripts/ifcfg-ens33 << EOF
IPADDR=192.168.221.157 
NETMASK=255.255.255.0 
GATEWAY=192.168.221.2 
DNS1=192.168.221.2
EOF

systemctl stop NetworkManager && systemctl disable NetworkManager

elif [ "${node}" == "k8s-master" ]
then
  wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && mv cfssl_linux-amd64 /usr/local/bin/cfssl
  wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 && mv cfssl-certinfo_linux-amd64 /usr/local/bin/cfssl-certinfo
  wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
  chmod +x /usr/local/bin/cfssl*

cat >> /etc/sysconfig/network-scripts/ifcfg-ens33 << EOF
IPADDR=192.168.221.155 
NETMASK=255.255.255.0 
GATEWAY=192.168.221.2 
DNS1=192.168.221.2
EOF

systemctl stop NetworkManager && systemctl disable NetworkManager

else
  echo "请输入maste or node name"
fi

sleep 3 
reboot
