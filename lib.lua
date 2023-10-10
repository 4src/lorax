local b4={}; for k,v in pairs(_ENV) do b4[k]=k end

local lst,str={},{}
local kap,map,o,oo = lst.kap, lst.map, str.o,str.oo
local push         = lst.push
--------- --------- --------- --------- --------- --------- -----
local function rogues()
   for k,v in pairs(_ENV) do
     if not b4[k] then 
        print(str.fmt("#W ?%s %s",k,type(v)) ) end end end
--------- --------- --------- --------- --------- --------- -----
local id=0
local function obj(s,    t)
  t = {_name=s}
  t.__index = t
  return setmetatable(t, { __call=function(_,...)
    id = id + 1
    local i = setmetatable({_id=id},t)
    return setmetatable(t.init(i,...) or i,t) end}) end
--------- --------- --------- --------- --------- --------- -----
 function lst.push(t,x) t[1+#t]=x; return x end

function lst.map(t,fun,    u) 
  u={}; for k,v in pairs(t) do u[k] = fun(v) end; return u end

function lst.kap(t,fun,    u,v1,k1) 
  u={}; for k,v in pairs(t) do 
          v1,k1=fun(k,v); u[k1==nil and (1+#u) or k1]=v1  end
  return u end
--------- --------- --------- --------- --------- --------- -----
 str.fmt = string.format

function str.make(s)
  return math.tointeger(s) or tonumber(s) or (
         s=="true" or (s ~="false" and s)) end -- or false

function str.settings(s,    t)
  t={}
  for k,v in s:gmatch(
           "\n[%s]+[-][%S][%s]+[-][-]([%S]+)[^\n]+= ([%S]+)") do
    t[k]= str.make(v) end
  return t,s end

function str.oo(x) print(o(x)); return x end
function str.o(t,     fun,tmp) 
  function fun (k,v) if not k:find"^_" then
                  return string.format(":%s %s",k,o(v)) end end
  tmp = #t>0 and map(t,o) or lst.sort(kap(t,fun))
  return (type(t) ~="table" and tostring(t) or (
          (t._name or "").."{"..table.concat(tmp," ").."}")) end  

return {obj=obj, str=str,lst=lst}