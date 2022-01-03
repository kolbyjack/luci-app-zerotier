#!/bin/bash -e

cd
git clone git://git.yoctoproject.org/opkg-utils

cd openwrt
echo "src-link local $CI_PROJECT_DIR" >> feeds.conf.default
./scripts/feeds update -a
make defconfig
./scripts/feeds install luci-app-zerotier
make -o luci-base -o zerotier package/luci-app-zerotier/compile
mv bin/packages/*/local/*.ipk "$CI_PROJECT_DIR"
