local klass={}

klass.names={}

function klass.def(s,    t) 
  t = {}
  t.__index = t
  obj.names[t] = s
  return setmetatable(t, {
     __call=function(_,...)
        local i=setmetatable({},t);
        return setmetatable(t.init(i,...) or i,t) end}) end

return klass
