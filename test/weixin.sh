#!/bin/sh

HOST="localhost:8078"
Token="FreeSWITCH-ROCKS"
ROOT="/weixin"

case "$1" in
	get)
		URL="?signature=233fe5c2168d23d3c63074d7adf2e2ab0f20f6db&timestamp=1370185630&nonce=1370371748&echostr=echostr"
		;;

	*)
		echo "Usage: get"
		exit
esac

CMD="curl -D - $DIGEST $2 $HOST$ROOT$URL"
echo
echo $CMD
echo
$CMD
