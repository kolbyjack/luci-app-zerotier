-- Copyright 2021 Jonathan Kolb <kolbyjack@gmail.com>
-- Licensed to the public under the Apache License 2.0.

local packageName = "zerotier"
local sys = require "luci.sys"

local m = Map("zerotier", translate("ZeroTier Settings"))

m.on_before_commit = function(self)
    self.restart_zt = self.changed
end

m.on_after_commit = function(self)
    if self.restart_zt then
        sys.call("/etc/init.d/zerotier restart")
    end
end

s = m:section(TypedSection, "zerotier")
s.addremove = true

o = s:option(Flag, "enabled", translate("Enabled"))
o.default = "0"
o.rmempty = false

s:option(Value, "port", translate("Port"))

s:option(DynamicList, "join", translate("Networks"))

return m
