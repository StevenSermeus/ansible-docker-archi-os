# Docker

Readme file for the docker labo.

## Interactive shell

Run a docker container with an interactive shell.

```bash
# Dockerfile : quark.dockerfile
docker build -t quark -f quark.dockerfile .
docker run -it --rm quark /bin/sh
```

## Web server

Build the docker image for the web server.

```bash
docker build -t quark -f quark.dockerfile .
```

Run the docker container with the web server. The volume can be adjusted to the path of the index.html file. The port can be adjusted to the desired port in the port mapping.

```bash
# Default parameters using CMD
docker run --rm -v ./assets/index.html:/var/www/html/index.html -p 8080:8080 quark

# Custom parameters using ENTRYPOINT
docker run --rm -v ./assets/index.html:/var/www/html/index.html -p 8080:8081 quark -p 8081 -d /var/www/html -h 0.0.0.0
```

## Docker compose

Run the docker-compose file to start the web server and the reverse proxy.

```bash
docker compose up
```

## Nginx serve files

Build the docker image for the nginx server.

```bash
docker build -t nginx -f nginx.dockerfile .
```

Run the docker container with the nginx server. The volume can be adjusted to the path of the website files.

```bash
docker run --rm -v ./assets:/usr/share/nginx/html -p 8080:80 nginx
```
