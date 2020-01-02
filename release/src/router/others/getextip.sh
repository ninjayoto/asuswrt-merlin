#!/bin/sh
# use STUN to find the external IP.

DEV=$1
max_instance=2
servers="stun.l.google.com:19302 stun.stunprotocol.org default"

if [ "$DEV" == "-h" ]
then
	echo "Get External IP Address via STUN"
	echo "Usage: getextip.sh [interface]"
	echo "Usage: gettunnelip.sh [vpn_instance]"
	exit 0
fi

[ "$DEV" == "" ] && DEV=$(nvram get wan0_ifname)
if [ ${#DEV} -eq 1 ] # instance specified
then
	if [ "${DEV}" == "0" ]; then DEV=$(nvram get wan0_ifname); else DEV="tun1${DEV}"; fi
fi
INSTANCE="${DEV:$((${#DEV}-1)):1}"
if [ "${DEV:0:3}" == "tun" -a $INSTANCE -gt $max_instance ]
then
	echo "Invalid client instance!"
	exit 1
fi

for server in $servers; do
	[ "$server" = "default" ] && server=
	result=$(/usr/sbin/ministun -t 1000 -c 1 -i $DEV $server 2>/dev/null)
	[ $? -eq 0 ] && break
	result=""
done

[ "${DEV:0:3}" == "tun" ] && nvram set "vpn_client${INSTANCE}_rip"=$result || nvram set "ext_ipaddr"=$result
echo "$result"
