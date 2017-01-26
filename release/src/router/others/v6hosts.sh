#!/bin/sh

# Add EUI-64 addresses to dnsmasq hosts
# Based on http://tomatousb.org/forum/t-306529/auto-creation-of-ipv6-hostnames 

scrname="v6hosts"
debug=$(nvram get autov6_debug)
if [ -n "$debug" ]; then
    LOGA="/tmp/autov6.log"
    LOGB="/tmp/autov6.dat"
else
    LOGA="/dev/null"
    LOGB="/dev/null"
fi
V6HOSTS="/etc/hosts.autov6"

if [ "$1" != "add" -a "$1" != "old" ]; then
    exit 0
fi

if [ -n "$4" ]; then
    HNAME="$4"
elif [ -n "$DNSMASQ_SUPPLIED_HOSTNAME" ]; then
    HNAME="$DNSMASQ_SUPPLIED_HOSTNAME"
elif [ -n "$DNSMASQ_OLD_HOSTNAME" ]; then
    HNAME="$DNSMASQ_OLD_HOSTNAME"
else
    echo "$(date) no name $2" >> "$LOGA"
    exit 0
fi
echo "$(date) $1 $2 '$4' '$DNSMASQ_SUPPLIED_HOSTNAME' '$DNSMASQ_OLD_HOSTNAME' ($HNAME)" >> "$LOGA"

DEL_NEEDED=0
if grep -qi  " ${HNAME}" "$V6HOSTS"; then
    if ping6 -q -c 1 -w 6 $HNAME; then
        echo "$(date) known name, valid addr $HNAME" >> "$LOGA"
        exit 0
    else
        echo "$(date) known name, invalid addr error $HNAME" >> "$LOGA"
        DEL_NEEDED=1
        fi
else
    sleep 2
fi

V6IFACE=$(ip -6 neigh show to fe80::/10 | grep "$2" | awk '{ print $1 }' | awk -F '::' '{ print $2 }')
if [ "$V6IFACE" == "" ]; then
    echo "$(date) no neighbor $HNAME" >> "$LOGA"
    exit 0
fi
V6IFLEN=$(echo $V6IFACE | awk -F ':' '{print NF}')

V6PFX=$(nvram get ipv6_prefix | awk -F ':' 'BEGIN {OFS=":"} { i=1; while ($i != "") {i++}; NF=i-1; print $0}')
V6PFXLEN=$(echo $V6PFX | awk -F ':' '{print NF}')

if [[ $(($V6PFXLEN + $V6IFLEN)) -eq 4 ]]; then
    V6ADDR="::${V6IFACE}";
    DEL_NEEDED=1;
    UPDATE_HOSTS=0;	
elif [[ $(($V6PFXLEN + $V6IFLEN)) -lt 8 ]]; then
    V6ADDR="${V6PFX}::${V6IFACE}";
    UPDATE_HOSTS=1;
elif [[ $(($V6PFXLEN + $V6IFLEN)) -eq 8 ]]; then
    V6ADDR="${V6PFX}:${V6IFACE}";
    UPDATE_HOSTS=1;
else
    echo "$(date) wrong length error $V6PFX $V6IFACE  $HNAME" >> "$LOGA"
    exit 1
fi

ping6 -q -c 1 -w 6 $V6ADDR > /tmp/ping

if ip -6 neigh | grep -qi "$V6ADDR .* lladdr $2"; then
    if [ $DEL_NEEDED -eq 1 ]; then
        # workaround lack of case insensitivity options
	echo "$(date) removing hosts entry for $HNAME" >> "$LOGA"
        sed -i "s/.*\b${HNAME}\b.*//I; /^$/ d" "$V6HOSTS"
    fi
    if [ $UPDATE_HOSTS -eq 1 ]; then
        echo "$(date) $V6ADDR $HNAME" >> "$LOGB"
	if grep -qi  "${V6ADDR} ${HNAME}" "$V6HOSTS"; then
		echo "$(date) skipping duplicate hosts update $V6ADDR $HNAME" >> "$LOGA"
		exit 0
	else
	        echo "$V6ADDR $HNAME" >> "$V6HOSTS"
        	echo "$(date) updating hosts entry $V6ADDR $HNAME" >> "$LOGA"
        	echo "updating hosts entry $V6ADDR $HNAME" | logger -t "$scrname"
        	if [ ! -e /var/lock/autov6.lock ]; then
        	    touch /var/lock/autov6.lock
        	    nohup /usr/sbin/updatehosts.sh 60 </dev/null &>/dev/null &
        	fi
	fi
    fi
else
    echo "$(date) no ping response from $V6ADDR  $HNAME" >> "$LOGA"
fi

exit
