local b4={}; for k,v in pairs(_ENV) do b4[k]=k end
local eg,fmt,o,oo,push,sort = {}

local row,data,cols,num,sym,col
local ROW,DATA,COLS,NUM,SYM,COL
--------- --------- --------- --------- --------- --------- -----
local the = {data="../data/auto93.lua", p=2, help=true}
--------- --------- --------- --------- --------- --------- -----
function ROW(t) return {cells=t, cost=0} end

function DATA(src,    new)
  new = {rows={}, cols=nil}
  if type(src)=="string"
  then for _,t   in pairs(dofile(src)) do data(new, ROW(t)) end
  else for _,row in pairs(src or {})   do data(new, row) end end
  return new end

function COL(n,s) return (s:find"^[A-Z]" and NUM or SYM)(n,s) end

function COLS(t,     x,y,all,also,_)
  x,y,all,_ = {},{},{},{}
  for n,s in pairs(t) do
    also = s:find"X$" and _ or (s:find"[!+-]$" and y or x)
    push(also, push(all, COL(n,s))) end
  return {x=x, y=y, all=all, names=t} end

function NUM(n,s)
  return {at=n,txt=s,n=0,mu=0,m2=0,sd=0,lo=1E30,hi=-1E30} end

function SYM(n,s) 
  return {at=n,txt=s,n=0,has={},mode=nil,most=0,symp=true } end
--------- --------- --------- --------- --------- --------- -----
function data(data1,row1)
  if   data1.cols
  then cols(data1.cols, push(data1.rows, row1).cells)
  else data1.cols = COLS(row1.cells) end end

function cols(cols1, t)
  for _,xy in pairs{cols1.x, cols1.y} do
    for _,col1 in pairs(xy) do col(col1, t[col1.at]) end end end

function sym(sym1,x,    tmp)
  tmp = 1 + (sym1.has[x] or 0)
  if tmp > sym1.most then sym1.most, sym1.mode = tmp, x end
  sym1.has[x] = tmp end

function num(num1,x,     d)
  d       = x - num1.mu
  num1.mu = num1.mu + d/num1.n
  num1.m2 = num1.m2 + d*(x - num1.mu)
  if x < num1.lo then num1.lo = x end
  if x > num1.hi then num1.hi = x end
  if num1.n > 1  then num1.sd = (num1.m2/(num1.n - 1))^.5 end end

function col(col1, x)
  if x~="?" then
    col1.n = col1.n+1
    return (col1.symp and sym or num)(col1,x) end end
--------- --------- --------- --------- --------- --------- -----
function mid(col1) 
  return col1.symp and col1.mode     or col1.mu end

function div(col1) 
  return col1.symp and ent(col1.has) or col1.sd end

function ent(xs,     e,N)
  N=0; for _,n in pairs(xs) do N = N + n end
  e=0; for _,n in pairs(xs) do e = e - n/N*math.log(n/N,2) end
  return e end

function 
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
eg.data = function() DATA(the.data) end

eg.data()
for k,v in pairs(_ENV) do if not b4[k] then print("#W ?",k,type(v)) end end 