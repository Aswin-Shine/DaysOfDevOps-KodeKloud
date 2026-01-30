The Nautilus DevOps teams is planning to set up a Grafana tool to collect and analyze analytics from some applications. They are planning to deploy it on Kubernetes cluster. Below you can find more details.

1. Create a deployment named grafana-deployment-nautilus using any grafana image for Grafana app. Set other parameters as per your choice.

2. Create NodePort type service with nodePort 32000 to expose the app.

Solution :

1. Check namespaces and pods running

```
kubectl get namespaces
kubectl get pods
```

2. Create Grafana deployment yaml file

```
vi grafana-deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana-deployment-nautilus
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grafana
  template:
    metadata:
      name: grafana
      labels:
        app: grafana
    spec:
      containers:
      - name: grafana
        image: grafana/grafana:latest
        ports:
        - name: grafana
          containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: grafana
spec:
  selector:
    app: grafana
  type: NodePort
  ports:
    - port: 3000
      targetPort: 3000
      nodePort: 32000
```

3. Check pod is created and running

```
kubectl get pods
```
