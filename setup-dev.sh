#!/bin/sh -e

function die() {
    echo "$@"
    exit 1
}

function linkdir() {
    local src="$1"
    local dst="$2"

    [[ -d "$src" ]] || return

    (
        [ "${src:0:1}" != "/" ] && src="$PWD/$src"
        [ "${dst:0:1}" != "/" ] && die "Destination must be absolute path"

        cd "$src"
        find * -type f | while read f; do
            mkdir -p "$( dirname "$dst/$f" )"
            ln -sf "$src/$f" "$dst/$f"
        done
    )
}

uci set luci.ccache.enable=0
uci commit luci

find /www -type l ! -exec test -e {} \; -print0 | xargs -r -0 rm
find /usr/share -type l ! -exec test -e {} \; -print0 | xargs -r -0 rm
find /usr/lib/lua/luci -type l ! -exec test -e {} \; -print0 | xargs -r -0 rm

linkdir applications/luci-app-zerotier/htdocs /www
linkdir applications/luci-app-zerotier/root /
linkdir applications/luci-app-zerotier/luasrc /usr/lib/lua/luci
