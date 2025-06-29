**install k3s as master**
```
sudo curl -Lo /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.26.5+k3s1/k3s; sudo chmod a+x /usr/local/bin/k3s
sudo k3s server &
sudo k3s kubectl get node
```

**install k3s as worker**
```
sudo curl -Lo /usr/local/bin/k3s https://github.com/k3s-io/k3s/releases/download/v1.26.5+k3s1/k3s; sudo chmod a+x /usr/local/bin/k3s
# NODE_TOKEN comes from /var/lib/rancher/k3s/server/token on your server
sudo k3s agent \
  --server https://<MASTER_IP>:6443 \
  --token <NODE_TOKEN> &
```

**Install kubectl**
```
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```

**Access to Kubernetes cluster from bastion**
- mkdir ~/.kube
- ssh <ip_k8s-master> 'sudo cat /etc/rancher/k3s/k3s.yaml' > ~/.kube/config
- ssh ssh -fN -L 6443:<ip_k8s-master>:6443 username_k8s-master@ip_k8s-master    # set ssh tunnel
- kubectl get nodes

**Access to Kubernetes cluster from local machine**
- ssh -i yacloud_k8s -J k3s@158.160.35.0 k3s@10.0.11.12 'sudo cat /etc/rancher/k3s/k3s.yaml' > ~/.kube/config_k3s
- ssh -fN -L 6443:127.0.0.1:6443 -J k3s@158.160.35.0 k3s@10.0.11.12   # set ssh tunnel
- KUBECONFIG=~/.kube/config_k3s kubectl get nodes

**Deploy pod with Nginx app**
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
sudo k3s kubectl get nodes
sudo k3s kubectl get pods -A
sudo systemctl stop k3s
/usr/local/bin/k3s-uninstall.sh
```

**Result**

![k3s](k3s_nginx.png)
