#!/bin/bash
#Проверяем изменения конфигурационного файла ntp.conf
ps auxw | grep ntpd | grep -v grep > /dev/null
if [ $? != 0 ]; then echo "NOTICE: ntp is not running"
sudo service ntp restart 
fi
diff /etc/ntp.conf /etc/ntp.conf.bak > /dev/null
if [ -n "${diff/[ ]*\n/}" ]; then
echo "NOTICE: /etc/ntp.conf was changed. Calculated diff:"
pushd /etc
echo "$(git diff ntp.conf | cut -d$'\n' -f3-)"
$(git checkout ntp.conf)
sudo service ntp restart
else
exit 0
fi
