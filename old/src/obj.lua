local id=0
return function(s,    t) 
  t = {_name=s} 
  t.__index = t 
  return setmetatable(t, {
     __call=function(_,...)
        id = id + 1
        local i = setmetatable({_id=id},t);
        return setmetatable(t.init(i,...) or i,t) end}) end
