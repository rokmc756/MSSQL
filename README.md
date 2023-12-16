## What is the purpose and intension of this mssql playbook?
This playbook is intended to deploy/install MS SQL Server easily.

## Where is it orignially came from and how has it been changed?
This playbook was just cloned from the following repository and it's just replaced with different directory based ansible role cusotmized by me to use make command in my environment.
* https://github.com/linux-system-roles/mssql

## Supported MS SQL Server, Platform and OS
Virtual Machines\
Cloud Infrastructure\
Baremetal\
MS SQL Server 2022 and on RHEL and Rocky Linux 8.x has been verified

## Prerequisite
MacOS or Fedora/CentOS/RHEL installed with ansible as ansible host.\
At least three supported OS should be prepared with yum repository configured.

## Prepare ansible host to run oralce playbook
* MacOS
```
$ xcode-select --install
$ brew install ansible
$ brew install https://raw.githubusercontent.com/kadwanev/bigboybrew/master/Library/Formula/sshpass.rb
```

* Fedora/CentOS/RHEL
```
$ sudo yum install ansible
$ sudo yum install sshpass
```

## Prepareing OS
Configure Yum / Local & EPEL Repostiory

## Download / configure / run mssql playbook
#### 1) Clone mssql playbook into your local machine
```
$ git clone https://github.com/rokmc756/mssql
```
#### 2) Go to mssql directory
```
$ cd mssql
```
#### 3) Change password for sudo user of ansible or target host
```
$ vi Makefile
~~ snip
ANSIBLE_HOST_PASS="changeme"    # It should be changed with password of user in ansible host that sudo user would be run.
ANSIBLE_TARGET_PASS="changeme"  # It should be changed with password of sudo user in managed nodes that sudo user would be installed.
~~ snip
```
#### 4) Change your sudo user and password on target host
```
$ vi ansible-hosts
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"     # Replace with username of sudo user
remote_machine_password="changeme"   # Replace with password of sudo user

[databases]
rk8-mssql ansible_ssh_host=192.168.0.189    # Change IP address of mssql host
```

#### 5) Set variables for version, password, edition and so on
```
$ vi role/mssql/defaults/mail.yml
~~ snip
mssql_accept_microsoft_odbc_driver_17_for_sql_server_eula: true
mssql_accept_microsoft_cli_utilities_for_sql_server_eula: true
mssql_accept_microsoft_sql_server_standard_eula: true
mssql_version: 2022
mssql_upgrade: false
mssql_password: "Changeme!@#$"
mssql_edition: Developer
mssql_tcp_port: 1433
mssql_manage_firewall: true
mssql_ip_address: "{{ hostvars[groups['databases'][0]]['ansible_eth0']['ipv4']['address'] }}"
~~ snip
mssql_enable_sql_agent: true
mssql_install_fts: true
mssql_install_powershell: true
~~ snip
```
#### 6) Set hosts and role name
```
$ vi setup-hosts.yml
---
---
- hosts: rk8-mssql
  gather_facts: true
  become: yes
  vars:
    print_debug: true
  roles:
    - mssql
```
#### 7) Install MS SQL Server
```
$ make install
```
#### 8) Run the following script to uninstall MS SQL Server after modifying your user and hostname
```
$ sh force_remove_mssql.sh
```

## Planning
Add uninstall and upgraded playbook\
Consider checking how to configure replication with this playbook\
