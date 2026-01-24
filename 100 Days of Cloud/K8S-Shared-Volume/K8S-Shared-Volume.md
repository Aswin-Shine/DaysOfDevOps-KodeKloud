We are working on an application that will be deployed on multiple containers within a pod on Kubernetes cluster. There is a requirement to share a volume among the containers to save some temporary data. The Nautilus DevOps team is developing a similar template to replicate the scenario. Below you can find more details about it.

Create a pod named volume-share-devops.

For the first container, use image fedora with latest tag only and remember to mention the tag i.e fedora:latest, container should be named as volume-container-devops-1, and run a sleep command for it so that it remains in running state. Volume volume-share should be mounted at path /tmp/media.

For the second container, use image fedora with the latest tag only and remember to mention the tag i.e fedora:latest, container should be named as volume-container-devops-2, and again run a sleep command for it so that it remains in running state. Volume volume-share should be mounted at path /tmp/cluster.

Volume name should be volume-share of type emptyDir.

After creating the pod, exec into the first container i.e volume-container-devops-1, and just for testing create a file media.txt with any content under the mounted path of first container i.e /tmp/media.

The file media.txt should be present under the mounted path /tmp/cluster on the second container volume-container-devops-2 as well, since they are using a shared volume.

Solution :

1. Check all running pods and namepsaces available

```
kubectl get pods
kubectl get namespaces
```

2. Create a pod.yaml file

```
vi pod.yaml

apiVersion: v1
kind: Pod
metadata:
  name: volume-share-devops
spec:
  volumes:
    - name: volume-share
      emptyDir: {}

  containers:
    - name: volume-container-devops-1
      image: fedora:latest
      command: ["/bin/bash", "-c", "sleep 10000"]
      volumeMounts:
        - name: volume-share
          mountPath: /tmp/media

    - name: volume-container-devops-2
      image: fedora:latest
      command: ["/bin/bash", "-c", "sleep 10000"]
      volumeMounts:
        - name: volume-share
          mountPath: /tmp/cluster
```

3. Apply/Run this pod.yaml

```
kubectl apply -f pod.yaml
```

4. Check pods are running

```
kubectl get pods
```

5. Execute container 1 and create a text file

```
kubectl exec -i -t volume-share-devops --container volume-container-devops-1 -- /bin/bash
cd /tmp/media
vi media.txt
Welcome to xFusionCorp Industries!
```

6. Execute container 2 and check file present or not

```
kubectl exec -i -t volume-share-devops --container volume-container-devops-1 -- /bin/bash
cd /tmp/media
ls
```
