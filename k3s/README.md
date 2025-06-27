**install k3s as master**
```
sudo curl -Lo /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.26.5+k3s1/k3s; sudo chmod a+x /usr/local/bin/k3s
sudo K3S_KUBECONFIG_MODE="644" k3s server
sudo k3s kubectl get node
```

**install k3s as worker**
```
sudo curl -Lo /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.26.5+k3s1/k3s; sudo chmod a+x /usr/local/bin/k3s
# NODE_TOKEN comes from /var/lib/rancher/k3s/server/node-token on your server
sudo k3s agent --server https://k3s.example.com --token ${NODE_TOKEN}
```

**Install kubectl**
```
sudo apt install kubectl          # Ubuntu/Debian
```

**Access to Kubernetes cluster from local machine**
for Yandex Cloud:
- ssh -J bastion k8s-master 'sudo cat /etc/rancher/k3s/k3s.yaml' > ~/.kube/config_yc
- in ~/.kube/config-aws set server: https://127.0.0.1:6443     
- ssh -N -L 6443:<MASTER_PRIVATE_IP>:6443 ubuntu@<BASTION_IP>  # set ssh tunnel
- KUBECONFIG=~/.kube/config_yc kubectl get nodes

for AWS:
- ssh -J ec2-user@<BASTION_IP> ubuntu@<MASTER_PRIVATE_IP> 'sudo cat /etc/rancher/k3s/k3s.yaml > ~/.kube/config_aws
- in ~/.kube/config-aws set server: https://127.0.0.1:6443
- ssh -i key.pem -L 6443:10.0.1.10:6443 ec2-user@<BASTION_IP>  # set ssh tunnel
- KUBECONFIG=~/.kube/config_aws kubectl get nodes


**Deploy pod with nginx app**
```
kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml
```
**or Nginx + Services:**
nginx-pod.yaml 
```
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```

nginx-service.yaml
```
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80        
    targetPort: 80  
    nodePort: 30080
```

**Usefull commands**
```
sudo k3s kubectl get pods -A
sudo k3s kubectl get nodes
sudo systemctl stop k3s
/usr/local/bin/k3s-uninstall.sh
```