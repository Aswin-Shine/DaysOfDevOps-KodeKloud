An application currently running on the Kubernetes cluster employs the nginx web server. The Nautilus application development team has introduced some recent changes that need deployment. They've crafted an image nginx:1.19 with the latest updates.

Execute a rolling update for this application, integrating the nginx:1.19 image. The deployment is named nginx-deployment.

Solution :

1. Check pods are running or not

```
kubectl get pods
```

2. Edit deployment file

```
kubectl edit deployment nginx-deployment
```

3. Edit deployment file

```
kubectl edit deployment nginx-deployment

*Change Container Image to -- nginx:1.19*
```

4. Check the rollout status

```
kubectl rollout status deployment/nginx-deployment
kubectl get pods
```
