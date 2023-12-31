local b4={}; for k,v in pairs(_ENV) do b4[k]=k end
local function rogues()
  for k,v in pairs(_ENV) do
    if not b4[k] then 
       print(string.format("#W ? %s %s",k,type(v)) ) end end end
--------- --------- --------- --------- --------- --------- -----
local lst,str,sort,rand,go,mathx = {},{},{},{},{},{}
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
  u={}; for k,v in pairs(t) do u[k]=fun(v) end; return u end

function lst.kap(t,fun,    u,v1,k1) 
  u={}; for k,v in pairs(t) do 
          v1,k1=fun(k,v); u[k1==nil and (1+#u) or k1]=v1  end
  return u end

function lst.slice(t, nGo, nStop, nInc,       u)
  if nGo   and nGo   < 0 then nGo  = #t + nGo +1 end
  if nStop and nStop < 0 then nStop= #t + nStop  end
  u={}
  for i=(nGo or 1)//1,(nStop or #t)//1,(nInc or 1)//1 do
    u[1+#u]=t[i] end
  return u end

function lst.items(t,     i,tmp)
  tmp= {}; for k,v in pairs(t) do lst.push(tmp, {key=k,val=v}) end
  table.sort(tmp, function(a,b) return a.key < b.key end)
  i=0
  return function()
    if i < #tmp then
      i = i + 1
      return tmp[i].key, tmp[i].val end end end

--------- --------- --------- --------- --------- --------- -----
function sort.sorted(t,fun) table.sort(t,fun); return t end

function sort.lt(x) 
  return function(t,u) return t[x] < u[x] end end
function sort.gt(x) 
  return function(t,u) return t[x] > u[x] end end 

function sort.keysort(t,fun,      decorated,sorted,undecorated)
  decorated   = lst.map(t, function(z) return {x=z, y=fun(z)} end)
  table.sort(decorated, sort.lt"y")
  undecorated = lst.map(decorated, function(z) return z.x  end)
  return undecorated end
--------- --------- --------- --------- --------- --------- -----
local p=lst.per

function mathx.median(ns) return p(ns, .5) end
function mathx.stdev(ns)  return (p(ns, .9) - p(ns, .1))/2.56 end

function mathx.ent(xs,     e,N)
  N=0; for _,n in pairs(xs) do N = N + n end
  e=0; for _,n in pairs(xs) do e = e - n/N*math.log(n/N,2) end
  return e end

function mathx.mode(xs)
  local v,k = 0,nil
  for k1,v1 in pairs(xs) do if v1>v then k,v=k1,v1 end end
  return k end

function mathx.xshow(x,  digits,    mult)
  if type(x) ~= "number"   then return tostring(x) end
  if type(x) == "function" then return "()" end
  if math.floor(x) == x    then return x end
  mult = 10^(digits or 0)
  return math.floor(x * mult + 0.5) / mult end
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

function str.trim(s)  return s:match'^%s*(.*%S)' or '' end

function str.make(s)
  s=str.trim(s)
  return math.tointeger(s) or tonumber(s) or (
         s=="true" or (s ~="false" and s)) end -- or false

function str.settings(help,    settings)
  settings={}
  for k,s in help:gmatch(
           "\n[%s]+[-][%S][%s]+[-][-]([%S]+)[^\n]+= ([%S]+)") do
    settings[k]= str.make(s) end
  return settings,help end

function str.cli(t)
  for k,v in pairs(t) do
    v = tostring(v)
    for n,x in ipairs(arg) do
      if x=="-"..(k:sub(1,1)) or x=="--"..k then
        v= ((v=="false" and "true") or (v=="true" and "false")
            or arg[n+1]) 
        t[k] = str.make(v) end end end
  return t end

local function _makes(s,    t)
  t={}; for s1 in s:gmatch("([^,]+)") do t[1+#t]=str.make(s1) end
  return t end

function str.csv(sFilename,     src)
  src = io.input(sFilename)
  return function(     s)
    s = io.read()
    if s then return _makes(s) else io.close(src) end end end

function str.oo(x) print(str.o(x)); return x end

function str.o(x,     t,x1)
  if type(x) == "function" then return "()" end
  if type(x) == "number"   then return tostring(x) end
  if type(x) ~= "table"    then return tostring(x) end
  t = lst.kap(x, 
        function(k,v,     x1) 
          if tostring(k):sub(1,1) ~= "_" then 
            x1 = str.o(v)
            return #x>0 and x1 or string.format(":%s %s", k, x1) end end)
  return (x._name or "").. "{" .. table.concat(#x==0 and sort.sorted(t) or t," ") .. "}" end

function str.name(x)
  for k,v in pairs(_G) do if x==v then return k end end end
--------- --------- --------- --------- --------- --------- -----
function go.one(the,eg1,    b4,out)
  b4={}; for k,v in pairs(the) do b4[k]=v end
  rand.seed = the.seed
  out = eg1.fun()
  if out==false then print("❌ FAIL :", eg1.tag) end
  for k,v in pairs(b4) do the[k]=v end
  return out end

function go.run(the,help,examples,    n)  
  str.cli(the)
  if the.help then
    print(help,"\n\nACTIONS:")
    for _,eg in pairs(examples) do
      print(str.fmt("  lua kah.lua %-10s -- %s", eg.tag, eg.txt)) end
  else
    n=0
    for _,eg in pairs(examples) do
      for _,flag in pairs(arg) do
        if flag == eg.tag then
          if go.one(the,eg)==false then
            n=n+1 end end end end end
  rogues()
  os.exit(n) end
--------- --------- --------- --------- --------- --------- -----
return {obj=obj, str=str, lst=lst, mathx=mathx, rand=rand,
        sort=sort, go=go, rogues=rogues}