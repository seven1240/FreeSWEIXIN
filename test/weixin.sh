#!/bin/sh

HOST="localhost:8078"
HOST="weixin.freeswitch.org.cn:8078"
Token="FreeSWITCH-ROCKS"
ROOT="/weixin"

case "$1" in
	get)
		URL="?signature=5daf5ae19cc111d0cd6d1e992913b409a65a161b&timestamp=1370185630&nonce=1370371748&echostr=echostr"
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
