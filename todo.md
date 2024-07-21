# A list of stuff to do

## Docker

- [x] Create a Dockerfile for a [web server](https://tools.suckless.org/quark/) that is multi-stage
- [x] Make the argument for the web server givable at runtime
- [x] Create a Dockerfile for a reverse proxy
- [x] Use the reverse proxy in a docker-compose file
- [x] Lancer l'image avec un jeu d'arguments fonctionnel si aucun argument n'est donné
- [ ] Create a Dockerfile for a nginx server that can mount the content of the website

## Ansible

- [x] Bootstrap ansible on all the servers
- [x] Bootstrap docker on all the servers
- [ ] Glances on all the servers with password protected access
- [ ] Deploy MSMTP on all the servers with configurable email address
- [ ] Deploy LAMP stack on all the servers Linux, Apache, MariaDB, PHP on all the servers

## Ansible + docker

- [x] Deploy the web server and the reverse proxy with ansible using docker compose
- [x] Deploy only the image of the web server and use a nginx or apache reverse proxy installed by package manager on the host machine of choice
