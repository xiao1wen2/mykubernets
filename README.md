# mykubernets
- cfsssl官方地址：https://pkg.cfssl.org/
- wget https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 && mv cfssl_linux-amd64 /usr/local/bin/cfssl
- wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-amd64 && mv cfssl-certinfo_linux-amd64 /usr/local/bin/cfssl-certinfo
- wget https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64 && mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
- chmod +x /usr/local/bin/cfssl*

# 创建集群访问用户

- /opt/k8s/work/mykubernets/TLS-cert/k8s/admin-csr.json
- cfssl gencert -ca=/opt/k8s/work/mykubernets/TLS-cert/k8s/ca.pem -ca-key=/opt/k8s/work/mykubernets/TLS-cert/k8s/ca-key.pem -config=ca-config.json -profile=kubernetes admin-csr.json | cfssljson -bare admin
- kubectl config set-cluster kuberntest --certificate-authority=/etc/kubernetes/cert/ca.pem --embed-certs=true --server=https://192.168.221.158:6443 --kubeconfig=admin.kubeconfig
- kubectl config set-credentials admin --client-certificate=admin.pem --client-key=admin-key.pem --embed-certs=true --kubeconfig=admin.kubeconfig 
- kubectl config set-context kubernetes --cluster=kubernetes --user=admin --kubeconfig=admin.kubeconfig 
- kubectl config use-context kubernetes --kubeconfig=admin.kubeconfig 
