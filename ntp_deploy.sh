#!/bin/bash
#Задаём параметры конфигурации ntp-сервера в файле ntp.conf
exec 1> /dev/null 2>&1

workdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ $(dpkg-query -W -f='${Status}' ntp 2>/dev/null | grep -c "ok installed") -eq 0 ]; 
then apt-get install ntp -y; fi

sed -i.bak 's/0.ubuntu.pool.ntp.org/ua.pool.ntp.org/g' /etc/ntp.conf
sed -i.bak '/.ubuntu.pool.ntp.org/d' /etc/ntp.conf
sudo service ntp restart

SCR="$workdir/ntp_verify.sh"
JOB="*/1 * * * * $SCR MAILTO=root@localhost"
TMPC="crontmp"
grep "$SCR" -q <(crontab -l) || (crontab -l>"$TMPC"; echo "$JOB">>"$TMPC"; crontab "$TMPC")
rm $workdir/crontmp

cat /etc/ntp.conf > /etc/ntp.conf.bak
exit 0
