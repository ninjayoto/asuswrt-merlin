Asuswrt-Merlin fork - build 374.43_2-17E4j9527 (19-March-2016)
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

Source:  https://github.com/john9527/asuswrt-merlin : branch 374.43_2-update

Changelog
---------
374.43_2-17E4j9527  (19-March-2016)
* CHANGED: Default state for WPS is disabled after a reset to factory defaults
* FIXED: NAT Loopback not working if booting with QOS active
* FIXED: NAT Loopback not working on MIPS routers
* FIXED: Saved nvram CFG file could not be restored
* FIXED: Stop doing http/https response checks if restarting httpd does not prevent errors


374.43_2-17E2j9527  (15-March-2016)
* CHANGED: Change default for sfq limiting in traditional QOS to auto (1) during a factory reset.
* CHANGED: Improved dnsmasq resolv.conf handling (Merlin backport)
* CHANGED: Updated iproute2 to latest ASUS levels (ASUS backport)
* CHANGED: Updates to the Traditional QoS rules pages so that the client name is now shown in addition to the MAC address
* CHANGED: ntp time syncs now based on boot time instead of the top of every hour
* CHANGED: ntp sync retries adjusted to comply with time server tos
- CHANGED: Add HW acceleration FA status to the Tools page for 68P users
- CHANGED: Changed mark for NAT loopback from 0xb400 to 0x8000 (Merlin backport)
- CHANGED: Updated OpenSSL to 1.0.2g
* FIXED: A fix for the VPN client state nvram variables not being set correctly when the client is fully up
* FIXED: Added QoS rules status check to watchdog to handle case of slow to start IPv6
* FIXED: Autostart of OpenVPN servers/clients now waits up to 1 minute to obtain a valid system time before starting
* FIXED: Fix for gui hang if a different client has been logged on and is now displaying the logout page
* FIXED: Optimize native IPv6 boot process
* FIXED: Fixes for native IPv6 failing in the event of a modem reboot
* FIXED: Simple NTPD server will now not start until system time is valid (via watchdog)
* FIXED: Fix for ICMPv6 when QOS is enabled (Tomato backport)
- FIXED: Fixes for QoS and IPv6 accept RA (Tomato backport)
- FIXED: 20+ Memory leak fixes (backported from Shibby Tomato and Linux repository)
- FIXED: OpenVPN clients will now all run at the highest DNS security level (Merlin backport)
- FIXED: Selected updates for IPROUTE2, udhcpc and dhcp6c from later ASUS levels
* NEW: Ability to disable DNSSEC permissive mode (only accept signed responses)
* NEW: Ability to specify the number of threads for the NFS server (default is now 2 threads)
* NEW: Add NVRAM option to set number of threads for NFS server (default now set to 2)
* NEW: Added sshd process to watchdog
* NEW: Enhanced httpd watchdog that now checks the process is responding in addition to being loaded.
* NEW: Improved syslog messages for services start/stop
* NEW: Option to set MTU for native IPv6 - initially will be set to 1280 for maximum compatibility
* NEW: The manually assigned DHCP address list is now automatically sorted by IP (code by @aswild)
- NEW: Added ca certs to curl support (Merlin backport)
- NEW: Added JFFS backup function (Merlin backport) - access via Administration>Restore/Save/Upload Settings page
- NEW: Clients set to bypass OpenVPN in policy based routing may now use default DNS servers in exclusive mode (Merlin backport)
- NEW: DNSSEC support (Merlin backport)
- NEW: NVRAM option to use ASUS NAT loopback method instead of the default Merlin implementation (special cases only)
- NEW: Support for AUS QoS Bandwidth Limiter


374.43_2-16E1j9527  (12-January-2016)
* CHANGED: Updated OpenSSL to 1.0.2e
* CHANGED: Updated e2fsprogs to latest Merlin level
* CHANGED: Increased max Parental Controls to 32
* CHANGED: Updated entware install script to entware-ng
* CHANGED: Added support for igmpproxy customization
* CHANGED: Updated kernel Ethernet driver for ARM routers
* CHANGED: Updated packet matching netfilter for ARM routers with improved IPv6 support
* CHANGED: Updated usbmodeswitch to 2.2.3
* CHANGED: Updated AICloud to latest ASUS binaries
* CHANGED: Updated ASUS WebStorage to latest ASUS binaries
* CHANGED: Updated OpenVPN to 2.3.10
* CHANGED: Updated LZO to 2.09
* CHANGED: Remove TCP ALL selection from Network Filter protocols
* CHANGED: Show successful NTP syncs in syslog by default
* CHANGED: OpenVPN policy mode pass standard paramters if not specified
* NEW: Allow changing the alternate NTP server in the gui
* NEW: Allow changing the time between NTP syncs in the gui ('0' disables sync attempts)
* NEW: Allow changing the time between NTP syncs in the gui ('0' disables sync attempts)
* NEW: Support OpenVPN custom setup for Private Internet Access (PIA) users
* NEW: User QoS rules can now specify an address range
* NEW: User QoS rules can now specify addresses in CIDR format
* NEW: Add new option to System Log>Connections to display connection count summary
* FIX: Closed multiple buffer overflow exposures (via code review)
* FIX: Fixed numerous issues during boot when QoS is active with native IPv6
* FIX: IPv6 performance degredation when using QoS rules that specified an IP address
* FIX: Option to advertise router as IPv6 DNS server with native IPv6 (default)
* FIX: Smart Sync not syncing after start (ASUS binary updates)
* FIX: Router boot failure if NFS is active
* FIX: Vendor lookup from the networkmap client status
* FIX: Disk Utility disk scan unable to run or runs on wrong drive


374.43_2-15E5j9527  (16-November-2015)
* FIXED: missing crl definition for OpenVPN server


374.43_2-15E4j9527  (15-November-2015)
* FIXED: CIDR validator not available to all web pages


374.43_2-15E3j9527  (11-November-2015)
* CHANGED: Dropbear: Reverted to 2015.67 due to Chrome compatibility problems
* CHANGED: NTP update schedule option
* CHANGED: Harden buffer for QOS ipv6_prefix assignment
* FIXED: Fix potential collision with reboot scheduling and ntp updates


374.43_2-15E2j9527  (7-November-2015)
* CHANGED: Updated logging for NTP updates


374.43_2-15j9527  (4-November-2015)
* CHANGED: Add categories to Administration/System webui
* CHANGED: Improvements to syslog loglevel management
* CHANGED: Increase number of lines displayed in syslog
* CHANGED: Minor webui formatting changes
* CHANGED: Revert QOS policing change possibly causing Xbox slowdowns
- CHANGED: Add short password check for router password (ASUS-Security)
- CHANGED: Add support for OpenVPN CRL certificates
- CHANGED: Allow using a CIDR-formatted IP on the Firewall configuration page
- CHANGED: Allow using privileged ports 1-1023 for http/https
- CHANGED: Update avahi-daemon to 378 level
* FIXED: Issue alert if max SSH key length is exceeded
* FIXED: NTP client not working after initial boot timesync
* FIXED: Only reboot when necessary on Administration/System page
* FIXED: Prevent Chrome from autocompleting password fields
- FIXED: Ensure QOS ebtables flag is correctly initialized (ASUS)
- FIXED: Fix dhcp routes metric to avoid conflict with pptd
- FIXED: Fix resource leaks in lpd test
- FIXED: OpenVPN server subnet topology is only valid in TLS-TUN mode
- FIXED: Dropbear - SSH Tunnel drops when accessing invalid resource
- FIXED: Minidlna - Selected upstream server discovery fixes
- FIXED: SSH buffer overflow for keys greater then 2048 characters
- FIXED: Web server URL handler buffer overflow (ASUS-Security)
- FIXED: Web server accept language buffer overflow (ASUS-Security)
- FIXED: Web server host name buffer overflow (ASUS-Security)
* NEW: Networkmap can now recognize UNIX/Linux clients as a PC
* NEW: Router can now act as local SNTP server
- NEW: Add support for scheduled reboots


374.43_2-14E1j9527 (17-September-2015)
* FIXED: Cannot access gui after a factory reset
* FIXED: Logon may be blocked with changed http port
* FIXED: Auto logout not working if switch between http and https
* FIXED: Correctly update path in external command in dropbear
* FIXED: Networkmap sometimes cannot identify client
* NEW: add sfq limit and r2q options for QOS (experimental)


374.43_2-14j9527 (3-September-2015)
* CHANGED: Allow decimal entries in QOS Mb/s
* CHANGED: Allow paste into system password field
* CHANGED: Enable reflector for Avahi interfaces
* CHANGED: Improve readability of text input blocks
* CHANGED: QOS priorty selections to 5 percent steps
* CHANGED: Router HTTP port only bound to router IP address
* CHANGED: Update police filters for ARM QOS
* CHANGED: Validate password length during save
* CHANGED: dnsmasq (router) now default for IPv6 DNS server
- CHANGED: Added a watchdog for the watchdog
- CHANGED: Added watchdog for HTTPD
- CHANGED: Change NAT loopback mark value to avoid collision with QOS
- CHANGED: Change default for TCP_CONNTRACK_ESTABLISED to 40min (was 5 days)
- CHANGED: Preserve existing marks when updating ebtables rules
- CHANGED: Update OpenVPN to 2.3.8
- CHANGED: Update QOS rules mask value
- CHANGED: Update dnsmasq to 2.75 final
- CHANGED: Update dropbear to 2015.68
- CHANGED: Update miniupnpd to 1.9.20150723
* FIXED: Add broadcast flag to GUI generated WOL command
* FIXED: Display of special characters in SSID in Site Survey
* FIXED: Fixed setting of schedules for disk utility
* FIXED: GUI icon shift when access disk utility page
- FIXED: Memory leak in QOS rules setting
* FIXED: Remove redundant routes from policy based VPN routing table
* NEW: Ability to change router GUI HTTP port
* NEW: Add IPSET support in dnsmasq for IPv4 addresses
* NEW: Add user selection for setting QOS default priority
* NEW: LED Stealth option to only show power status/LED
* NEW: Add option to disable running of user scripts/configs


374.43_2-13E3j9527 (20-July-2015)
* CHANGED: Prevent troublesome characters from being used in SSIDs
* FIXED: Fixed typo in setting OpenVPN client autostart


374.43_2-13E2j9527 (17-July-2015)
* FIXED: Really fix setting TCP_MAX_CONNECTIONS after a factory reset


374.43_2-13E1j9527 (14-July-2015)
* CHANGED: MTU Advertisement defaults to enabled for all interfaces
- FIXED: DDNS periodic update checks runs continuously


374.43_2-13j9527 (11-July-2015) limited release
* CHANGED: Additional error checking for PPPoE MTU/MRU values
* CHANGED: IPv6 log reformatted to put DNS servers on separate lines
- CHANGED: Cleanup of IPv6 start/stop/nvram management
- CHANGED: Delay refresh of gui when starting/stopping OpenVPN
- CHANGED: Support Init and Rules calls for qos-start script
- CHANGED: Updated OpenSSL to 1.0.2d
- CHANGED: Updated dnsmasq to 2.73rc9
* FIXED: IPv6 downloads throttled with QoS enabled
* FIXED: TCP max connections incorrect after factory reset
* FIXED: Unable to obtain IPV6 address in PPP connections
- FIXED: DH key length check would hang on MIPS routers
* NEW: New option to disable IPv6 MTU advertisement


374.43_2-12j9527 (19-June-2015)
- CHANGED: OpenSSL replace DH key gen with pre-gen 2048 bit key
- CHANGED: OpenSSL automatically update DH key if < 1024 bits
* CHANGED: Increase gui refresh times for VPN Server/Client
* CHANGED: Clean up formatting of Route status log
* CHANGED: Put temporary addr on new line in IPv6 log


374.43_2-12c2j9527 (17-June-2015)
* CHANGED: Only flush pagecache (drop_caches) when required for ARM
* CHANGED: Fix memory leak in fscache (tomato backport)


374.43_2-12c1j9527 (17-June-2015)
- CHANGED: Update OpenSSL to 1.0.2c
* FIX: Increase gui refresh delay when starting VPN Server


374.43_2-12a1j9527 (16-June-2015)
- CHANGED: Update OpenSSL to 1.0.2a
- CHANGED: OpenVPN server generated DH key length to 1024bits
- CHANGED: OpenVPN updated to 2.3.7
- CHANGED: Updated Entware install scripts
- CHANGED: dnsmasq update to version 2.73rc1.patch
- CHANGED: miniupnpd update to version 1.9.20150430
- CHANGED: pppd backport update to version 2.4.7
- CHANGED: rp_pppoe backport sync with 378 codebase
* CHANGED: Upstream fixes for radvd
* CHANGED: Add DeprecatePrefix option to radvd.conf to force faster release of IPv6 addresses
* CHANGED: Changed INVALID packet rule to external interface only and make it the default
* CHANGED: Expand list of recognized files for album art in Media Server
* CHANGED: IPv6 tomato backport to add option to set default ipv6 routing for PPPoE/IPv6 connections
* CHANGED: Show correct model no in minidlna and miniupnpd
- CHANGED: Add support for new ciphers available in OpenSSL 1.0.2
- CHANGED: Check for only valid characters in client name fields
- CHANGED: Completely remove the run command page for security
- CHANGED: OpenVPN - Allow specifying the destination on policy routing rules to define routing exceptions
- CHANGED: OpenVPN - Apply rules at boot time to ensure blocking is respected
- CHANGED: OpenVPN - Only apply routing blocking on tunnel going down if policy based routing active
- CHANGED: OpenVPN - Separate policy rules for client 1 and 2
- CHANGED: Revert our old fix for Beeline as some people report better results with default code
- CHANGED: Turn off exclamation point warning for guest access modes
* FIXED: Filter client RSSI values if bad value returned
* FIXED: Include guest clients in wireless stats on tools page
* FIXED: Removed unneccessary scroll bars from log pages
* FIXED: radvd - add default value for ppp mtu
- FIXED: OpenVPN - Ensure that we restore previous DNS-settings
- FIXED: OpenVPN - Update routing tables if user switches modes when tunnel is down
- FIXED: OpenVPN - wait until NTP sync was complete before starting
- FIXED: Remove false syslog errors on loading nf_conntrack_ipv6 and proxyarp
* NEW: Add option to disable Media Server scan at every boot


374.43_2-11E1j9527 (01-May-2015)
* FIXED: Fix banner formatting for NL support, add ellipses to SSIDs


374.43_2-11j9527 (27-April-2015)
* CHANGED: ASUS save configuration now includes code level in the file name
* CHANGED: Added ability to disable Comcast IPv6 Neighbor Solicitation fix
* CHANGED: Added existing JFFS2 syslog copy option to gui
* CHANGED: Color coding of connections in the Wireless Log
* CHANGED: Improved stability during boot when processing NAT rules
* CHANGED: Update RADVD to version 1.15
* CHANGED: Updated DDNS info formatting on index page
* CHANGED: Updated banner formatting
* CHANGED: Updated timezone info for Chile and Moscow
- CHANGED: Allow use of client chain CA certificates
- CHANGED: Optimizations for supporting components such as the webui server, dropbear and SQLite
- CHANGED: Remove non-functional external firewall option from VPN Client page
- CHANGED: Removed obsolete 'Turbo' button dialogue for AC68
- CHANGED: Updated ciphers: remove RC4, include ECDHE
- CHANGED: mtd-erase options for additional partitions
* FIXED: Finally fix nvram status of OpenVPN server/client (multiple commits)
- FIXED: Avoid truncated printouts on USB printers
- FIXED: Fix corrupted username/password lists in VPN Server page
- FIXED: Fixed MSS clamping rules
- FIXED: Fixed segfault in Wireless Log
- FIXED: CTF patch for MIPS routers
- FIXED: Only generate httpd SSL keys when required
- FIXED: Resolved ARM routers requiring a second boot to format jffs
* NEW: Ability to specify cron logging level ( nvram set cron_loglevel=<number> )
* NEW: Added ability to save https generated certification (persistent across reboots)
* NEW: New option to allow local subnet forwarding (special case)
- NEW: Dual DNS servers, and ability to disable the router as a DNS server
- NEW: Periodic verify for DDNS WAN IP and hostname
- NEW: Policy based routing for VPN connections


374.43_2-10E1j9527 (23-March-2015)
* FIXED: VPN Details page corruption


374.43_2-10j9527 (21-March-2015)
- CHANGED: Update OpenSSL to 1.0.0r
- CHANGED: Use a SHA256 signature for the https certificate
- CHANGED: Increase default service wait time
* CHANGED: Remember IPv6 settings when disable/enable the same connection type
- FIXED: Correct formatting under IE when changing zoom level
* FIXED: Do not reset OpenVPN status when applying settings under Wireless/Professional


374.43_2-09j9527 (16-March-2015)
- CHANGED: Revert to original ASUS web-redirect rules
* CHANGED: Check for dnsmasq status after start_lan
* CHANGED: Make Never the default setting for Web_Redirect
* CHANGED: Show NA instead of 0 if RSSI/SNR not available in Wireless Log
* FIXED: Options correctly initialized on Wireless/Professional in Repeater mode
* FIXED: DDNS selections could not be applied
* FIXED: Retry iptables-restore commands
- FIXED: Correctly update vpn_server state


374.43_2-08j9527 (10-March-2015)
- CHANGED: Remove built-in DownloadMaster packages (will be downloaded at install time)
- CHANGED: Update entware-setup.sh (ARM)
- CHANGED: Update entware-setup.sh (MIPS)
- CHANGED: Updated OpenSSL to 1.0.0q (maintainance only)
- CHANGED: Wireless Log fix for Guest clients
- CHANGED: Wireless Log format
* CHANGED: busybox: include uniq and dos2unix coreutils
- CHANGED: init-broadcom: Allow reg_mode=strict_h for EU routers
- CHANGED: makefile: include curl for all builds
* CHANGED: radvd Add support for non 64 prefix size
- CHANGED: rc added custom config postconf support for Avahi afd and mt-daap
* FIXED: Map busybox-4609f4 CVE-2013-1803 (Security)
* FIXED: Move Extend_TTL_Value from WAN to Firewall page and save across reboots
* FIXED: Set delay before starting networkmap at boot based on reboot_time
- FIXED: Wireless-Log RSSI, Connected, Flags fields
- FIXED: XSS vulnerability in Main_Analysis_Content.asp (Security)
- FIXED: busybox: respect syslogd -S option
- FIXED: dnsmasq add delay after stop when restarting
- FIXED: dnsmasq: prevent multiple instances
- FIXED: firewall clean up INVALID state rules again
* FIXED: fw: do not reset beamforming options to default during firmware upgrade
* FIXED: kernel: add xt_hl module required for Extend_TTL option
- FIXED: networkmap: prevent multiple instances
- FIXED: networkmap: update nvram var for fullscan
- FIXED: only forward WAN interface to the router's httpd if the associated protocol is enabled
- FIXED: samba: Apply patch for CVE-2015-0240 to the Samba instance used by AiCloud (Security)
- FIXED: webui fix corrupted MAC filter list when removing then re-adding entry
- FIXED: webui: Don't offer the option of disabling regulation mode if in a DFS-enabled region
* NEW: Add modules required for webmon for MIPS and ARM
- NEW: Backported Custom DDNS scripting from Merlin master
- NEW: entware: Added ARM version of setup script, pointing to zyxmon's qnapware repository
* NEW: firewall: add forward rule for ipv6 dhcp - maybe fix Comcast connect?
* NEW: syslogd: add nvram var for -S small parameter
* NEW: syslogd: check/update valid hostname at startup
- NEW: wan: remap Extend_TTL_Value from Asus
* NEW: wifi: show country/regrev on wireless/professional page
* NEW: wifi: unlock Professional parameters in repeater mode


374.43_2-07j9527 (20-January-2015)
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


