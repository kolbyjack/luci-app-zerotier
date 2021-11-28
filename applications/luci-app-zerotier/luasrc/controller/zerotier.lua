module("luci.controller.zerotier", package.seeall)
function index()
    if nixio.fs.access("/etc/config/zerotier") then
        local e = entry({"admin", "network", "zerotier"}, cbi("zerotier"), _("ZeroTier"))
        e.acl_depends = { "luci-app-zerotier" }
    end
end
