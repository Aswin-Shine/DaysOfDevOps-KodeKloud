A python app needed to be Dockerized, and then it needs to be deployed on App Server 1. We have already copied a requirements.txt file (having the app dependencies) under /python_app/src/ directory on App Server 1. Further complete this task as per details mentioned below:

Create a Dockerfile under /python_app directory:

Use any python image as the base image.
Install the dependencies using requirements.txt file.
Expose the port 3000.
Run the server.py script using CMD.

Build an image named nautilus/python-app using this Dockerfile.

Once image is built, create a container named pythonapp_nautilus:

Map port 3000 of the container to the host port 8094.

Once deployed, you can test the app using curl command on App Server 1.

Solution :

1. SSH into the app server and become root user

```
ssh tony@stapp01
sudo su
```

2. Get into the folder where source file is stored

```
cd /python_app
ls
```

3. Create Dockerfile

```
vi Dockerfile
FROM python

WORKDIR /app

COPY src ./

RUN pip install -r requirements.txt

EXPOSE 3000

CMD ["python" , "server.py"]
```

4. Build Docker image

```
docker build -t nautilus/python-app .
docker images
```

5. Run Dockerfile

```
docker run -d -p 8094:3000 --name pythonapp_nautilus nautilus/python-app
```

6. Verify Contrainer

```
curl http://localhost:8094/
```
