# PHP7.0 with OCI8 and SSH2

this is an dockerfile for creating an development-machine, inventing PHP7 applications with support for Oracle Databases (OCI8) and ssh2
there is also an apache2 installed

## How To Use

```
#build container
docker build -t php7oracle .
#run container as service on port 81
sudo docker run -d -p 81:80 -v /your-local-application-path/:/var/www/html  php7oracle
#run a script inside container
sudo docker exec ##ID## php /var/www/html/index.php
#stop container
sudo docker stop ##ID## 
```

## Instantclient Download

[https://github.com/bumpx/oracle-instantclient]
