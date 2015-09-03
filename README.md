Asuswrt-Merlin Fork by john9527
===============================

This is a fork of the enhanced version of Asuswrt by RMerlin.  It is based on a snapshot of the 374.43_2 Merlin release 
as originally distributed in August 2014. Note that the master branch has had no updates since Oct 2014 and should not be
updated as it may cause compile issues with the update branch 374.43_2-update.

As compared to the latest Asuswrt-Merlin releases...

The fork does include

- Maintenance for documented security issues
- Maintenance for supporting open source components (such as dnsmasq, miniupnpd, etc)
- Backports of applicable fixes and new functions from Merlin's main branch
- Some unique support for options requested by users
- Older versions of the wireless drivers that some feel offer better performance (especially on the MIPS based routers)
- A different IPv6 stack as compared to later Merlin releases which may work better in some environments

The fork does not include

- The new TrendMicro DPI engine functions for ARM routers
- The enhancements to the networkmap for custom icons, client naming, etc.
- Some of the enhanced gui formatting of later releases
- All the changes/tweaks that ASUS may have made since the original code was released (and any newly introduced bugs :) )

 
The following routers are supported by this fork:

- N16, N66U, AC66U, AC56U, AC68U, AC68P (and the retail and color versions, R and W)


The following routers were released after the base code used for this fork was available, and are NOT supported.

- AC87U, AC3200 (and the retail R versions)

See http://www.snbforums.com/threads/18914/ for the latest download information for firmware builds.
