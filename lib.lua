local b4={}; for k,v in pairs(_ENV) do b4[k]=k end
local function rogues()
  for k,v in pairs(_ENV) do
    if not b4[k] then 
       print(str.fmt("#W ?%s %s",k,type(v)) ) end end end

--------- --------- --------- --------- --------- --------- -----
local lst,str, mathx, sort, rand = {},{},{},{},{}
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
function lst.push(t,x) t[1+#t]=x; return x end

function lst.per(t,p) return t[p*#t//1] end

function lst.map(t,fun,    u) 
  u={}; for k,v in pairs(t) do u[k] = fun(v) end; return u end

function lst.kap(t,fun,    u,v1,k1) 
  u={}; for k,v in pairs(t) do 
          v1,k1=fun(k,v); u[k1==nil and (1+#u) or k1]=v1  end
  return u end

function lst.slice(t1, nGo, nStop, nInc,       t2)
  if nGo   and nGo   < 0 then nGo  = #t1 + nGo +1 end
  if nStop and nStop < 0 then nStop= #t1 + nStop  end
  t2={}
  for i=(nGo or 1)//1,(nStop or #t1)//1,(nInc or 1)//1 do 
    t2[1+#t2]=t1[i] end
  return t2 end
--------- --------- --------- --------- --------- --------- -----
function sort.sorted(t,fun) table.sort(t,fun); return t end

function sort.lt(x) return function(t1,t2) return t1[x] < t2[x] end end
function sort.gt(x) return function(t1,t2) return t1[x] > t2[x] end end 

function sort.keysort(t,fun,      decorated,sorted,undecorated)
  decorated   = lst.map(t, function(z) return {x=z, y=fun(z)} end)
  sorted      = sort.sorted(decorated, sort.lt"y")
  undecorated = lst.map(sorted, function(z) return z.x  end)
  return undecorated end
--------- --------- --------- --------- --------- --------- -----
function mathx.median(ns,p) return lst.per(ns, .5) end
function mathx.stdev(ns,p) 
  return (lst.per(ns, .9) - lst.per(ns, .1))/2.56 end

function mathx.rnd(num, digits,    mult)
  if type(num) ~= "number" then return num end
  if math.floor(num) == num then return num end
  mult = 10^(digits or 0)
  return math.floor(num * mult + 0.5) / mult end
--------- --------- --------- --------- --------- --------- -----
rand.seed = 937162211

function rand.rint(nlo,nhi)
  return math.floor(0.5 + rand.rand(nlo,nhi))  end

function rand.rand(nlo,nhi)
  nlo,nhi=nlo or 0, nhi or 1
  rand.seed = (16807 * rand.seed) % 2147483647
  return nlo + (nhi-nlo) * rand.seed / 2147483647 end

function rand.any(t) return t[rand.rint(1,#t)] end

function rand.many(t1,n,    t2)
  t2={}; for _=1,n do lst.push(t2, rand.any(t1)) end
  return t2 end
--------- --------- --------- --------- --------- --------- -----
str.fmt = string.format

function str.make(s)
  return math.tointeger(s) or tonumber(s) or (
         s=="true" or (s ~="false" and s)) end -- or false

function str.settings(help,    settings)
  settings={}
  for k,s in help:gmatch(
           "\n[%s]+.*[-][-]([%S]+)[^=]+=[%s]+([%S]+)") do
           --"\n[%s]+[-][%S][%s]+[-][-]([%S]+)[^\n]+= ([%S]+)") do
    settings[k]= str.make(s) end
  return settings,help end

function str.oo(x) print(str.o(x)); return x end
function str.o(t,     fun,tmp) 
  function fun (k,v) if not k:find"^_" then
    return string.format(":%s %s",k,str.o(v)) end end
  tmp = #t>0 and lst.map(t,str.o) or lst.sorted(lst.kap(t,fun))
  return (type(t) ~="table" and tostring(t) or (
          (t._name or "").."{"..table.concat(tmp," ").."}")) end
--------- --------- --------- --------- --------- --------- -----
return {obj=obj, str=str, lst=lst, mathx=math, rand=rand,
        sort =sort}