#!/bin/sh

scr_name="$(basename $0)"

OLDIFS=$IFS
if [ "$1" == "default" ]; then
        echo "Setting default list of public DNSCrypt resolvers..."
        RESOLVERS_PATH="/rom"
        RESOLVERS_FILE="${RESOLVERS_PATH}/dnscrypt-resolvers.csv"
        rm -f "$(nvram get dnscrypt_csv)"
else

        RESOLVERS_PATH="/jffs/etc"
		RESOLVERS_MD="/tmp/public-resolvers.md"
        RESOLVERS_FILE="${RESOLVERS_PATH}/dnscrypt-resolvers.csv"
        RESOLVERS_FILE_TMP="${RESOLVERS_FILE}.tmp"

        RESOLVERS_URL="https://download.dnscrypt.info/resolvers-list/v2/public-resolvers.md"
        RESOLVERS_SIG_URL="${RESOLVERS_URL}.minisig"
        RESOLVERS_SIG_PUBKEY="RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3"

        mkdir -p "${RESOLVERS_PATH}"

        echo "Retrieving the list of public DNSCrypt resolvers..." | logger -s -t "$scr_name"
        /usr/sbin/curl -L -R "$RESOLVERS_URL" -o "$RESOLVERS_MD" || (echo "Download failed" | logger -s -t "$scr_name" && exit 1)
        if $(which minisign > /dev/null 2>&1); then
          /usr/sbin/curl -L -o "$RESOLVERS_MD.minisig" "$RESOLVERS_SIG_URL" || (echo "Failed to retrieve minisig" | logger -s -t "$scr_name" && exit 1)
          /usr/sbin/minisign -V -P "$RESOLVERS_SIG_PUBKEY" -m "$RESOLVERS_MD" || (echo "Signature verification failed" | logger -s -t "$scr_name" && exit 1)
          mv -f "${RESOLVERS_FILE_TMP}.minisig" "${RESOLVERS_FILE}.minisig"
        fi

	# Parse the v2 resolvers file into v1 csv
	echo "Parsing the list of public DNSCrypt resolvers...please wait"
	SDNS_DECODE="/tmp/sdns_decode.dat"
	resolvcnt=0
	IFS=$'\n'
	echo "Name,\"Full name\",\"Description\",\"Location\",\"Coordinates\",URL,Version,DNSSEC validation,No logs,Namecoin,Resolver address,Provider name,Provider public key,Provider public key TXT record" > $RESOLVERS_FILE_TMP
	for sdns in $(cat $RESOLVERS_MD | grep -E '^sdns|^##');
	do
		echo ${sdns} | grep -q "##" >/dev/null 2>&1
		if [ $? -eq 0 ]; then
			desc=$(echo ${sdns} | sed -r 's/.{3}//')
			continue
		fi

		sdns=$(echo ${sdns} | sed -r 's/.{7}//')
		echo ${sdns}== | tr -- "-_ " "+/=" | base64 -d > $SDNS_DECODE

		type=$(dd bs=1 count=1 skip=0 <$SDNS_DECODE 2>/dev/null | hexdump -e '1/1 "%d"')
		if [ $type -ne 1 ]; then continue; fi

		props=$(dd bs=1 count=1 skip=1 <$SDNS_DECODE 2>/dev/null | hexdump -e '1/1 "%d"')
		if [ $(( $props&1 )) -eq 1 ]; then dnssec="yes"; else dnssec="no"; fi
		if [ $(( $props&2 )) -eq 2 ]; then logs="yes"; else logs="no"; fi
		if [ $(( $props&4 )) -eq 4 ]; then filter="yes"; else filter="no"; fi

		addr_length=$(dd bs=1 count=1 skip=9 <$SDNS_DECODE 2>/dev/null | hexdump -e '1/1 "%d"')
		address=$(dd bs=1 count=${addr_length} skip=10 <$SDNS_DECODE 2>/dev/null)

		let pk_length_offset=10+${addr_length}
		pk_length=$(dd bs=1 count=1 skip=${pk_length_offset} <$SDNS_DECODE 2>/dev/null | hexdump -e '1/1 "%d"')
		let pk_offset=${pk_length_offset}+1
		pk=$(dd bs=1 count=${pk_length} skip=${pk_offset} <$SDNS_DECODE 2>/dev/null | hexdump -e '1/2 "%04X:"' | sed 's/\(.\)\(.\)\(.\)\(.\)\(.\)/\3\4\1\2\5/g' | sed 's/.$//')

		let name_length_offset=${pk_offset}+${pk_length}
		name_length=$(dd bs=1 count=1 skip=${name_length_offset} <$SDNS_DECODE 2>/dev/null | hexdump -e '1/1 "%d"')
		let name_offset=${name_length_offset}+1
		name=$(dd bs=1 count=${name_length} skip=${name_offset} <$SDNS_DECODE 2>/dev/null)

		echo ${name} | grep -q "cryptostorm" >/dev/null 2>&1
		if [ $? -eq 0 ]; then namecoin="yes"; else namecoin="no"; fi

		echo "${desc},${desc},,,,,1,$dnssec,$logs,$namecoin,${address},${name},${pk}," >> $RESOLVERS_FILE_TMP
		let resolvcnt=resolvcnt+1
	done
	IFS=$OLDIFS
	mv -f "$RESOLVERS_FILE_TMP" "$RESOLVERS_FILE" > /dev/null 2>&1
	rm -rf $SDNS_DECODE
fi

nvram set dnscrypt_csv="$RESOLVERS_FILE"
nvram commit

echo "Public DNSCrypt resolvers update complete ($resolvcnt entries)" | logger -s -t "$scr_name"

echo "Checking selected DNSCrypt resolvers..."
DNSCRYPT1_RESOLVER=$(nvram get dnscrypt1_resolver)
DNSCRYPT2_RESOLVER=$(nvram get dnscrypt2_resolver)
if [ "x"$(cat "$RESOLVERS_FILE" | grep "$DNSCRYPT1_RESOLVER,") == "x" -a "$DNSCRYPT1_RESOLVER" != "none" -a "$DNSCRYPT1_RESOLVER" != "random" ]; then
        echo "Your first  selected DNSCrypt resolver is no longer available!  Please update your selected servers." | logger -s -t "$scr_name"
		resolverr=1
fi
if [ "x"$(cat "$RESOLVERS_FILE" | grep "$DNSCRYPT2_RESOLVER,") == "x" -a "$DNSCRYPT2_RESOLVER" != "none" -a "$DNSCRYPT2_RESOLVER" != "random" ]; then
        echo "Your second selected DNSCrypt resolver is no longer available!  Please update your selected servers." | logger -s -t "$scr_name"
		resolverr=1
fi
echo "Done"

exit 0
