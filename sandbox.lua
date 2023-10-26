fmt=string.format

function cat(t,     u,f,g)
  if type(t) ~= "table" then return fmt("%s",t) end
  u={}
  function f() for _,v in pairs(t) do u[1+#u]=fmt("%s",v) end end
  function g() for k,v in pairs(t) do u[1+#u]=fmt(":%s %s",k,v) end
               table.sort(u) end
  (#t>0 and f or g)()
  return "{"..table.concat(u," ").."}" end

function obj(s,    t)
  t = {}
  return setmetatable(t, { __call=function(klass,...)
    klass.__index    = klass
    klass.__tostring = cat
    local i = setmetatable({ako=s},t)
    return setmetatable(t.init(i,...) or i,t) end}) end

local Emp=obj"Emp"

function Emp:init(x) self.x=x; self:y(x) end

function Emp:y(x) print(self.x) end

e=Emp(10)
g=Emp(10)
print"---"
g.m = e

print(g)
print(e.ako)