# Ansible Role For Backup web server settings

Setup backup scripts and services.

This role backup `/usr/local/etc/nginx/*`, `/etc/*` and `/opt/*` as .tar.gz files to `/var/backup/`.

# Examples

Directory tree.

```
.
├── README.md
├── ansible.cfg
├── group_vars
│   ├── all.yml
│   ├── webserver_centos.yml
│   └── webserver_ubuntu.yml
├── inventory
└── webservers.yml
```

## Inventory file

```
[webservers:children]
webserver_ubuntu
webserver_centos

[webserver_ubuntu]
ubuntu ansible_host=10.10.10.10 ansible_port=22

[webserver_centos]
centos ansible_host=10.10.10.11 ansible_port=22
```

## Group Vars / Common settings(all.yml)

`all.yml` sets common variables.

```
# Common settings
become: yes
ansible_user: root

# Private_key is saved in local host only!
ansible_ssh_private_key_file: ""
```

## Group Vars / Ubuntu(webserver_ubuntu.yml)

`webserver_ubuntu.yml` is `webservers` host's children.

This role references the `backup` variable,
The following example shows that files are backed up at 01:00:00 every day.

Note:

The format of `backup.on_calender` follows the `OnCalender` option of systemd service.

```
ansible_user: ubuntu
become: yes
ansible_become_password: 'ThisIsSecret!'

backup:
  user: root
  group: root
  on_calender: '*-*-* 01:00:00'
```

Of course, you can define it as a general setting in `all.yml`.

## Group Vars / CentOS(webserver_centos.yml)

`webserver_ubuntu.yml` is `webservers` host's children.

The following example shows that the backup user backs up files daily at 00:00:00.

```
# Use all.yml's settings.

backup:
  user: backup
  group: backup
  on_calender: '*-*-* 00:00:00'
```

## Playbook / Webservers(webservers.yml)

```
- hosts: webservers
  become: yes
  module_defaults:
    apt:
      cache_valid_time: 86400
  roles:
    - user
```

# How to DryRun and Apply

DryRun

```
ansible-playbook -i inventory --private-key="~/.ssh/your_private_key" -CD webservers.yml --tags backup
```

Apply

```
ansible-playbook -i inventory --private-key="~/.ssh/your_private_key" -D webservers.yml --tags backup
```
