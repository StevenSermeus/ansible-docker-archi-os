# Archi-os

## Table of contents

- [Configuration to get ansible running in a docker container](#configuration-to-get-ansible-running-in-a-docker-container)
  - [Terminal setup](#terminal-setup)
  - [Ansible setup](#ansible-setup)
  - [Aliases](#aliases)
  - [SSH configuration](#ssh-configuration)
    - [SSH keys generation](#ssh-keys-generation)

My ansible is running inside a docker container.

## Configuration to get ansible running in a docker container

I recommend to clone my .dotfiles repository to your home directory. This repository contains the configuration files for the docker container and some useful aliases.

```bash
cd ~
git clone git@github.com:StevenSermeus/dotfiles.git .dotfiles
```

You can see in the `~/.dotfiles` directory that there is a `docker` directory. This directory contains the configuration files for the docker container.

### Terminal setup

In the file `terminal.dockerfile` you can see the configuration for the terminal. This configuration is used to create a docker container with a terminal. And will copy the `~/.dotfiles` directory to the container. This way you can use the aliases and configurations in the container. Here is the file content:

```dockerfile
FROM --platform=linux/amd64 debian:stable-slim

# Install dependencies
RUN apt-get update && apt-get install -y \
    zsh \
    curl \
    git \
    stow \
    zoxide \
    fzf \
    gpg \
    wget \
    unzip

# Set root password to be able to use it to install package at runtime
RUN echo 'root:root' | chpasswd

# Eza install
RUN mkdir -p /etc/apt/keyrings
RUN wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | tee /etc/apt/sources.list.d/gierens.list
RUN chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
RUN apt update
RUN apt-get install -y eza

# Starship install
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# Install zellij
# Issue with zellij running in docker container
# Compiling at each start of the container
WORKDIR /tmp

ENV ZELLIJ_VERSION=0.40.1
ENV ARCH=x86_64

RUN curl -LO https://github.com/zellij-org/zellij/releases/download/v${ZELLIJ_VERSION}/zellij-${ARCH}-unknown-linux-musl.tar.gz
RUN tar -xvf zellij-${ARCH}-unknown-linux-musl.tar.gz
RUN mv zellij /usr/local/bin
RUN rm zellij-${ARCH}-unknown-linux-musl.tar.gz

# Create user
RUN useradd -m mew-docker
USER mew-docker
COPY .dotfiles /home/mew-docker/.dotfiles
WORKDIR /home/mew-docker/.dotfiles
RUN stow .

WORKDIR /home/mew-docker

ENV USER=mew-docker
ENV PATH=/home/mew/.local/bin:$PATH
ENV SHELL=/bin/zsh
ENV USERNAME=mew-docker

ENV DOCKERIZED=true

# Install zsh plugins with zinit
ENV TERM=xterm-256color
RUN zsh -c "echo 'source ~/.zshrc' > /tmp/source-zshrc.sh && chmod +x /tmp/source-zshrc.sh"
RUN zsh /tmp/source-zshrc.sh || cat /home/mew-docker/.zshrc

CMD ["/bin/zsh"]
```

This image need to be build in order to build the ansible image since the ansible image will use this image as a base image.

```bash
# If you didn't run the stow command when you cloned the .dotfiles repository
docker build -t terminal -f ~/.dotfiles/.config/docker/terminal.dockerfile ~
# If you ran the stow command when you cloned the .dotfiles repository
docker build -t terminal -f ~/.config/docker/terminal.dockerfile ~
```

### Ansible setup

In the file `ansible.dockerfile` you can see the configuration for the ansible image. This configuration is used to create a docker container with ansible installed.

```dockerfile
FROM --platform=linux/amd64 terminal

USER root
RUN apt install -y \
    sshpass \
    ansible

USER mew-docker

WORKDIR /home/mew-docker/workdir
```

This image need to be build in order to run ansible in a docker container.

```bash
# If you didn't run the stow command when you cloned the .dotfiles repository
docker build -t ansible -f ~/.dotfiles/.config/docker/ansible.dockerfile ~
# If you ran the stow command when you cloned the .dotfiles repository
docker build -t ansible -f ~/.config/docker/ansible.dockerfile ~
```

### Aliases

In the file `aliases` you can see the aliases that I use to run the docker container with ansible.

```bash
volumes='--volume ~/.ssh:/home/mew-docker/.ssh --volume ~/.cache/zellij-docker:/home/mew-docker/.cache'
alias run-ansible="docker run -it --platform=linux/amd64 $volumes --volume $(pwd):/home/mew-docker/workdir --rm --name ansible ansible"
```

Now you are ready to run ansible in a docker container. You can run the following command to start the container:

```bash
run-ansible
```

As you can see in the alias, the `run-ansible` command will mount the `~/.ssh` directory to the container. This way you can use your ssh keys in the container. The `~/.cache/zellij-docker` directory is mounted to the container to store the zellij configuration. The `$(pwd)` directory is mounted to the container to use the ansible playbooks. The `--rm` flag will remove the container when you exit the container.

### SSH configuration

You need to add the following configuration to your `~/.ssh/config` file to use the ssh keys in the container. Doing this will allow you to have a way simpler configuration in ansible.

```bash
# It's for the unconfigured hosts with the base user
# If the user has a password, you can remove the IdentityFile line
Host debian-steven
    HostName 192.168.0.31
    User steven
    IdentityFile ~/.ssh/ansible-steven

Host fedora-steven
    HostName 192.168.0.32
    User steven
    IdentityFile ~/.ssh/ansible-steven

Host arch-steven
    HostName 192.168.0.33
    User steven
    IdentityFile ~/.ssh/ansible-steven

# It's for the configured hosts with the ansible user after the ansible bootstrap
Host debian-ansible
    HostName
    HostName 192.168.0.31
    User ansible
    IdentityFile ~/.ssh/ansible

Host fedora-ansible
    HostName 192.168.0.32
    User ansible
    IdentityFile ~/.ssh/ansible

Host arch-ansible
    HostName 192.168.0.33
    User ansible
    IdentityFile ~/.ssh/ansible
```

#### SSH keys generation

You can generate the ssh keys with the ssh-keygen command. You can run the following command to generate the ssh keys:

```bash
ssh-keygen -t ed25519
```

You can copy the public key to the remote host with the ssh-copy-id command. You can run the following command to copy the public key to the remote host:

```bash
# You can replace the ip-address with the ip address of the remote host and the steven with the user of the remote host and the ansible-steven with the path to the ssh key
ssh-copy-id -i ~/.ssh/ansible-steven steven@ip-address
```
