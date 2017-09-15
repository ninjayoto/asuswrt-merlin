#!/bin/sh
# use STUN to find the external IP.

DEV=$1
servers="stun.l.google.com:19302 stun.stunprotocol.org stun.iptel.org default"

if [ "$DEV" == "-h" ]
then
	echo "Get External IP Address via STUN"
	echo "Usage: getextip.sh [interface]"
	exit 0
fi

[ "$DEV" == "" ] && DEV=$(nvram get wan0_ifname)
for server in $servers; do
	[ "$server" = "default" ] && server=
	result=$(/usr/sbin/ministun -t 1000 -c 1 -i $DEV $server 2>/dev/null)
	[ $? -eq 0 ] && break
	result=""
done

echo "$result"
