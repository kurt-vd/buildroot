#!/bin/sh

echo Content-Type: application/javascript
echo

cat <<EOF
host = '`echo $HTTP_HOST`';
EOF
