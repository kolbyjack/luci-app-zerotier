#!/bin/bash -e

cd ~/openwrt

cat <<-EOF > feeds.conf
src-git base https://github.com/openwrt/openwrt.git
src-git luci https://github.com/openwrt/luci.git
src-git packages https://github.com/openwrt/packages.git
src-link local $CI_PROJECT_DIR
EOF

./scripts/feeds update -a
make defconfig
./scripts/feeds install luci-app-zerotier
make -j$(nproc) package/luci-app-zerotier/compile
mv bin/packages/*/local/*.ipk "$CI_PROJECT_DIR"
