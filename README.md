## What is the Purpose and Intension of this MS-SQL Ansible Playbook?
This playbook is intended to deploy/install MS SQL Server Easily with Prepare Sample Data for Greenplum PXF.

## Where is it orignially came from and how has it been changed?
This playbook was just cloned from the following repository and it's just replaced with different directory based ansible role cusotmized by Jack to use make command and Makefile in my lab.
* https://github.com/linux-system-roles/mssql

## Supported MS SQL Server, Platform and OS
Virtual Machines\
Cloud Infrastructure\
Baremetal\
MSSQL Server 2022 and on RHEL and Rocky Linux 8.x has been verified

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
#### 1) Clone MS-SQL playbook into your local machine
```
$ git clone https://github.com/rokmc756/MS-SQL
```
#### 2) Go to MS-SQL directory
```
$ cd MS-SQL
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
$ vi ansible-hosts-rk8
[all:vars]
ssh_key_filename="id_rsa"
remote_machine_username="jomoon"
remote_machine_password="changeme"

[databases]
rk8-single-db ansible_ssh_host=192.168.2.153
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
mssql_ip_address: "{{ hostvars[groups['databases'][0]][_netdev]['ipv4']['address'] }}"
~~ snip
mssql_enable_sql_agent: true
mssql_install_fts: true
mssql_install_powershell: true
~~ snip
```
#### 6) Set hosts and role name
```
$ vi setup-temp.yml.tmp
---
- hosts: all
  become: yes
  gather_facts: true
  vars:
    print_debug: true
  roles:
    - temp
```
#### 7) Install MSSQL Server
```
$ make mssql r=config s=firewall
$ make mssql r=setup s=db
$ make mssql r=prepare s=data

or
$ make mssql r=install s=all
```
#### 8) Run the following script to uninstall MS SQL Server after modifying your user and hostname
```
$ make mssql r=uninstall s=db

or
$ make mssql r=uninstall s=all

or
$ sh force-remove-mssql.sh
```

## Planning
- [O] Add Uninstall Playbook
- [ ] Add Upgrade Playbook
- [ ] Consider checking how to configure replication within this playbook

