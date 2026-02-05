The Nautilus DevOps team is working to deploy some tools in Kubernetes cluster. Some of the tools are licence based so that licence information needs to be stored securely within Kubernetes cluster. Therefore, the team wants to utilize Kubernetes secrets to store those secrets. Below you can find more details about the requirements:

We already have a secret key file beta.txt under /opt location on jump host. Create a generic secret named beta, it should contain the password/license-number present in beta.txt file.

Also create a pod named secret-datacenter.

Configure pod's spec as container name should be secret-container-datacenter, image should be ubuntu with latest tag (remember to mention the tag with image). Use sleep command for container so that it remains in running state. Consume the created secret and mount it under /opt/apps within the container.

To verify you can exec into the container secret-container-datacenter, to check the secret key under the mounted path /opt/apps. Before hitting the Check button please make sure pod/pods are in running state, also validation can take some time to complete so keep patience.

Solution :

1. Check the namespaces and pods running

```
kubectl get namesapces
kubectl get pods
```

2. Create secret file

```
kubectl create secret generic beta \
--from-file=/opt/beta.txt
```

3. Create pod.yaml file

```
vi pod.yaml

apiVersion: v1
kind: Pod
metadata:
  name: secret-datacenter
spec:
  containers:
    - name: secret-container-datacenter
      image: ubuntu:latest
      command: [ "/bin/bash", "-c", "--", "while true; do sleep 30; done;"]
      volumeMounts:
      - name: secret
        mountPath: /opt/apps
  volumes:
  - name: secret
    secret:
      secretName: beta

```

4. Check pod is running

```
kubectl get pods
```

5. Get into the pod and search for the secret file

```
kubectl exec -it secret-datacenter -- bin/bash
cat /opt/apps/beta.txt
```
