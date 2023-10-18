local l={}
--------- --------- --------- --------- --------- --------- -----
local b4={}; for k,v in pairs(_ENV) do b4[k]=k end

function l.rogues()
  for k,v in pairs(_ENV) do 
    if not b4[k] then print("#W ?",k,type(v)) end end end
--------- --------- --------- --------- --------- --------- -----
l.fmt = string.format

function l.o(t,d,          u,x,mult)
  if type(t) == "function" then return "()" end
  if type(t) == "number"   then
    if math.floor(t) == t then return t else 
      mult = 10^(d or 0)
      return math.floor(t * mult + 0.5) / mult end
  end
  if type(t) ~= "table" then return tostring(t) end
  u={}; for k,v in pairs(t) do
          x= l.o(v,d)
          u[1+#u]= #t==0 and l.fmt(":%s %s",k,x) or x end
  return "{"..table.concat(#t==0 and l.sort(u) or u," ").."}" end

function l.oo(t,d) print(l.o(t,d)); return t end
--------- --------- --------- --------- --------- --------- -----
function l.settings(help,    settings)
  settings={}
  for k,s in help:gmatch(
            "\n[%s]+[-][%S][%s]+[-][-]([%S]+)[^\n]+= ([%S]+)") do
    settings[k]= l.make(s) end
  return settings,help end

function l.cli(t)
  for k,v in pairs(t) do
    v = tostring(v)
    for n,x in ipairs(arg) do
      if x=="-"..(k:sub(1,1)) or x=="--"..k then
        v= ((v=="false" and "true") or (v=="true" and "false")
            or arg[n+1]) 
        t[k] = l.make(v) end end end
  return t end
--------- --------- --------- --------- --------- --------- -----
function l.make(s,    _sym)
  function _sym(s) return s=="true" or (s~="false" and s) end
  return math.tointeger(s) or tonumber(s) or 
          _sym(s:match'^%s*(.*%S)' or '') end

function l.makes(s,     t)
  t={}; for x in s:gmatch("([^,]+)") do 
          t[1+#t] = l.make(x) end; return t end

function l.csv(sFilename,     src)
  src = io.input(sFilename)
  return function(     s)
    s = io.read()
    if s then return l.makes(s) else io.close(src) end end end
--------- --------- --------- --------- --------- --------- -----
function l.sort(t,fun) table.sort(t,fun); return t end

function l.keysort(t,fun,      u,w)
  u={}; for _,v in pairs(t) do u[1+#u] = {x=v, y=fun(v)} end
  table.sort(u, function(a,b) return a.y < b.y end) 
  w={}; for _,v in pairs(u) do w[1+#w] = v.x end
  return w end
--------- --------- --------- --------- --------- --------- -----
function l.per(t,p) return t[p*#t//1] end
function l.push(t,x) t[1+#t]=x; return x end

function l.slice(t, nGo, nStop, nInc,       u)
  if nGo   and nGo   < 0 then nGo  = #t + nGo +1 end
  if nStop and nStop < 0 then nStop= #t + nStop  end
  u={}
  for i=(nGo or 1)//1,(nStop or #t)//1,(nInc or 1)//1 do 
    u[1+#u]=t[i] end
  return u end

function l.items(t,    n,i,u)
  u={}; for k,_ in pairs(t) do u[1+#u] = k; end
  table.sort(u)
  i=0
  return function()
    if i < #u then i=i+1; return u[i], t[u[i]] end end end
--------- --------- --------- --------- --------- --------- -----
function l.stdev(t) 
  return (l.per(t,.9) - l.per(t,.1))/2.58 end

function l.median(t) return l.per(t,.5) end

function l.ent(t,     e,N)
  N=0; for _,n in pairs(t) do N = N + n end
  e=0; for _,n in pairs(t) do e = e - n/N*math.log(n/N,2) end
  return e end

function l.mode(t,     most,mode)
  most=0
  for k,v in pairs(t) do if v > most then mode,most=k,v end end
  return most end
--------- --------- --------- --------- --------- --------- -----
l.rseed = 937162211
function l.rint(nlo,nhi) 
    return math.floor(0.5 + l.rand(nlo,nhi))  end
function l.rand(nlo,nhi)
  nlo,nhi = nlo or 0, nhi or 1
  l.rseed   = (16807 * l.rseed) % 2147483647
  return nlo + (nhi - nlo) * l.rseed / 2147483647 end

function l.any(t) return t[l.rint(1,#t)] end

function l.many(t,n,    u)
  u={}; for i=1,n do u[1+#u] = l.any(t) end; return u end
--------- --------- --------- --------- --------- --------- -----
return l
