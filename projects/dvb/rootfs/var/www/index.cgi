#!/bin/sh

echo Content-type: text/html
echo
cat <<EOF
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>DVB gateway `hostname`</title>
</head>
<body>
<h1>DVB gateway: `hostname`</h1>
<h2><a href="/dvbfe.cgi">DVB tuner state</a></h2>
<h2><a href="/status.cgi">status</a></h2>
<h2><a href="http://$HTTP_HOST:8080">Streams</a>
</body>
</html>
EOF
