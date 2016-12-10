#!/bin/sh
filedir=/etc/openvpn/dns
filebase=$(echo $filedir/$dev | sed 's/\(tun\|tap\)1/client/;s/\(tun\|tap\)2/server/')
conffile=$filebase\.conf
resolvfile=$filebase\.resolv
dnsscript=$(echo /etc/openvpn/fw/$(echo $dev)-dns\.sh | sed 's/\(tun\|tap\)1/client/;s/\(tun\|tap\)2/server/')
fileexists=
instance=$(echo $dev | sed "s/tun1//;s/tun2*/0/")
lan_if=$(nvram get lan_ifname)
vpn_dns_mode=$(nvram get vpn_dns_mode); if [ "$vpn_dns_mode" == "" ]; then vpn_dns_mode=0; fi
vpn_allow_ipv6=$(nvram get vpn_allow_ipv6); if [ "$vpn_allow_ipv6" == "" ]; then vpn_allow_ipv6=0; fi
if [ "$(nvram get ipv6_service)" == "disabled" ]; then ipv6_enabled=0; else ipv6_enabled=1; fi

# Set up VPN server
if [ $(nvram get dhcpd_dns_router) == 1 ]
then
	VPNserver=$(nvram get lan_ipaddr)
else
	VPNserver=
fi

# Set up ISP server
if [ $(nvram get wan0_dnsenable_x) == 1 ]
then
	ISPserver=$(nvram get wan0_dns | awk -F" " '{ print $1; }')
else
	ISPserver=$(nvram get wan0_dns1_x)
fi
isp_dnscrypt=0
# Override if DNSCRYPT is active and exclusive (currently not working)
#if [ $(nvram get dnscrypt_proxy) == 1 -a $(nvram get vpn_client$(echo $instance)_adns) == 3 ]
#then
#	ISPserver=127.0.0.1:$(nvram get dnscrypt_port)
#	isp_dnscrypt=1
#fi

create_client_list(){
	server=$1
	if [ "$VPNserver" = "" ]
	then
		VPNserver=$server
	fi
	VPN_IP_LIST=$(nvram get vpn_client$(echo $instance)_clientlist)

	OLDIFS=$IFS
	IFS="<"

	for ENTRY in $VPN_IP_LIST
	do
		if [ "$ENTRY" == "" ]
		then
			continue
		fi

		VPN_IP=$(echo $ENTRY | cut -d ">" -f 2)
		if [ "$VPN_IP" != "0.0.0.0" ]
		then
			TARGET_ROUTE=$(echo $ENTRY | cut -d ">" -f 4)
			if [ "$TARGET_ROUTE" = "VPN" ]
			then
				echo iptables -t nat -A DNSVPN$instance -s $VPN_IP -j DNAT --to-destination $VPNserver >> $dnsscript
				logger -t "openvpn-updown" "Setting $VPN_IP to use VPN DNS servers `if [ $VPNserver != $server ]; then echo '(via dnsmasq)'; fi`"
			else
				if [ isp_dnscrypt == 1 ]
				then
					echo iptables -t nat -I DNSVPN$instance -p tcp -s $VPN_IP -j DNAT --to-destination $ISPserver >> $dnsscript
					echo iptables -t nat -I DNSVPN$instance -p udp -s $VPN_IP -j DNAT --to-destination $ISPserver >> $dnsscript
				else
					echo iptables -t nat -I DNSVPN$instance -s $VPN_IP -j DNAT --to-destination $ISPserver >> $dnsscript
				fi
				logger -t "openvpn-updown" "Setting $VPN_IP to use ISP DNS server"
			fi
		fi
	done

	if [ isp_dnscrypt == 1 ]
	then
		echo iptables -t nat -A DNSVPN$instance -p tcp -j DNAT --to-destination $ISPserver >> $dnsscript
		echo iptables -t nat -A DNSVPN$instance -p udp -j DNAT --to-destination $ISPserver >> $dnsscript
	else
		echo iptables -t nat -A DNSVPN$instance -j DNAT --to-destination $ISPserver >> $dnsscript
	fi

	IFS=$OLDIFS
}


if [ ! -d $filedir ]; then mkdir $filedir; fi
if [ -f $conffile ]; then rm $conffile; fileexists=1; fi
if [ -f $resolvfile ]; then rm $resolvfile; fileexists=1; fi

if [ $script_type == 'up' ]
then
	if [ $instance != 0 -a $(nvram get vpn_client$(echo $instance)_rgw) == 2 -a $(nvram get vpn_client$(echo $instance)_adns) -ge 3 -a $vpn_dns_mode == 1 ]
	then
		setdns=0
		if [ -f $dnsscript ]; then rm $resolvfile; fi
		echo iptables -t nat -N DNSVPN$instance >> $dnsscript
		logger -t "openvpn-updown" "Using ISP DNS for non-VPN clients"
	else
		setdns=-1
		logger -t "openvpn-updown" "Using VPN DNS for non-VPN clients"
	fi

	for optionname in `set | grep "^foreign_option_" | sed "s/^\(.*\)=.*$/\1/g"`
	do
		option=`eval "echo \\$$optionname"`
		if echo $option | grep "dhcp-option WINS "; then echo $option | sed "s/ WINS /=44,/" >> $conffile; fi
		if echo $option | grep "dhcp-option DNS"
		then
			echo $option | sed "s/dhcp-option DNS/nameserver/" >> $resolvfile
			if [ $setdns == 0 ]
			then
				create_client_list $(echo $option | sed "s/dhcp-option DNS//")
				setdns=1
			fi
		fi
		if echo $option | grep "dhcp-option DOMAIN"; then echo $option | sed "s/dhcp-option DOMAIN/search/" >> $resolvfile; fi
	done

	if [ $setdns == 1 ]
	then
		echo iptables -t nat -A PREROUTING -i $lan_if -p udp -m udp --dport 53 -j DNSVPN$instance >> $dnsscript
		echo iptables -t nat -A PREROUTING -i $lan_if -p tcp -m tcp --dport 53 -j DNSVPN$instance >> $dnsscript
		if [ $ipv6_enabled == 1 -a $vpn_allow_ipv6 != 1 ]
		then
			if [ $(nvram get ipv6_dns_router) == 1 ]
			then #dnsmasq as ipv6 dns server
				if [ $(nvram get vpn_client$(echo $instance)_adns) != 3 ] #allow in exclusive mode
				then
					echo ip6tables -I INPUT 2 -i $lan_if -p tcp -m tcp --dport 53 -j REJECT >> $dnsscript	
					echo ip6tables -I INPUT 2 -i $lan_if -p udp -m udp --dport 53 -j REJECT >> $dnsscript
					logger -t "openvpn-updown" "VPN IPv6 DNS leak protection enabled (INPUT mode)"
				fi
			else #router not ipv6 dns server
				echo ip6tables -I FORWARD 4 -i $lan_if -p tcp -m tcp --dport 53 -j REJECT >> $dnsscript	
				echo ip6tables -I FORWARD 4 -i $lan_if -p udp -m udp --dport 53 -j REJECT >> $dnsscript
				logger -t "openvpn-updown" "VPN IPv6 DNS leak protection enabled (FORWARD mode)"
			fi
		fi
	fi
fi


if [ $script_type == 'down' -a $instance != 0 ]
then
	if [ -f $dnsscript ]
	then
		/usr/sbin/iptables -t nat -D PREROUTING -i $lan_if -p udp -m udp --dport 53 -j DNSVPN$instance
		/usr/sbin/iptables -t nat -D PREROUTING -i $lan_if -p tcp -m tcp --dport 53 -j DNSVPN$instance
		/usr/sbin/iptables -t nat -F DNSVPN$instance
		/usr/sbin/iptables -t nat -X DNSVPN$instance
		logger -t "openvpn-updown" "Removed ISP DNS rules for non-VPN clients"

		if [ $ipv6_enabled == 1 ]
		then
			/usr/sbin/ip6tables -D INPUT -i $lan_if -p tcp -m tcp --dport 53 -j REJECT
			/usr/sbin/ip6tables -D INPUT -i $lan_if -p udp -m udp --dport 53 -j REJECT
			/usr/sbin/ip6tables -D FORWARD -i $lan_if -p tcp -m tcp --dport 53 -j REJECT
			/usr/sbin/ip6tables -D FORWARD -i $lan_if -p udp -m udp --dport 53 -j REJECT
#			logger -t "openvpn-updown" "Removed VPN IPv6 DNS leak protection"
		fi
	fi
fi

if [ -f $conffile -o -f $resolvfile -o -n "$fileexists" ]
then
	if [ $script_type == 'up' ] ; then
		if [ -f $dnsscript ]
		then
			sh $dnsscript
		fi
		service updateresolv
	elif [ $script_type == 'down' ]; then
		rm $dnsscript
		service updateresolv
		service restart_dnsmasq
	fi
fi

rmdir $filedir
rmdir /etc/openvpn

if [ -f /jffs/scripts/openvpn-event ]
then
	logger -t "custom script" "Running /jffs/scripts/openvpn-event (args: $*)"
	sh /jffs/scripts/openvpn-event $*
fi

exit 0
