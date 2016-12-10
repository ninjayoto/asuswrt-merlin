/*
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 * MA 02111-1307 USA
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <errno.h>
#include <unistd.h>
#include <limits.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <httpd.h>
#include <fcntl.h>
#include <signal.h>
#include <stdarg.h>
#include <sys/wait.h>
#include <dirent.h>

#include <typedefs.h>
#include <bcmutils.h>
#include <shutils.h>
#include <bcmnvram.h>
#include <bcmnvram_f.h>
#include <common.h>
#include <shared.h>
#include <rtstate.h>
#include <wlioctl.h>

#include <wlutils.h>
#include <sys/sysinfo.h>
#include <sys/statvfs.h>
#include <linux/version.h>

#include "data_arrays.h"
#include "httpd.h"

#include <net/route.h>

int ej_tcclass_dump_array(int eid, webs_t wp, int argc, char_t **argv) {
	FILE *fp;
	int ret = 0;
#if 0
	int len = 0;
#endif
	char tmp[64];
	char wan_ifname[12];

	if (nvram_get_int("qos_enable") == 0) {
		ret += websWrite(wp, "var tcdata_lan_array = [[]];\nvar tcdata_wan_array = [[]];\n");
		return ret;
	}

	if (nvram_get_int("qos_type") == 0) { //only valid for traditional QoS
		system("tc -s class show dev br0 > /tmp/tcclass.txt");

		ret += websWrite(wp, "var tcdata_lan_array = [\n");

		fp = fopen("/tmp/tcclass.txt","r");
		if (fp) {
			ret += tcclass_dump(fp, wp);
			fclose(fp);
		} else {
			ret += websWrite(wp, "[]];\n");
		}
		unlink("/tmp/tcclass.txt");

#if 0	// tc classes don't seem to use this interface as would be expected
		fp = fopen("/sys/module/bw_forward/parameters/dev_wan", "r");
		if (fp) {
			if (fgets(tmp, sizeof(tmp), fp) != NULL) {
				len = strlen(tmp);
				if (len && tmp[len-1] == '\n')
					tmp[len-1] = '\0';
			}
			fclose(fp);
		}
		if (len)
			strncpy(wan_ifname, tmp, sizeof(wan_ifname));
		else
#endif
			strcpy(wan_ifname, "eth0");     // Default fallback

		snprintf(tmp, sizeof(tmp), "tc -s class show dev %s > /tmp/tcclass.txt", wan_ifname);
		system(tmp);

	        ret += websWrite(wp, "var tcdata_wan_array = [\n");

	        fp = fopen("/tmp/tcclass.txt","r");
	        if (fp) {
	                ret += tcclass_dump(fp, wp);
			fclose(fp);
		} else {
			ret += websWrite(wp, "[]];\n");
	        }
		unlink("/tmp/tcclass.txt");
	}
	return ret;
}

int tcclass_dump(FILE *fp, webs_t wp) {
	char buf[256], ratebps[16], ratepps[16];
	int tcroot = 0;
	int tcclass = 0;
	int stage = 0;
	unsigned long long traffic;
	int ret = 0;

	while (fgets(buf, sizeof(buf) , fp)) {
		switch (stage) {
			case 0:	// class
				if (sscanf(buf, "class htb %d:%d %*s", &tcroot, &tcclass) == 2) {
					// Skip classes less than 10
					if (tcclass < 10) {
						tcroot = 0;
						tcclass = 0;
						continue;
					}
					ret += websWrite(wp, "[\"%d\",", tcclass);
					stage = 1;
				}
				break;
			case 1: // Total data
				if (sscanf(buf, " Sent %llu bytes %*d pkt %*s)", &traffic) == 1) {
					ret += websWrite(wp, " \"%llu\",", traffic);
					stage = 2;
				}
				break;
			case 2: // Rates
				if (sscanf(buf, " rate %15s %15s backlog %*s", ratebps, ratepps) == 2) {
					ret += websWrite(wp, " \"%s\", \"%s\"],\n", ratebps, ratepps);
					stage = 0;
				}
				break;
			default:
				break;
		}
	}
	ret += websWrite(wp, "[]];\n");
	return ret;
}

// field offsets of DNSCrypt resolver csv
#define NAME		0
#define FULLNAME	1
#define DESC		2
#define LOC		3
#define COORD		4
#define URL		5
#define VERSION		6
#define DNSSEC		7
#define LOGS		8
#define NAMECOIN	9
#define ADDRESS		10
#define PROVIDER	11
#define PUBKEY		12
#define KEYTEXT		13
#define NUM_FIELDS 	14
#define BUFFER_SIZE	1024	//longest line

char *pFields[NUM_FIELDS];

int ej_resolver_dump_array(int eid, webs_t wp, int argc, char_t **argv) {
	FILE *fp;
	int ret = 0;

	ret += websWrite(wp, "var resolverarray = [\n");

	fp = fopen("/rom/dnscrypt-resolvers.csv","r");
	if (fp) {
		ret += resolver_dump(fp, wp);
		ret += websWrite(wp, "];\n");
		fclose(fp);
	} else {
		ret += websWrite(wp, "[]];\n");
	}
	unlink("/rom/dnscrypt-resolvers.csv");

	return ret;
}

int resolver_dump(FILE *pFile, webs_t wp) {
	char sInputBuf[BUFFER_SIZE];
	long lineno = 0L;
	int ret = 0;

	if(pFile == NULL)
		return 1;

	while (!feof(pFile)) {

		// load line into static buffer
		if(fgets(sInputBuf, BUFFER_SIZE-1, pFile)==NULL)
			break;

		// skip first line (headers)
		if(++lineno==1)
			continue;

		// jump over empty lines
		if(strlen(sInputBuf)==0)
			continue;

		// set pFields array pointers to null-terminated string fields in sInputBuf
		if (parse_csv_line(sInputBuf,lineno) == 0)
			// On return pFields array pointers point to loaded fields ready for load into DB or whatever
			// Fields can be accessed via pFields
			ret += websWrite(wp, "[\"%s\", \"%s\", \"%s\"],\n", pFields[NAME], pFields[FULLNAME], pFields[DNSSEC]);
	}
	return ret;
}

int parse_csv_line(char *line, long lineno){
	char *cptr = line;
	int fld = 0;
	int inquote = 0;
	char ch;

	if(line == NULL)
		return 1;

	// chop of last char of input if it is a CR or LF (e.g.Windows file loading in Unix env.)
	// can be removed if sure fgets has removed both CR and LF from end of line
	if(*(line + strlen(line)-1) == '\r' || *(line + strlen(line)-1) == '\n')
		*(line + strlen(line)-1) = '\0';
	if(*(line + strlen(line)-1) == '\r' || *(line + strlen(line)-1 )== '\n')
		*(line + strlen(line)-1) = '\0';


	pFields[fld]=cptr;
	while((ch=*cptr) != '\0' && fld < NUM_FIELDS){
		switch(ch) {
			case '\"':
				if (!inquote)
					pFields[fld]=cptr+1;
				else
					*cptr = '\0';		// zero out " and jump over it
				inquote = !inquote;
				break;
			case ',':
				if (!inquote) {
					*cptr = '\0';		// end of field, null terminate it
					pFields[++fld]=cptr+1;
				}
				break;
			default:
				break;
		}
		cptr++;
	}
	return 0;
}
