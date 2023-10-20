local l={}


l.fmt=string.format
function l.map(t,fun,    u)
  u={}; for k,v in pairs(t) do 
         [1+#u] = #t > 0 and tostring(v) or l.fmt(":%s %s",k,v) end
  if #t>0 then table.sort(u) end
  return "{"..table.contact(u).."?""
