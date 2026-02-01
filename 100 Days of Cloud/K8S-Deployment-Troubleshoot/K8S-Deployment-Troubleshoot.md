Last week, the Nautilus DevOps team deployed a redis app on Kubernetes cluster, which was working fine so far. This morning one of the team members was making some changes in this existing setup, but he made some mistakes and the app went down. We need to fix this as soon as possible. Please take a look.

The deployment name is redis-deployment. The pods are not in running state right now, so please look into the issue and fix the same.

Solution :

1. Check the namespaces and pods

```
kubectl get namespaces
kubectl get pods
```

2. Check Configmap

```
kubectl get configmaps
```

3. Check logs and deployment of pod

```
kubectl logs <pod name>
kubectl describe deploy
```

In my cases there were typos in deployment file aplin ---> apline & cofig ----> config

4. Edit the deploymeny file

```
kubectl edit deploy
```

5. Check pods are running or not

```
kubectl get pods
```
