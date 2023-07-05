# docker-secure-ssh
Dockerfile to launch a ssh server with limited commands

### to build:
(debemos encontrarnos en la misma ubicación donde está el Dockerfile)
```
sudo docker build -t ssh-server-iot . 
```

### to run:
```
docker run -p 2200:22 ssh-server-iot
```

### to stop:
```
docker stop <container_name>
```
### to exec:
```
docker exec -it <container_name> /bin/bash
```
