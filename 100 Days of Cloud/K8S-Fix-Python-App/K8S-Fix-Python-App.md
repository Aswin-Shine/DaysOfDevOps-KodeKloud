One of the DevOps engineers was trying to deploy a python app on Kubernetes cluster.
Unfortunately, due to some mis-configuration, the application is not coming up. Please take a look into it and fix the issues. Application should be accessible on the specified nodePort.

The deployment name is python-deployment-xfusion, its using poroko/flask-demo-app image. The deployment and service of this app is already deployed. NodePort should be 32345 and targetPort should be python flask app's default port.

Solution :

1. Check the pods and svc running.

```
kubectl get pods
kubectl get svc
```

2. Edit the deployment file.

```
kubectl edit deployment python-deployment-xfusion

* Change image name to poroko/flask-demo-app *
```

3. Edit the service file.

```
kubectl get svc python-service-xfusion

* Change targetPort number to 5000 *

```

4. Check the pods & svc are running or not.

```
kubectl get pods
kubectl get svc
```
