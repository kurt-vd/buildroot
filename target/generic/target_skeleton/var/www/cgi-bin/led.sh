#!/bin/sh

#
# This CGI-Skript will read and set the LEDs on a icnova board.
# To be used via an HTML-Browser
#
# (C) 2008 by Benjamin Tietz <benjamin.tietz@in-circuit.de>
# licensed under the terms of the GPL
#

cat <<"HEAD"
Content-Type: text/html

<html>
<head>
<title> LEDs on ICnova </title>
</head>
<body>
<h2> These are the LEDs on your ICnova </h2>
<p> You can set the leds, by checking their corresponding checkbox and click
submit. </p>
<form>
<table>
	<tr><th> LED nr </th><th>On</th></tr>
HEAD

(cd /sys/class/leds;
for i in *; do
	if (echo $QUERY_STRING | grep "$i" >> /dev/null ); then
		echo 255 >> $i/brightness
	else
		echo 0 >> $i/brightness
	fi
	echo -n "<tr><td> $i </td> <td><input type=\"checkbox\""
	echo -n "name=\"led\" value=\"$i\""
	if ! ( cat $i/brightness | grep 0 );
	then
		echo -n " checked"
	fi
	echo " /></td></tr>"
done)

cat <<"FOOTER"
</table>
<input type="submit">
</form>
</body>
</html>
FOOTER

