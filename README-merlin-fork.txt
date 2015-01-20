Asuswrt-Merlin fork - build 374.43_2-07j9527 (20-January-2015)
=============================================

About
-----
Asuswrt is the name of the common firmware Asus has developed
for their various router models.  Asuswrt-merlin is a customized
version of Asus's firmware.

The releases documented here are based on a fork of Asuswrt-merlin
to allow for updates and customizations from other contributors as
envisioned in the open source development model.

These releases are provided AS IS, and no additional support is committed or
implied by either the individual author or the author of the original
Asuswrt-merlin base.

History
-------
Source:  https://github.com/john9527/asuswrt-merlin : branch 374.43_2-update

374.43_2-07j9527 (20-January-2015)

Changelog
---------

* NEW: Allow traffic monitor graphs to be displayed in Mb/s rather then
	KB/s (user request).  Option added to gui (Tools/Other Settings)
- NEW: AC68P supported with model specific radio settings for 5G
	wireless.  Custom settings for the 5G wireless for the 68P have been
	backported from 376 code.
* NEW: Implememnts an option to override incorrect DSCP settings seen
	on IPv4 Comcast connections (port from Shibby Tomato).  This may improve
	internet speeds for Comcast customers.  Option added to gui
	(Firewall/General).
- NEW: Added max users (connections) to SAMBA gui (backported from 376)
* CHANGE: Can now specify up to 4 address:port or port values for SSH
	listening (user request) This can allow different ports to be specified
	for local vs wan access This modifies a previous commit (was a single
	address only and now need to specify a port when specifying an address).
	Must be set using nvram variables.
* CHANGE: Only validate TxPower settings if changed in gui (user
	request to allow manual setting of power >200)
* CHANGE: The latest level link on the firmware upgrade page now will direct
	you to the fork download location
- CHANGE: OpenVPN upgraded to release 2.3.6, including an upstream fix
	for Cipher-None (fixes documented OpenVPN server exploit)
- CHANGE: OpenSSL updated to 1.0.0p
- CHANGE: Disable deprecated SSL2 and SSL3 protocols
- CHANGE: Hide minidlna database directory. After installing this code
	delete the visible minidlna directory in your media shares and reboot.
- FIXED: OpenVPN Server/Client now forced to alternate CPU in ARM routers.
	This provides a significant performance improvement for OpenVPN connections.
- FIXED: Vulnerability in infosvr (CVE-2014-9583) - this finalizes the
	same fix as was included in Update-06E
- FIXED: Replace memcpy() with the intended memcmp() call - this
	finalizes the same fix as was included in Update-06E
* FIXED: Reboot no longer required when changing TxPower setting
* FIXED: Wireless mode hint now correctly reflects [N Only] selection
* FIXED: Fix AdvLinkMTU entry in radvd.conf for PPP connections
	(Asus bug) - reported by Chrysalis
* FIXED: Implements RFC 6164 which prevents buffer overflow issues seen
	on Comcast (port from Shibby Tomato)
* FIXED: Cleanup nvram variables when changing IPv6 modes
* FIXED: Implements support for stateful DHCP pools when using DCHP-PD
	connections - reported by knighthawk
* FIXED: Implements support for specifying the IPv6 server address for
	6in4 tunnels (port from 376) - reported by il2
* FIXED: Clean up various nvram values when switching IPv6 modes
	(multiple commits)
- FIXED: Minidlna fix for parsing of AAC audio tracks (fix from upstream)
- FIXED: Fix AC66 DLNA icon
- FIXED: Allow 6 digits to be entered for the TCP Timeout Established
	field
* FIXED: Allow changing the number of TCP connections and report default
	value
* FIXED: Hint for [N Only] wireless mode now correct for AC mode routers
* FIXED: Filter bad data from traffic monitor reports (seen as graphs
	being scaled to unrealistic values)
- FIXED: Removed firewall default FORWARD/INVALID rule to prevent duplicates


374.43_2-06Ej9527 (9-January-2015)
- FIXED: Temporary fixes for ASUS infosvr LAN security vulnerability

374.43_2-06j9527 (23-November-2014)
* CHANGED: webui: standardize wireless modes across all radios
* FIXED: init-broadcom: allow guest macmode independent of base
* FIXED: webui: apply settings on guest network before branch to mac filtering
* FIXED: miniupnpd: Use merlin makefile for clean
* NEW: httpd: Add HTTP login/logout events to syslog (user request)

374.43_2-05j9527 (02-November-2014)
- CHANGED: OpenSSL: Upgraded to 1.0.0o
- CHANGED: SSL: disable SSLv2 and SSLv3 support - we now only support TLS 1.0 for
	https access (IE6 browser is no longer supported)
- CHANGED: Updated miniupnpd to 1.9 (plus upstream PCP fix)
- CHANGED: Updated dropbear to 2014.66
- FIXED: init-broadcom: fix typo preventing wireless mac filter from working on guest networks
* FIXED: Password obscured on Wireless/General tab unless has focus (user request)
* NEW: ssh: Add option to listen on single address (user request)

374.43_2-04j9527 (07-October-2014)
- CHANGE: Enable sha256 sha512 encryption for SSH
- CHANGE: Increase allowed max FTP connections limit to 10
- CHANGE: Move OpenVPN postconf execution right before client/server launch
- FIXED: Fix duplicate check on VPN Client page
- FIXED: Add missing mDNSResponder to MIPS builds
- FIXED: Wireless status incorrect after applying changes

374.43_2-03j9527 (06-September-2014)
- FIXED: miniupnpd:  Correct friendly name in Windows Network (from 376.44)
- CHANGED: Updated dnsmasq to 2.72 (ASUS master 376.44) - fixes DHCP leases display


374.43_2-02j9527 (03-September-2014)
- FIXED: Traffic monitor in mobile IE11
- FIXED: MSIE 10 detection
- FIXED: IPv6 firewall rules can be incomplete when using PPP
- FIXED: Minidlna issues with Philips smart TVs (reapplied after minidlna update)
- CHANGED: Updated dnsmasq to 2.71
- CHANGED: Updated minidlna to 1.1.3
- CHANGED: Updated lzo to 2.08
- NEW: banner description now reads 'Merlin fork'
- NEW: Warning msg on Site Survey with MAC filtering on
- NEWFIX: Correct 3rd grid line label in traffic monitor
- NEWFIX: Correct IE10 support for selected pages
- NEW: nvram variable to control syslog to jffs copy

374.43_2-01j9527 (13-August-2014)
- FIXED: System Log wouldn't properly be positioned at the bottom (Patch by John9527)
- FIXED: DNSFilter clients configured to bypass DNSFilter would still be prevented from using an IPv6 DNS.
- FIXED: Incorrect IPv6 prefix if not a multiple of 8 (patch by NickZ)
- FIXED: OpenVPN firewall cleanup was missing rules (patch by sinshiva)
- FIXED: Minidlna issues with Philips smart TVs
- FIXED: Miniupnpd error flood in Syslog when using a Plex server on your LAN (fix from upstream)
- FIXED: Miniupnpd NAT-PMP errors
- CHANGED: Updated openssl to 1.0.0n


