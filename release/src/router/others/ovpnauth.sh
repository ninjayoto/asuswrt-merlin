#!/bin/sh

# Config parameters
conf="/etc/shadow.openvpn"
logfile="/var/log/ovpnauth.log"
# End of config parameters

log(){
	echo "`date +'%m/%d/%y %H:%M'` - $1" >> $logfile
}

logenv(){
	enviroment="`env | awk '{printf "%s ", $0}'`"
	echo "`date +'%m/%d/%y %H:%M'` - $enviroment" >> $logfile
}

# Start
envr="`echo `env``"
userpass=`cat $1`
username=`echo $userpass | awk '{print $1}'`
password=`echo $userpass | awk '{print $2}'`

# computing password md5
salt=`cat $conf | grep $username: | awk -F"$" '{print $3}'`
if [ ${#salt} -gt 0 ]
then
	userpass=`openssl passwd -1 -salt ${salt} ${password}`
	authpass=`cat $conf | grep $username: | awk -F":" '{print $2}'`

	# verify password
	if [ "${userpass}" = "${authpass}" ]
	then
		log "OpenVPN authentication successfull: $username ${password}"
		#logenv
		exit 0
	fi
fi

log "OpenVPN authentication failed:      $username ${password}"
#logenv
exit 1

