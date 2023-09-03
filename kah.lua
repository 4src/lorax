local lint=require"lint"
local klass=require"klass"
local obj=klass.obj

local the = {
	act      = "nothing",
	decimals = 2, 
	k        = 2, 
	m        = 1, 
	p        = 2,
	seed     = 937162211
}

local Data,Num,Row,Sym = obj"Data", obj"Num",  obj"Row", obj"Sym"
-----------------------------------------------------------------------
local big = 1E30
local fmt = string.format
local max,min,log,exp,pi = math.max,math.min,math.log,math.exp,math.pi
-----------------------------------------------------------------------
local stat={}
function stat.entropy(t,    e,n) 
  e,n = 0,0
  for _,m in pairs(t) do n = n + m end
  for _,m in pairs(t) do e = e - (m/n * log(m/n,2) end
  return e end

function stat.rnd(n,  nPlaces,     mult)
  mult = 10^(nPlaces or the.decimals)
  return math.floor(n * mult + 0.5) / mult end
-----------------------------------------------------------------------  
local list={}
function list.sort(t,fun) table.sort(t,fun); return t end
function list.push(t,x)   t[1+#t] = x; return x end
-----------------------------------------------------------------------  
local rand={}
rand.seed = 937162211

function rand.rint(nlo,nhi) return floor(0.5 + rand.rand(nlo,nhi)) end

function rand.rand(nlo,nhi)
  nlo,nhi=nlo or 0, nhi or 1
  rand.seed = (16807 * rand.seed) % 2147483647
  return nlo + (nhi-nlo) * rand.seed / 2147483647 end
-----------------------------------------------------------------------
local str={}
function str.o(x,    t)
  if type(x) == "function" then return "f()" end
  if type(x) == "number"   then return tostring(stat.rnd(x)) end
  if objects[x]            then return objects[x] end
  if type(x) ~= "table"    then return tostring(x) end
  t={}; for k,v in pairs(x) do 
          if not (str(k)):sub(1,1) ~= "_" then 
            t[1+#t] = #x>0 and str.o(v) or fmt(":%s %s",k,str.o(v)) end end
  return (str.o(x._is or "").."("..table.concat(#x>0 and t or list.sort(t)," ")..")" end
  
function str.oo(x) print(str.o(x)); return x end

function str.coerce(s,    _fun)
  function _fun(s1)
    return s1=="true" and true or (s1 ~= "false" and s1) or false end
  return math.tointeger(s) or tonumber(s) or _fun(s:match"^%s*(.-)%s*$") end

function str.csv(sFilename,fun,      src,s,cells)
  function _cells(s,t)
    for s1 in s:gmatch("([^,]+)") do t[1+#t]=str.coerce(s1) end; return t end
  src = io.input(sFilename)
  while true do
    s = io.read(); if s then fun(_cells(s,{})) else return io.close(src) end end end
 -----------------------------------------------------------------------


local o, oo, push, sort = str.o, str.oo, list.push, list.sort
-----------------------------------------------------------------------
function Num.new(at,txt)
  return {_is=Num, n=0, at=at or 0, txt=txt or "",
          mu=0, m2=0, sd=0, lo=big, hi=-big,
          heaven=(txt or ""):find"-$" and 0 or 1} end

function Num.add(i,n,     d)
  if n ~= "?" then
    i.n  = i.n + 1
    d    = n - i.mu
    i.mu = i.mu + d/i.n
    i.m2 = i.m2 + d*(x - i.mu)
    i.lo = min(x, i.lo)
    i.hi = max(x, i.hi) 
    if i.n > 1 then i.sd = (i.m2/(i.n - 1))^.5 end end end 

function Num.mid(i)      return i.mu end
function Num.div(i)      return i.sd end
function Num.like(i,x,_) return exp(-.5*((x - i.mu)/i.sd)^2) / (i.sd*((2*pi)^0.5)) end 
-----------------------------------------------------------------------
function Sym.new(at,txt)
  return {_is=Sym, n=0, at=at or 0, txt=txt or "",has ={}, most=0, mode=None} end

function Sym.add(i,s,     d)
  if s ~= "?" then
    i.n = i.n + 1
    i.has[s] = (i.has[s] or 0) + 1
    if i.has[s] > i.most: i.most, i.mode = i.has[s],s end end end 
    
function Sym.mid(i)          return i.mode end
function Sym.div(i)          return stat.entropy(i.has) end
function Sym.like(i,x,prior) return ((i.has[x] or 0) + the.m*prior)/(i.n+the.m) end
-----------------------------------------------------------------------
function Cols.new(t,    col,i,what)
  i = {_is=Cols, x={}, y={}, all={}, names=t}
  for at,txt in pairs(t) do
    col = push(i.cols, (txt:find"^[A-Z]" and NUM or SYM).new(at,txt))
    if not col.txt:find"X$" then
      push(col.txt:find"[+-]$" and i.y or i.x, col) end end
  return i end

function Cols.add(i,t)
  for _,xy in pairs{i.x, i.y} do for _,j in pairs(xy) do add(j, t[c.at]) end end
  return row end
-----------------------------------------------------------------------
function Row.new(t) 
  u={}; for k,v in pairs(t) u[k]=v end
  return {i._is=Row, raw=t, bins=u} end

function Row.classify(i, datas)
  max,out = -big, datas[1]
  ndata,nrows=0,0
  for _,data in pairs(datas) do ndata = ndata+1, nrows = nrows + #data.rows end
  for _,data in pairs(datas) do 
    tmp = like(data, i, ndata, nrows) 
    if tmp > max then max,out = tmp,data end end
  return out,max end
-----------------------------------------------------------------------
function Data.new(src,inits,      i)
  i = {_is=Data, rows={}}
  if   type(src)=="string" 
  then csv(src, function(t) add(i,Row(t,i) end) 
  else for _,rowin pairs(rows or {}) add(i, row) end end 
  return i end

function Data.add(i,row)
  if i.cols then push(i.rows, add(i.cols, row)) else i.cols = Cols.new(row.raw) end end
  
function Data.like(i,row,nh,nrows,     prior,out,x)
  prior = (#i.rows + the.k) / (nrows + the.k * nh)
  out   = log(prior) 
  for _,col in pairs(i.cols.x) do
    x   = row.raw[col.at]
    out = out + (x=="?"and 0 or log(like(col,x,prior))  end end
  return out end
-----------------------------------------------------------------------
