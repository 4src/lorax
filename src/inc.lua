local b4={}; for k,v in pairs(_ENV) do b4[k]=k end
local csv,fmt,make,o,oo,push,sort

local row,data,cols
local ROW,DATA,COLS
--------- --------- --------- --------- --------- --------- -----
local the = {data="../data/auto93.csv", p=2, help=true}
--------- --------- --------- --------- --------- --------- -----
function ROW(t) return {cells=t, cost=0} end

function DATA(src,    new)
  new = {rows={}, cols=nil}
  if type(src)=="string"
  then for _,t   in csv(the.data)    do oo(t); data(new, ROW(t))  end
  else for _,row in pairs(src or {}) do data(new, row) end end
  return new end

function data(data1,row1)
  if   data1.cols
  then cols(data1.cols, push(data1.rows, row1).cells)
  else data1.cols = COLS(row1.cells) end end

function COLS(t)
  oo(t)
  local x,y,num,all,_ = {},{},{},{},{}
  for n,s in pairs(t) do
    all[n]  = {}
    num[n]  = s:find"^[A-Z]"
    also    = s:find"X$" and _ or (s:find"[!+-]$" and y or x)
    also[n] = all[n] end 
  return {x=x, y=y, all=all,  num=num, names=t} end

function cols(cols1, t)
  for _,xy in pairs{cols1.x, cols1.y} do
    for n,col1 in pairs(xy) do
      x=t[n]
      if x ~="?" then
        if   cols1.num[n] 
        then push(col1,x) 
        else col1[x] = 1 + (col1[x] or 0) end end end end end

function make(s,    sym)
  function sym(s) return s=="true" or (s~="false" and s) end
  return math.tointeger(s) or tonumber(s) or sym(s:match'^%s*(.*%S)' or '') end

function csv(sFile,     src)
  src = io.input(sFile)
  return function(     s,t)
    s = io.read()
    if not s then io.close(src) else
      t={}; for x in s:gmatch("([^,]+)") do t[1+#t] = make(x) end
      return t end end end  

-- function mid(col1) 
--   return col1.symp and col1.mode     or col1.mu end

-- function div(col1) 
--   return col1.symp and ent(col1.has) or col1.sd end

-- function ent(t,     e,N)
--   N=0; for _,n in pairs(t) do N = N + n end
--   e=0; for _,n in pairs(t) do e = e - n/N*math.log(n/N,2) end
--   return e end
--------- --------- --------- --------- --------- --------- -----
fmt=string.format
function sort(t,fun) table.sort(t,fun); return t end

function push(t,x) t[1+#t]=x; return x end

function oo(t) print(o(t)); return t end
function o(t,          u)
  if type(t) ~= "table" then return tostring(t) end
  u={}; for k,v in pairs(t) do 
          u[1+#u]= #t==0 and fmt(":%s %s",k,o(v)) or o(v) end
  return "{"..table.concat(#t==0 and sort(u) or u," ").."}" end
--------- --------- --------- --------- --------- --------- -----
local eg={}
function eg.csv() for t in csv(the.data) do oo(t) end end

function eg.data()  DATA(the.data)  end

eg.data()
for k,v in pairs(_ENV) do if not b4[k] then print("#W ?",k,type(v)) end end 