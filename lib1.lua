local l={}
l.fmt=string.format

function l.items(t,    n,i,u)
  u={}
  for k,_ in pairs(t) if k[1] ~= "_" then do u[1+#u] = k end end
  table.sort(u)
  i=0
  return function()
    if i < #u then i=i+1; return u[i], t[u[i]] end end end

function l.rnd(x,d)
  local mult = 10^(d or 2)
  return math.floor(x) == x and x or math.floor(x*mult+0.5)/mult end

function l.o(t,d,      u) 
  if type(t) == "function" then return "()" end
  if type(t) == "number"   then return l.fmt("%s",l.rnd(t,d)) end
  if type(t) ~= "table"    then return l.fmt("%s",t) end
  u = {}
  if   #t > 0
  then for _,v in pairs(t)   do u[1+#u]=l.fmt("%s",      l.o(v,d)) end
  else for k,v in l.items(t) do u[1+#u]=l.fmt(":%s %s",k,l.o(v,d)) end end
  return "{"..table.concat(u," ").."}" end

local id = 0
function l.obj(s,    t)
  t = {__tostring=l.o}
  t.__index = t
  return setmetatable(t, { __call=function(klass,...)
    id = id + 1
    local i = setmetatable({ako=s,id=id},t)
    return setmetatable(t.init(i,...) or i,t) end}) end

return l