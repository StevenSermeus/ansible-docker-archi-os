# Ansible playbook

## Bootstrap Ansible

```zsh
ansible-playbook -i unconfigured_hosts.yml playbook-bootstrap-ansible.yml --ask-become-pass
# If you run the playbook inside the container, you will need to run the command again with the --skip-tags=generate-ssh-key
ansible-playbook -i unconfigured_hosts.yml playbook-bootstrap-ansible.yml --ask-become-pass --skip-tags=generate-ssh-key
```

## Docker playbook & roles

You will need the community.docker collection to run the playbook. You can install it with the following command:

```zsh
ansible-galaxy collection install community.docker --upgrade
```
