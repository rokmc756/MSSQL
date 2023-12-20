#!/bin/bash

MASTER_HOSTNAME=""
ALL_HOSTS="rk8-mssql"

# ssh root@$MASTER_HOSTNAME su "hadoop -c 'hadoop-daemon.sh stop zkfc'"

for i in $(echo $ALL_HOSTS)
do

   ssh root@$i "firewall-cmd --zone=public --permanent --remove-port=1433/tcp"
   ssh root@$i "firewall-cmd --reload"
   ssh root@$i "systemctl stop mssql-server"
   ssh root@$i "systemctl disable mssql-server"
   ssh root@$i "yum remove mssql-server -y"
   ssh root@$i "rm -rf /var/opt/mssql /root/pxf-queries"
   ssh root@$i "systemctl status mssql-server"

done
