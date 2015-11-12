#!/bin/sh

# pull summary data from conntrack with router connections filtered

lan_ipaddr=$(nvram get lan_ipaddr)
sdata=$(cat /proc/net/ip_conntrack | grep -v "dst=$lan_ipaddr" | awk '{print $5}'| cut -d: -f1 | sort | uniq -c | sort -nr \
  | fgrep "$(ifconfig br0 | grep "inet addr" | awk '{print $2}' | sed 's/addr://g' | cut -d. -f1-3)")

printf '%-8s %-6s %-18s %-32s\n' " Count" "Type" "IP Address" "Hostname"
printf '%s\n' "$sdata" | while IFS= read -r line
do
	cnt=`echo $line | awk -F" " '{ print $1 }'`
	type=`echo $line | awk -F" |=" '{ print $2 }'`
	ipaddr=`echo $line | awk -F"=" '{ print $2 }'`
	hostname=`arp | grep "br0" | grep "($ipaddr)" | awk -F" " '{ print $1 }'`
	isbroadcast=`echo $ipaddr | awk -F"." '{ print $4 }'`
	if [ "$hostname" == "" ]; then
		if [ "$isbroadcast" == "255" ]; then
			hostname="(Broadcast)"
		else
			hostname=`nslookup $ipaddr | grep "Address" | grep "$ipaddr" | awk -F" " '{ print $NF }'`
			if [ "$hostname" == "$ipaddr" ]; then
				hostname=""
			fi
		fi
	fi

	printf '%6s%-2s %-6s %-18s %-32s\n' "$cnt" "" "$type" "$ipaddr" "$hostname"
done

exit 0
