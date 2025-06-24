**install k3s**
```
sudo curl -Lo /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.26.5+k3s1/k3s; sudo chmod a+x /usr/local/bin/k3s
sudo K3S_KUBECONFIG_MODE="644" k3s server
sudo k3s kubectl get node
```

**k3s worker connect to master**
```
# NODE_TOKEN comes from /var/lib/rancher/k3s/server/node-token on your server
sudo k3s agent --server https://k3s.example.com --token ${NODE_TOKEN}
```

**kubeconfig**
cp /etc/rancher/k3s/k3s.yaml to 
set server: https://<master-ip>:6443
export KUBECONFIG=~/k3s.yaml
kubectl get nodes