#!/bin/sh

if [ "$1" == "default" ]; then
	echo "Setting default list of public DNSCrypt resolvers..."
	RESOLVERS_PATH="/rom"
	RESOLVERS_FILE="${RESOLVERS_PATH}/dnscrypt-resolvers.csv"
	rm -f "$(nvram get dnscrypt_csv)"
else

	RESOLVERS_PATH="/jffs/etc"
	RESOLVERS_FILE="${RESOLVERS_PATH}/dnscrypt-resolvers.csv"
	RESOLVERS_FILE_TMP="${RESOLVERS_FILE}.tmp"

	RESOLVERS_URL="https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v1/dnscrypt-resolvers.csv"
	RESOLVERS_SIG_URL="${RESOLVERS_URL}.minisig"
	RESOLVERS_SIG_PUBKEY="RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3"

	mkdir -p "${RESOLVERS_PATH}"

	echo "Updating the list of public DNSCrypt resolvers..."
	/usr/sbin/curl -L -R "$RESOLVERS_URL" -o "$RESOLVERS_FILE_TMP" || (echo "Download failed" && exit 1)
	if $(which minisign > /dev/null 2>&1); then
	  /usr/sbin/curl -L -o "$RESOLVERS_FILE_TMP.minisig" "$RESOLVERS_SIG_URL" || (echo "Failed to retrieve minisig" && exit 1)
	  /usr/sbin/minisign -V -P "$RESOLVERS_SIG_PUBKEY" -m "$RESOLVERS_FILE_TMP" || (echo "Signature verification failed" && exit 1)
	  mv -f "${RESOLVERS_FILE_TMP}.minisig" "${RESOLVERS_FILE}.minisig"
	fi
	mv -f "$RESOLVERS_FILE_TMP" "$RESOLVERS_FILE" > /dev/null 2>&1
fi

nvram set dnscrypt_csv="$RESOLVERS_FILE"
nvram commit

echo "Done"
