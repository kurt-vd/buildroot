#!/bin/sh

cat <<EOF
Content-Type: text/html

<html>
<head>
	<title>DVB Tuner status</title>
</head>
<body>
<h2>DVB tuner status</h2>
<pre>
EOF

# main program
dvbfemon

cat <<EOF
</pre>
</body>
</html>
EOF
