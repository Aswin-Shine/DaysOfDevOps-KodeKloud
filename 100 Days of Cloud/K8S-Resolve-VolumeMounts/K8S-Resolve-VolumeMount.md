We encountered an issue with our Nginx and PHP-FPM setup on the Kubernetes cluster this morning, which halted its functionality. Investigate and rectify the issue:


The pod name is nginx-phpfpm and configmap name is nginx-config. Identify and fix the problem.


Once resolved, copy /home/thor/index.php file from the jump host to the nginx-container within the nginx document root. After this, you should be able to access the website using Website button on the top bar.

Solution : 

1. Check Running Pods 
```
kubectl get pods 
```

2. Check shared volume in existing config map  
```
kubectl get configmap
kubectl describe configmap nginx-config
```

3. Get the configuration in the YAML file from the running pod 
```
kubectl get pod nginx-phpfpm -o yaml  > /tmp/nginx.yaml
ls /tmp/ 
cat /tmp/nginx.yaml
```

4. Change VolumeMount path from /usr/share/nginx/html to /var/www/html in YAML file
```
vi /tmp/nginx.yaml
```

5. Replace pod YAML file to updated nginx.yaml 
```
replace -f /tmp/nginx.yaml --force 
kubectl get pods
```

6. Now copy index.php to nginx container as per the task 
```
ls /home/thor/
kubectl cp  /home/thor/index.php  nginx-phpfpm:/var/www/html -c nginx-container
```

7. Validate the task 
```
kubectl exec -it nginx-phpfpm -c nginx-container  -- curl -I  http://localhost:8099
```