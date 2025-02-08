for i in `seq 3 3`
do

    nc -vz 192.168.2.15$i 22
    # ssh-keyscan 192.168.2.18$i
    ssh-keyscan 192.168.2.15$i >/dev/null 2>&1

done

