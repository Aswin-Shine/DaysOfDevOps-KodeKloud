The Nautilus DevOps team is diving into Kubernetes for application management. One team member has a task to create a pod according to the details below:

1. Create a pod named pod-httpd using the httpd image with the latest tag. Ensure to specify the tag as httpd:latest.

2. Set the app label to httpd_app, and name the container as httpd-container.

Solution :

1. Check namespaces and pods running 
```
kubectl get namespaces
kubect get pods
```

2. Create a temporary directory and create pod.yaml
```
cd /tmp
vi pod.yaml

apiVersion: v1
kind: Pod
metadata:
  name: pod-httpd 
  labels:
    app: httpd_app

spec:
  containers:
  - name: httpd-container 
    image: httpd:latest
```
3. Verfiy Pod is running 
```
kubect get pods
```

