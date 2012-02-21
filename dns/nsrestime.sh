#!/bin/bash
# created by Minsuk Song <dnd@grayrose.org> 2012/02/21
#

function usage() {
	echo "$0 <domain>"
}

function getns() {
	local domain="$1"
	dig +short ns $domain
}

function getnsip() {
	local ns="$1"
	dig +short a $ns
}

function getnsas() {
	local nsip="$1"
	whois -h whois.cymru.com $nsip | tail -1 | awk '{print "AS" $1}'
}

function nstime() {
	local domain="$1"
	local nsip="$2"
	local n=0
	while [ $n -lt 3 ]
	do
		echo -n $(dig +noall +stats $domain @$nsip | awk -F":" '/time/ {print $2}') ""
		n=$(expr $n + 1)
	done
	echo
}

if [ $# -lt 1 ]; then
	usage
	exit 0
fi

domain="$1"
echo "-- Domain: $domain"
for ns in $(getns $domain)
do
	nsip=$(getnsip $ns)
	nsas=$(getnsas $nsip)
	echo -n "$ns ($nsip:$nsas) "
	nstime $domain $nsip
done
