-- Copyright 2021 Jonathan Kolb <kolbyjack@gmail.com>
-- Licensed to the public under the Apache License 2.0.

local packageName = "zerotier"
local json = require "luci.json"
local sys = require "luci.sys"
local uci = require "luci.model.uci".cursor()
local util = require "luci.util"

function contains(list, value)
  for k, v in pairs(list) do
    if v == value then
      return true
    end
  end
  return false
end

function map_table(tbl, f)
  local t = {}
  for k,v in pairs(tbl) do
    t[k] = f(v)
  end
  return t
end

function call_zt(section, cmd, nwid)
  sys.call("zerotier-cli -D/var/lib/zerotier-one_" .. section .. " " .. cmd .. " " .. nwid .. " >/dev/null 2>&1")
end

function exec_zt(section, cmd)
  return json.decode(util.exec("zerotier-cli -D/var/lib/zerotier-one_" .. section .. " -j " .. cmd))
end

local m = Map("zerotier", translate("ZeroTier Settings"))
m.on_after_commit = function(self)
  uci:foreach("zerotier", "zerotier",
    function(section)
      joined_networks = map_table(exec_zt(section[".name"], "listnetworks"),
          function(item) return item.nwid end)

      -- Leave networks that were removed from the config
      for _, nwid in pairs(joined_networks) do
        if nwid ~= nil and not contains(section.join, nwid) then
          call_zt(section[".name"], "leave", nwid)
        end
      end

      -- Join networks that were added to the config
      for _, nwid in pairs(section.join) do
        if not contains(joined_networks, nwid) then
          call_zt(section[".name"], "join", nwid)
        end
      end
    end)
end

s = m:section(TypedSection, "zerotier")
s.addremove = true

o = s:option(Flag, "enabled", translate("Enabled"))
o.default = "0"
o.rmempty = false

s:option(Value, "port", translate("Port"))

s:option(DynamicList, "join", translate("Networks"))

return m
