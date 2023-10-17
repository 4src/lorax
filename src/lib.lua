local lib={}
--------- --------- --------- --------- --------- --------- -----
local b4={}; for k,v in pairs(_ENV) do b4[k]=k end

function lib.rogues()
  for k,v in pairs(_ENV) do 
    if not b4[k] then print("#W ?",k,type(v)) end end end
--------- --------- --------- --------- --------- --------- -----
lib.fmt=string.format

function lib.o(t,          u,x)
  if type(t) ~= "table" then return lib.ooo(t) end
  u={}; for k,v in pairs(t) do
          x= lib.o(v)
          u[1+#u]= #t==0 and lib.fmt(":%s %s",k,x) or x end
  return "{"..table.concat(#t==0 and lib.sort(u) or u," ").."}" end

function lib.oo(t) print(lib.o(t)); return t end

function lib.ooo(x,  digits,    mult)
  if type(x) ~= "number"   then return tostring(x) end
  if type(x) == "function" then return "()" end
  if math.floor(x) == x    then return x end
  mult = 10^(digits or 0)
  return math.floor(x * mult + 0.5) / mult end
--------- --------- --------- --------- --------- --------- -----
function lib.settings(help,    settings)
  settings={}
  for k,s in help:gmatch(
            "\n[%s]+[-][%S][%s]+[-][-]([%S]+)[^\n]+= ([%S]+)") do
    settings[k]= lib.make(s) end
  return settings,help end

function lib.cli(t)
  for k,v in pairs(t) do
    v = tostring(v)
    for n,x in ipairs(arg) do
      if x=="-"..(k:sub(1,1)) or x=="--"..k then
        v= ((v=="false" and "true") or (v=="true" and "false")
            or arg[n+1]) 
        t[k] = lib.make(v) end end end
  return t end
--------- --------- --------- --------- --------- --------- -----
function lib.make(s,    _sym)
  function _sym(s) return s=="true" or (s~="false" and s) end
  return math.tointeger(s) or tonumber(s) or 
          _sym(s:match'^%s*(.*%S)' or '') end

function lib.makes(s,     t)
  t={}; for x in s:gmatch("([^,]+)") do 
          t[1+#t] = lib.make(x) end; return t end

function lib.csv(sFilename,     src)
  src = io.input(sFilename)
  return function(     s)
    s = io.read()
    if s then return lib.makes(s) else io.close(src) end end end
--------- --------- --------- --------- --------- --------- -----
function lib.sort(t,fun) table.sort(t,fun); return t end

function lib.keysort(t,fun,      u,w)
  u={}; for k,v in pairs(t) do lib.push(u, {x=v, y=fun(v)}) end
  table.sort(u, function(a,b) return a.y < b.y end)
  w={}; for k,v in pairs(t) do lib.push(w, v.x) end
  return w end
--------- --------- --------- --------- --------- --------- -----
function lib.per(t,p) return t[p*#t//1] end
function lib.push(t,x) t[1+#t]=x; return x end

function lib.slice(t, nGo, nStop, nInc,       u)
  if nGo   and nGo   < 0 then nGo  = #t + nGo +1 end
  if nStop and nStop < 0 then nStop= #t + nStop  end
  u={}
  for i=(nGo or 1)//1,(nStop or #t)//1,(nInc or 1)//1 do 
    u[1+#u]=t[i] end
  return u end

--------- --------- --------- --------- --------- --------- -----
function lib.stdev(t) 
  return (lib.per(t,.9) - lib.per(t,.1))/2.58 end

function lib.median(t) return lib.per(t,.5) end

function lib.ent(t,     e,N)
  N=0; for _,n in pairs(t) do N = N + n end
  e=0; for _,n in pairs(t) do e = e - n/N*math.log(n/N,2) end
  return e end

function lib.mode(t,     most,mode)
  most=0
  for k,v in pairs(t) do if v > most then mode,most=k,v end end
  return most end
--------- --------- --------- --------- --------- --------- -----
lib.rseed = 937162211
function lib.rint(nlo,nhi) 
    return math.floor(0.5 + lib.rand(nlo,nhi))  end
function lib.rand(nlo,nhi)
  nlo,nhi = nlo or 0, nhi or 1
  lib.rseed   = (16807 * lib.rseed) % 2147483647
  return nlo + (nhi - nlo) * lib.rseed / 2147483647 end

function lib.any(t) return t[lib.rint(1,#t)] end

function lib.many(t,n,    u)
  u={}; for i=1,n do u[1+#u] = lib.any(t) end; return u end
--------- --------- --------- --------- --------- --------- -----
return lib
