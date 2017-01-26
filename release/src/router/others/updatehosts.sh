#!/bin/sh

# Add EUI-64 addresses to dnsmasq hosts
# Based on http://tomatousb.org/forum/t-306529/auto-creation-of-ipv6-hostnames

scrname="updatehosts"

trap "" SIGHUP
i=$1
oldpid=$(pidof dnsmasq | cut -f 1 -d " ")
while [ $i -gt -1 ]; do
	newpid=$(pidof dnsmasq | cut -f 1 -d " ")
	if [ "$newpid" == "$oldpid" -a "$newpid" != "" ]; then
		i=$(($i-1))
		oldpid=$newpid
		sleep 1
	else
		rm -f /var/lock/autov6.lock
		exit 0
	fi
done

echo "updating dnsmasq hosts files" | logger -t "$scrname"
killall -SIGHUP dnsmasq
rm -f /var/lock/autov6.lock
exit 0
