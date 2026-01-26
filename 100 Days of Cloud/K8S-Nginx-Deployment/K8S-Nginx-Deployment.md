Some of the Nautilus team developers are developing a static website and they want to deploy it on Kubernetes cluster. They want it to be highly available and scalable. Therefore, based on the requirements, the DevOps team has decided to create a deployment for it with multiple replicas. Below you can find more details about it:

Create a deployment using nginx image with latest tag only and remember to mention the tag i.e nginx:latest. Name it as nginx-deployment. The container should be named as nginx-container, also make sure replica counts are 3.

Create a NodePort type service named nginx-service. The nodePort should be 30011.

Solution :

1. Check get pods and namespaces

```
kubectl get namespaces
kubectl get pods
```

2. Create nginx-dev.yaml

```
vi nginx.dev.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-app
  template:
    metadata:
      labels:
        app: nginx-app
    spec:
      containers:
      - name: nginx-container
        image: nginx:latest

---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
  labels:
     app: nginx-app
     type: front-end
spec:
  type: NodePort
  selector:
     app: nginx-app
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30011
```

3. Check pods have created or not

```
kubectl get pods
```
