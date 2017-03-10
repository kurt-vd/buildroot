#!/bin/sh

echo Content-type: text/html
echo
cat <<EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>musicbox</title>
</head>
<body>
<h1>Musicbox Home: `hostname`</h1>
<h2><a href="/alarm.html">Alarms</a></h2>
<h2><a href="http://`echo $HTTP_HOST`:81">MPD</a>
</body>
</html>
EOF
