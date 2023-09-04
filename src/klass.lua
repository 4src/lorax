local klass={}

klass.names={}

local id=0
function klass.obj(s,    t) 
  t = {}
  t.__index = t
  klass.names[t] = s
  return setmetatable(t, {
     __call=function(_,...)
        id = id + 1
        local i = setmetatable({_id=id},t);
        return setmetatable(t.init(i,...) or i,t) end}) end

return klass
