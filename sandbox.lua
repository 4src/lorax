fmt=string.format

function items(t,    n,i,u)
  u={}; for k,_ in pairs(t) do u[1+#u] = k; end
  table.sort(u)
  i=0
  return function()
    if i < #u then i=i+1; return u[i], t[u[i]] end end end

function rnd(x,d)
  if math.floor(x) == x then return x
  else local mult = 10^(d or 2)
       return math.floor(x*mult+0.5)/mult end end

function o(t,d,     u)
  if type(t) == "function" then return "()" end
  if type(t) == "number"   then return fmt("%s",rnd(t,d)) end
  if type(t) ~= "table"    then return fmt("%s",t) end
  u = {}
  if   #t > 0
  then for _,v in pairs(t) do u[1+#u]=fmt("%s",      o(v,d)) end
  else for k,v in items(t) do u[1+#u]=fmt(":%s %s",k,o(v,d)) end end
  return "{"..table.concat(u," ").."}" end

local id=0
function obj(s,    t)
  t = {}
  return setmetatable(t, { __call=function(klass,...)
    klass.__index    = klass
    klass.__tostring = o
    id = id + 1
    local i = setmetatable({ako=s,id=id},t)
    return setmetatable(t.init(i,...) or i,t) end}) end

local Emp=obj"Emp"

function Emp:init(x) self.x=x; self:y(x) end

function Emp:y(x) print(self.x) end

e=Emp(10)
g=Emp(10)
print"---"
g.m = e

print(o{g,22/7,{g}})

print(e.ako)