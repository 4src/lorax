local b4={}; for k,v in pairs(_ENV) do b4[k]=k end
local aha,any,clone,col,corners,csv,d2h,div,ent,fmt,half,keysort,make
local main,makes,median,mid,minkowski,mode,neighbors,norm,o,oo,ooo
local per,push,rand,rint,run,rseed,sort,stats,stdev,y

local row,data,cols,ROW,DATA,COLS,NUM,SYM,COL
--------- --------- --------- --------- --------- --------- -----
local the = {data="../data/auto93.csv", p=2, help=true}
--------- --------- --------- --------- --------- --------- -----
function ROW(t)   return {cells=t, cost=0} end

function y(row1) row1.cost = 1 ; return row1 end
--------- --------- --------- --------- --------- --------- -----
function SYM(n,s) return {at=n, txt=s, has={}} end
function NUM(n,s) return {at=n, txt=s, has={}, nump=true,
                          heaven=(s or ""):find"-$" and 0 or 1} end

function COL(n,s) return ((s or ""):find"^[A-Z]" and NUM or SYM)(n,s) end

function col(col1,x)
  if x ~= "?" then
    if col1.nump then push(col1.has, x) else
      col1.has[x] = 1 + (col1.has[x] or 0) end end end

function mid(col1) 
  return col1.nump and median(col1.has) or mode(col1.has) end

function div(col1) 
  return col1.nump and stdev(col1.has) or ent(col1.has) end

function norm(col1,x,      t)
  if   x=="?" or not col1.nump then return x else
    t = col1.has
    return (x - t[1])/(t[#t] - t[1] + 1E-30) end end
--------- --------- --------- --------- --------- --------- -----
function COLS(t,      also,x,y,num,all,_)
  x,y,all,_ = {},{},{},{}
  for n,s in pairs(t) do
    also = s:find"X$" and _ or (s:find"[!+-]$" and y or x)
    also[n] = push(all, COL(n,s)) end 
  return {x=x, y=y, all=all, names=t} end
  
function cols(cols1,t,     x)
  for _,cols1 in pairs{cols1.x, cols1.y} do
    for _,col1 in pairs(cols1) do 
      col(col1, t[col1.at]) end end end 
--------- --------- --------- --------- --------- --------- -----
function DATA(src,    new)
  new = {rows={}, cols=nil}
  if type(src)=="string"
  then for t     in csv(the.data)    do data(new, ROW(t))  end
  else for _,row in pairs(src or {}) do data(new, row) end end
  for _,col1 in pairs(new.cols.all) do 
    if col1.nump then table.sort(col1.has) end end
  return new end

function data(data1,row1)
  if   data1.cols
  then cols(data1.cols, push(data1.rows, row1).cells)
  else data1.cols = COLS(row1.cells) end end

function clone(data1,rows,    data2)
  data2 = DATA({ROW(data1.cols.names)})
  for _,row1 in pairs(rows or {} ) do data(data2,row1) end
  return data2 end

function stats(data1,  fun,cols1,nDigits,    t)
  t = {N = #data1.rows}
  for _,col1 in pairs(cols1 or data1.cols.y) do
    t[col1.txt] = ooo((fun or mid)(col1), nDigits) end
  return t end
--------- --------- --------- --------- --------- --------- -----
function aha(col1, x,y)
  if     x=="?" and y=="?" then return 1
  elseif not col1.nump
  then   return x==y and 0 or 1
  else   x,y = norm(col1,x), norm(col1,y)
         if x=="?" then x = y<.5 and 1 or 0 end
         if y=="?" then y = x<.5 and 1 or 0 end
         return math.abs(x - y) end end

function minkowski(data1,row1,row2,      n,d)
  n,d = 0,0
  for _,col1 in pairs(data1.cols.y) do
    n = n + 1
    d = d + aha(col1,row1.cells[col1.at],row2.cells[col1.at])^the.p end
  return (d/n) ^ (1/the.p) end

function neighbors(data1,row1,rows,     fun)
  fun = function(row2) return minkowski(data1,row1,row2) end
  return keysort(rows or data1.rows, fun) end
--------- --------- --------- --------- --------- --------- ----
function d2h(data1,row1,       n,d)
  row1 = y(row1)
  n,d = 0,0
  for _,col1 in pairs(data1.cols.y) do
    n = n + 1
    d = d + (col1.heaven - norm(col1, at(row1,col1)))^2  end
  return (d/n) ^ (1/the.p) end

function corners(data1,rows,sortp,a,  b,far,row1,row2)
  far = (#rows*the.Far)//1 
  a   = a or neighbors(data1, any(rows), rows)[far]
  b   = neighbors(data1, a, rows)[far] 
  if sortp and d2h(data1,b) < d2h(data1,a) then a,b=b,a end
  return a, b, minkowski(data1,a,b) end

function half(data1,rows,sortp,b4,    a,b,C,d,cos,as,bs)
  a,b,C= corners(data1,many(rows,min(the.Half,#rows)),sortp,b4) 
  d    = function(r1,r2) return minkowski(data1,r1,r2) end
  cos  = function(r) return (d(r,a)^2+ C^2 - d(r,b)^2)/(2*C) end
  as,bs= {},{}
  for n,row1 in pairs(keysort(rows,cos)) do 
    push(n <=(#rows)//2 and as or bs, row1) end
  return as,bs,a,b,C,minkowski(data1,a,bs[1])  end
--------- --------- --------- --------- --------- --------- -----
fmt=string.format
function sort(t,fun) table.sort(t,fun); return t end

function per(t,p) return t[p*#t//1] end

function push(t,x) t[1+#t]=x; return x end

function stdev(t)  return (per(t,.9) - per(t,.1))/2.58 end
function median(t) return per(t,.5) end

function ent(t,     e,N)
  N=0; for _,n in pairs(t) do N = N + n end
  e=0; for _,n in pairs(t) do e = e - n/N*math.log(n/N,2) end
  return e end

function mode(t,     most,mode)
  most=0
  for k,v in pairs(t) do if v > most then mode,most=k,v end end
  return most end

function oo(t) print(o(t)); return t end
function o(t,          u)
  if type(t) ~= "table" then return ooo(t) end
  u={}; for k,v in pairs(t) do 
          u[1+#u]= #t==0 and fmt(":%s %s",k,o(v)) or o(v) end
  return "{"..table.concat(#t==0 and sort(u) or u," ").."}" end

function ooo(x,  digits,    mult)
  if type(x) ~= "number"   then return tostring(x) end
  if type(x) == "function" then return "()" end
  if math.floor(x) == x    then return x end
  mult = 10^(digits or 0)
  return math.floor(x * mult + 0.5) / mult end

function make(s,    sym)
  function sym(s) return s=="true" or (s~="false" and s) end
  return math.tointeger(s) or tonumber(s) or 
          sym(s:match'^%s*(.*%S)' or '') end

function makes(s,     t)
  t={}; for x in s:gmatch("([^,]+)") do 
          t[1+#t]=make(x) end; return t end

function csv(sFilename,     src)
  src = io.input(sFilename)
  return function(     s)
    s = io.read()
    if s then return makes(s) else io.close(src) end end end

rseed = 937162211
function rint(nlo,nhi) return math.floor(0.5 + rand(nlo,nhi))  end
function rand(nlo,nhi)
  nlo,nhi = nlo or 0, nhi or 1
  rseed   = (16807 * rseed) % 2147483647
  return nlo + (nhi - nlo) * rseed / 2147483647 end

function any(t) return t[rint(1,#t)] end

function keysort(t,fun,      u,w)
  u={}; for k,v in pairs(t) do push(u, {x=v, y=fun(v)}) end
  table.sort(u, function(a,b) return a.y < b.y end)
  w={}; for k,v in pairs(t) do push(w, v.x) end
  return w end
--------- --------- --------- --------- --------- --------- -----
local eg={}
function eg.csv() for t in csv(the.data) do 
  print(#t, type(t[1]), o(t)) end end

function eg.data(     d)
  d = DATA(the.data)
  oo(stats(d)) end 

function main()
  for _,com in pairs(arg) do
    if eg[com] then
      rseed = the.seed
      print("==> ".. com)
      if eg[com]()==false then 
        print("❌ FAIL : "..  com) end end end 
  for k,v in pairs(_ENV) do 
    if not b4[k] then print("#W ?",k,type(v)) end end end

main()