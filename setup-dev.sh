#!/bin/sh -e

function die() {
    echo "$@"
    exit 1
}

function linkdir() {
    local src="$1"
    local dst="$2"

    (
        [ "${src:0:1}" != "/" ] && src="$PWD/$src"
        [ "${dst:0:1}" != "/" ] && die "Destination must be absolute path"

        cd "$src"
        find * -type f | while read f; do
            ln -sf "$src/$f" "$dst/$f"
        done
    )
}

uci set luci.ccache.enable=0
uci commit luci

#linkdir applications/luci-app-zerotier/htdocs /www
linkdir applications/luci-app-zerotier/root /
linkdir applications/luci-app-zerotier/luasrc /usr/lib/lua/luci
