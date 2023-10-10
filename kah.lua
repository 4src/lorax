local l=require"lib"
local egs=require"egs"
local str,lst  = l.str,l.lst
local the,help = str.settings[[

kah.lua: sample the corners, not the middle
(c) Tim Menzies <timm@ieee.org>, BSD-2 license
     
OPTIONS:
  -b --bins   initial number of bins   = 16
  -C --Cohen  too small                = .35
  -f --file   csv data file            =  data/auto93.csv
  -F --Far    how far to look          = .95
  -h --help   show help                = false
  -H --Half   where to find for far    = 256
  -m --min    min size                 = .5
  -p --p      distance coefficient     = 2
  -r --reuse  do npt reuse parent node = true
  -s --seed   random number seed       = 937162211]]
--------- --------- --------- --------- --------- --------- -----
local kap,map,o,oo = lst.kap, lst.map, str.o,str.oo
local obj,push     = l.obj, lst.push

local NUM,SYM,ROW,DATA = obj"NUM", obj"SYM", obj"ROW", obj"DATA"
--------- --------- --------- --------- --------- --------- -----
function COL(s) return  s:find("^[A-Z]") and NUM() or SYM() end

function NUM:init() self.ns = {} end
function SYM:init() self.xs = {} end

local function incs(col,t) 
  for _,x in pairs(t) do col:add(x) end; return x end

function NUM:add(n) push(self.ns, n) end
function SYM:add(x) self.xs[x] = (self.xs[x] or 0) + 1 end

function NUM:mid() lst.per(self.ns, .5) end
function SYM:mid() 
  local v,k = 0,nil
  for k1,v1 in pairs(self.xs) do if v1>v then k,v=k1,v1 end end
  return k end
--------- --------- --------- --------- --------- --------- -----              