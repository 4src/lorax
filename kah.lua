local b4={}; for k,v in pairs(_EMV) do b4[k]=k end 
local the,help = {},[[

samplr.jl: sample the corners, not the middle
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
local lst,str = {},{}
local kap,map,push = lst.kap, lst.map, lst.push

help:gsub("\n[%s]+[-][%S][%s]+[-][-]([%S]+)[^\n]+= ([%S]+)",
           function(k,v) the[k]= str.make(v) end)
--------- --------- --------- --------- --------- --------- -----
local id=0
local function obj(s,    t)
  t = {_name=s}
  t.__index = t
  return setmetatable(t, { __call=function(_,...)
    id = id + 1
    local i = setmetatable({_id=id},t)
    return setmetatable(t.init(i,...) or i,t) end}) end
--------- --------- --------- --------- --------- --------- -----
function NUM(i) i.has = {} end
function SYM(i) i.has = {} end

function COL(s) s:find"^[A-Z]" and NUM() or SYM() end

function incs(col,t) 
  for _,x in pairs(t) do col:add(x) end; return x end

function NUM.add(i,x) push(i.has,x) end
function SYM.add(i,x) t.has[x] = (t.has[x] or 0) + 1 end

function NUM.mid(i,x) push(i.has,x) end
function SYM.mid(i,x) t.has[x] = (t.has[x] or 0) + 1 end


--------- --------- --------- --------- --------- --------- -----
function lst.push(t,x) t[1+#t]=x; return x end

function lst.map(t,fun,    u) 
  u={}; for k,v in pairs(t) do u[k] = fun(v) end; return u end

function lst.kap(t,fun,    u,v1,k2) 
  u={}; for k,v in pairs(t) do 
          v1,k1=fun(k,v); u[k1==nil and (1+#u) or k1]=v1  end
  return u end

--------- --------- --------- --------- --------- --------- -----
function str.make(s)
  return math.tointeger(s) or tonumber(s) or s=="true" or (
         s ~="false" and s))

function str.oo(x) print(str.o(x)); return x end
function str.o(t,    fun,tmp) 
  fun = function(k,v) return string.format(":%s %s",k,o(v)) end 
  tmp = #t>0 and lst.map(t,o) or lst.sort(lst.kap(t,fun)
  return (type(t) ~="table" and tostring(t) or 
          "{"..table.concat(tmp)," ").."}") end                         