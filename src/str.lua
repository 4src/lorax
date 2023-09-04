local egs=require"egs"
local klass=require"klass"
local stat=require"stat"
local list=require"list"

local str={}

function str.o(x,    t)
  if type(x) == "function" then return "f()" end
  if type(x) == "number"   then return tostring(x%1==0 and x or stat.rnd(x)) end
  if klass.names[x]        then return klass.names[x] end
  if type(x) ~= "table"    then return tostring(x) end
  t={}; for k,v in pairs(x) do 
          if not (tostring(k)):sub(1,1) ~= "_" then 
            t[1+#t] = #x>0 and str.o(v) or string.format(":%s %s",k,str.o(v)) end end 
  return str.o(x._is or "").."{"..table.concat(#x>0 and t or list.sort(t)," ").."}" end
  
function str.oo(x) print(str.o(x)); return x end

function str.coerce(s)
  s = s:match"^%s*(.-)%s*$"
  return math.tointeger(s) or tonumber(s) or s=="true" or (s ~= "false" and s) or false end

function str.csv(sFilename,fun,      src,s,cells)
  function _cells(s,t)
    for s1 in s:gmatch("([^,]+)") do t[1+#t]=str.coerce(s1) end; return t end
  src = io.input(sFilename)
  while true do
    s = io.read(); if s then fun(_cells(s,{})) else return io.close(src) end end end

return str
