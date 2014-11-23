Asuswrt-Merlin fork - build 374.43_2-06j9527 (23-November-2014)
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

374.43_2-06j9527 (23-November-2014)
* CHANGED: webui: standardize wireless modes across all radios
* FIXED: init-broadcom: allow guest macmode independent of base
* FIXED: webui: apply settings on guest network before branch to mac filtering
* FIXED: miniupnpd: Use merlin makefile for clean
* NEW: httpd: Add HTTP login/logout events to syslog (user request)

374.43_2-05j9527 (02-November-2014)
- CHANGED: OpenSSL: Upgraded to 1.0.0o
- CHANGED: SSL: disable SSLv2 and SSLv3 support - we now only support TLS 1.0 for https access (IE6 browser is no longer supported)
- CHANGED: Updated miniupnpd to 1.9 (plus upstream PCP fix)
- CHANGED: Updated dropbear to 2014.66
- FIXED: init-broadcom: fix typo preventing wireless mac filter from working on guest networks
* FIXED: Password obscured on Wireless/General tab unless has focus (user request)
* NEW: ssh: Add option to listen on single address (user request)

374.43_2-04j9527 (07-October-2014)
- Source:  https://github.com/john9527/asuswrt-merlin : branch 374.43_2-update
- Desc:    Incremental update to remap key fixes through 376.47, update-04

- CHANGE: Enable sha256 sha512 encryption for SSH
- CHANGE: Increase allowed max FTP connections limit to 10
- CHANGE: Move OpenVPN postconf execution right before client/server launch
- FIXED: Fix duplicate check on VPN Client page
- FIXED: Add missing mDNSResponder to MIPS builds
- FIXED: Wireless status incorrect after applying changes

374.43_2-03j9527 (06-September-2014)
- Source:  https://github.com/john9527/asuswrt-merlin : branch 374.43_2-update
- Desc:    Incremental update to remap key fixes through 376.46, update-03

- FIXED: miniupnpd:  Correct friendly name in Windows Network (from 376.44)
- CHANGED: Updated dnsmasq to 2.72 (ASUS master 376.44) - fixes DHCP leases display


374.43_2-02j9527 (03-September-2014)
- Source:  https://github.com/john9527/asuswrt-merlin : branch 374.43_2-update
- Desc:    Incremental update to remap key fixes through 376.46, update-02

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
- Source:  https://github.com/john9527/asuswrt-merlin : branch 374.43_2-update
- Desc:    Incremental update to remap fixes from 376.44+, update-01

- FIXED: System Log wouldn't properly be positioned at the bottom (Patch by John9527)
- FIXED: DNSFilter clients configured to bypass DNSFilter would still be prevented from using an IPv6 DNS.
- FIXED: Incorrect IPv6 prefix if not a multiple of 8 (patch by NickZ)
- FIXED: OpenVPN firewall cleanup was missing rules (patch by sinshiva)
- FIXED: Minidlna issues with Philips smart TVs
- FIXED: Miniupnpd error flood in Syslog when using a Plex server on your LAN (fix from upstream)
- FIXED: Miniupnpd NAT-PMP errors
- CHANGED: Updated openssl to 1.0.0n


