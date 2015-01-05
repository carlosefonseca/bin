#!/usr/bin/env bash

# Processes certificates and keys and stuff to be used by a server to send
# iOS Push Notifications.


if [ $# -eq 2 ]; then
	# Read Password
	echo -n Password: 
	read -s PW
elif [ $# -eq 3 ]; then
	PW=$3
else
	echo "Usage: $0 appName dev|prod [password]"
	echo "Password will be read once if not passed as argument."
	echo "Requires:"
	echo "  aps_[development|production].cer   certificate from Apple"
	echo "  PushAppName[Dev|Prod].p12          private key export from Keychain"
	exit
fi

APP=$1
TYPE=$2


if [ "dev" == $TYPE ];
then
	longsmall="development"
	camel="Dev"
	shortsmall="dev"
elif [[ "prod" == $TYPE ]]; then
	longsmall="production"
	camel="Prod"
	shortsmall="prod"
fi

apscer="aps_$longsmall.cer"

if [ ! -f $apscer ];
then
	echo "File '$apscer' not found. Get it by feeding a Signing Request to iTC."
	exit
fi

p12="Push$APP$camel.p12"

if [ ! -f $p12 ];
then
	echo "File '$p12' not found. Export the Cert's private key from KeyChain."
	open $apscer

osascript <<'END'
tell application "Keychain Access"
	activate
end tell
delay 1
tell application "System Events"
	keystroke "eTransport"
--	tell process "Keychain Access"
--		select row 6 of outline 1 of scroll area 2 of splitter group 1 of splitter group 1 of window 1
--	end tell
end tell
END


	exit
fi

cert="Push$APP${camel}Cert.pem"
key="Push$APP${camel}Key.pem"

echo -e "$ openssl x509 -in $apscer -inform der -out $cert"
openssl x509 -in $apscer -inform der -out $cert

echo -e "\n$ openssl pkcs12 -nocerts -out $key -in $p12 -passin pass:x -passout pass:x"
openssl pkcs12 -nocerts -out $key -in $p12 -passin pass:$PW -passout pass:$PW

echo -e "\n$ cat $cert $key > ${shortsmall}_ck.pem"
cat $cert $key > ${shortsmall}_ck.pem

echo -e "\n$ openssl pkcs12 -export -in $cert -inkey $key -out ${shortsmall}_ck.p12 -passin pass:x -passout pass:x"
openssl pkcs12 -export -in $cert -inkey $key -out ${shortsmall}_ck.p12 -passin pass:$PW -passout pass:$PW
