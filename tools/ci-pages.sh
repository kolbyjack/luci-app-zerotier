#!/bin/sh -e

apk add git python3
git clone git://git.yoctoproject.org/opkg-utils

opkg-utils/opkg-make-index . > Packages
gzip < Packages > Packages.gz

FILE_LIST=""
for p in Packages Packages.gz *.ipk; do
  FILE_LIST="$FILE_LIST<a href=\"$p\">$p</a><br/>"
done

mkdir -p public

cat > public/index.html <<-EOF
<html>
<head>
  <title>luci-app-zerotier packages</title>
</head>
<body>
  $FILE_LIST
</body>
</html>
EOF
