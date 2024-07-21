# Ansible playbook

## Bootstrap Ansible

```zsh
ansible-playbook -i unconfigured_hosts.yml playbook-bootstrap-ansible.yml --ask-become-pass
# If you run the playbook inside the container, you will need to run the command again with the --skip-tags=generate-ssh-key
# This option applies if the ssh key is already generated or provided by a third party
ansible-playbook -i unconfigured_hosts.yml playbook-bootstrap-ansible.yml --ask-become-pass --skip-tags=generate-ssh-key
```

Here is all the default variables you can change in the playbook:

```yaml
bootstrap_ansible_user_name: "ansible"
bootstrap_ansible_ssh_key_path: "~/.ssh/ansible"
```

## Docker playbook & roles

You will need the community.docker collection to run the playbook. You can install it with the following command:

```zsh
ansible-galaxy collection install community.docker --upgrade
```

### Docker compose

```zsh
ansible-playbook playbook-docker-compose.yml
```

Here is all the default variables you can change in the playbook:

### Docker image

```zsh
ansible-playbook playbook-docker-image.yml
```

Here is all the default variables you can change in the playbook:

```yaml
dcoker_image_name: "Hello-World"
dcoker_image_tag: "latest"
docker_image_container_name: "Hello-World"
docker_image_container_volumes: []
docker_image_container_ports: []
docker_image_container_env:
  ansible_deployed: "true"
docker_image_docker_folder: "docker"
docker_image_docker_file: "Dockerfile"
docker_image_docker_folder_remote: "/srv"
docker_image_stage: "present"
```

## LAMP stack

```zsh
ansible-playbook playbook-lamp.yml
```

## Glances

```zsh
ansible-playbook playbook-glances.yml
```

## MSMTP

```zsh
ansible-playbook playbook-msmtp.yml --ask-vault-pass
```
