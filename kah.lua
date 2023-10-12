local l=require"lib" 
local str,lst,m  = l.str,l.lst,l.mathx
local the,help = str.settings[[

kah.lua: sample the corners, not the middle
(c) Tim Menzies <timm@ieee.org>, BSD-2 license
     
OPTIONS:
  -b --bins   initial number of bins   = 16
  -C --Cohen  too small                = .35
  -f --file   csv data file            = data/auto93.csv
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
local function COL(s) return  s:find("^[A-Z]") and NUM() or SYM() end

function NUM:init() self.ns = {} end
function SYM:init() self.xs = {} end

local function incs(col,t)
  for _,x in pairs(t) do col:add(x) end; return col end

function NUM:add(n) push(self.ns, n) end
function SYM:add(x) self.xs[x] = (self.xs[x] or 0) + 1 end

function NUM:mid() return m.median(self.ns) end
function SYM:mid() return m.mode(self.xs) end

function NUM:div() return m.stdev(self.ns) end
function SYM:div() return m.entropy(self.xs) end
--------- --------- --------- --------- --------- --------- -----  
return {NUM=NUM, SYM=SYM, ROW=ROW, DATA=DATA,
        the=the, help=help}
