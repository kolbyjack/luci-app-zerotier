#!/bin/sh -e

apk add git python3
git clone git://git.yoctoproject.org/opkg-utils

mkdir -p public
mv *.ipk public/

cd public
../opkg-utils/opkg-make-index . > Packages
gzip < Packages > Packages.gz

cat > index.html <<-EOF
<html>
<head>
  <title>luci-app-zerotier package feed</title>
</head>
<body>
  $(
    for p in Packages* *.ipk; do
      echo "<a href=\"$p\">$p</a><br/>"
    done
  )
</body>
</html>
EOF
