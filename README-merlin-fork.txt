Asuswrt-Merlin fork - build 374.43_2-01j9527 (13-August-2014)
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

374.43_2-01j9527 (13-August-2014)
   - Source:  https://github.com/john9527/asuswrt-merlin : branch 374.43_2-update
   - Desc:    Incremental update to remap fixes from 376.44+, update1 (01)

   - FIXED: System Log wouldn't properly be positioned
            at the bottom (Patch by John9527)
   - FIXED: DNSFilter clients configured to bypass DNSFilter
            would still be prevented from using an IPv6 DNS.
   - FIXED: Incorrect IPv6 prefix if not a multiple of 8
            (patch by NickZ)
   - FIXED: OpenVPN firewall cleanup was missing rules
            (patch by sinshiva)
   - FIXED: Minidlna issues with Philips smart TVs
   - FIXED: Miniupnpd error flood in Syslog when using a
            Plex server on your LAN (fix from upstream)
   - FIXED: Miniupnpd NAT-PMP errors
   - CHANGED: Updated openssl to 1.0.0n


