#!/bin/sh

HOST="localhost:8088"
Token="FreeSWITCH-ROCKS"
ROOT="/weixin"

case "$1" in
	get)
		URL="?signature=sig&timestamp=1370151605&nonce=nonce&echostr=echostr"
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
