# A list of stuff to do

## Docker

- [ ] Create a Dockerfile for a [web server](https://tools.suckless.org/quark/)
- [ ] Make the argument for the web server givable at runtime
- [ ] Create a Dockerfile for a nginx server that can mount the content of the website
- [ ] Lancer l'image avec un jeu d'arguments fonctionnel si aucun argument n'est donné
- [ ] Create a Dockerfile for a reverse proxy
- [ ] Use the reverse proxy in a docker-compose file

## Ansible

- [ ] Glances on all the servers with password protected access
- [ ] Deploy MSMTP on all the servers with configurable email address
- [ ] Maybe one more thing with mariadb sambda but don't remember what

## Ansible + docker

- [ ] Deploy the web server and the reverse proxy with ansible using docker compose
- [ ] Deploy only the image of the web server and use a nginx or apache reverse proxy installed by package manager on the host machine of choice
