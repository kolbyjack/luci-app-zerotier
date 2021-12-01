-- Copyright 2021 Jonathan Kolb <kolbyjack@gmail.com>
-- Licensed to the public under the Apache License 2.0.

local packageName = "zerotier"
local sys = require "luci.sys"

local m = Map("zerotier", translate("ZeroTier Settings"))

s = m:section(TypedSection, "zerotier")
s.addremove = true

o = s:option(Flag, "enabled", translate("Enabled"))
o.default = "0"
o.rmempty = false

s:option(Value, "port", translate("Port"))

s:option(DynamicList, "join", translate("Networks"))

return m
