#!/bin/sh

HOST="localhost:8088"
ROOT="/weixin"
case "$1" in

	postmsg)
		URL=""
		XML="@post_msg.xml"
		Content_Type="application/xml"
		;;


	*)
		echo "Usage: "
		exit

esac

CMD="curl -s -D /tmp/a $DIGEST $2 -XPOST -H Content-Type:$Content_Type --data-binary $XML $HOST$ROOT$URL"

echo $CMD
$CMD
# `curl -s -D /tmp/a $DIGEST $2 -XPUT -H 'Content-Type:application/xcap-caps+xml' --data-binary $XML $HOST/$ROOT$URL`
cat /tmp/a
