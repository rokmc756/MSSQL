#!/bin/bash

MASTER_HOSTNAME=""
ALL_HOSTS="192.168.2.153"
root_pass="changeme"

for i in $(echo $ALL_HOSTS)
do

    sshpass -p "$root_pass" ssh -o StrictHostKeyChecking=no root@$i  "firewall-cmd --zone=public --permanent --remove-port=1433/tcp"
    sshpass -p "$root_pass" ssh -o StrictHostKeyChecking=no root@$i  "firewall-cmd --reload"
    sshpass -p "$root_pass" ssh -o StrictHostKeyChecking=no root@$i  "systemctl stop mssql-server"
    sshpass -p "$root_pass" ssh -o StrictHostKeyChecking=no root@$i  "systemctl disable mssql-server"
    sshpass -p "$root_pass" ssh -o StrictHostKeyChecking=no root@$i  "yum remove mssql-server -y"
    sshpass -p "$root_pass" ssh -o StrictHostKeyChecking=no root@$i  "rm -rf /var/opt/mssql /root/pxf-queries"
    sshpass -p "$root_pass" ssh -o StrictHostKeyChecking=no root@$i  "systemctl status mssql-server"

done

