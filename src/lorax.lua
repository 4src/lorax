local l=require"lib"
local o,oo,ooo,push  = l.o,l.oo,l.ooo,l.push
local the,help = l.settings[[

lorax: LORAX Optimizes and Renders AI eXplanations
(c) Tim Menzies <timm@ieee.org>, BSD-2 license

USAGE (examples):
  see eg.lua

OPTIONS:
  -b --bins   initial number of bins   = 16
  -C --Cohen  too small                = .35
  -f --file   csv data file            = ../data/auto93.csv
  -F --Far    how far to look          = .95
  -h --help   show help                = false
  -H --Half   where to find for far    = 256
  -m --min    min size                 = .5
  -p --p      distance coefficient     = 2
  -r --reuse  do npt reuse parent node = true
  -s --seed   random number seed       = 937162211]]

--------- --------- --------- --------- --------- --------- -----
local function SYM(n, s) return {at=n, txt=s, has={}} end
local function NUM(n,s) return {at=n, txt=s, has={}, nump=true,
                        ok=false,lo=1E30, hi=-1E30,
                        heaven=(s or ""):find"-$" and 0 or 1} end

local function COL(n,s)
  return ((s or ""):find"^[A-Z]" and NUM or SYM)(n,s) end

local function col(col1,x)
  if x ~= "?" then
    if col1.nump 
    then push(col1.has, x); col1.ok=false
         if x > col1.hi then col1.hi = x end
         if x < col1.lo then col1.lo = x end
    else col1.has[x] = 1 + (col1.has[x] or 0) end end end

local function ok(col1)
  if   col1.nump and not col1.ok
  then table.sort(col1.has); col1.ok=true end
  return col1 end

local function mid(col1)
  return col1.nump and l.median(ok(col1).has) or l.mode(col1.has) end

local function div(col1)
  return col1.nump and l.stdev(ok(col1).has) or l.ent(col1.has) end

local function norm(col1,x,      t)
  if   x=="?" or not col1.nump then return x else
    return (x - col1.lo)/(col1.hi - col1.lo + 1E-30) end end
--------- --------- --------- --------- --------- --------- -----
local function COLS(t,      also,x,y,num,all,_)
  x,y,all,_ = {},{},{},{}
  for n,s in pairs(t) do
    also = s:find"X$" and _ or (s:find"[!+-]$" and y or x)
    also[n] = push(all, COL(n,s)) end
  return {x=x, y=y, all=all, names=t} end

local function cols(cols1,xy,t)
  print(xy)
  for _,col1 in pairs(cols1[xy]) do col(col1, t[col1.at]) end end
--------- --------- --------- --------- --------- --------- -----
local function ROW(t) return {cells=t, cost=0} end

local function assess(data1,row1) 
  if row1.cost==0 then cols(data1,"y",row1.cells) end
  row1.cost = 1
  return row1 end
--------- --------- --------- --------- --------- --------- -----
local function data(data1,row1)
  if   data1.cols
  then cols(data1.cols, "x", push(data1.rows, row1).cells)
  else data1.cols = COLS(row1.cells) end end

local function DATA(src,    new)
  new = {rows={}, cols=nil}
  if type(src)=="string"
  then for t     in l.csv(src)       do data(new, ROW(t))  end
  else for _,row in pairs(src or {}) do data(new, row) end end 
  return new end

local function clone(data1,rows,    data2)
  data2 = DATA({ROW(data1.cols.names)})
  for _,row1 in pairs(rows or {} ) do data(data2,row1) end 
  return data2 end

local function stats(data1,  fun,cols1,nDigits,    t)
  for _,row1 in pairs(data1.rows) do assess(data1,row1) end
  t = {N = #data1.rows}
  for _,col1 in pairs(cols1 or data1.cols.y) do
    t[col1.txt] = ooo((fun or mid)(col1), nDigits) end
  return t end
--------- --------- --------- --------- --------- --------- -----
local function aha(col1, x,y)
  if     x=="?" and y=="?" then return 1
  elseif not col1.nump
  then   return x==y and 0 or 1
  else   x,y = norm(col1,x), norm(col1,y)
         if x=="?" then x = y<.5 and 1 or 0 end
         if y=="?" then y = x<.5 and 1 or 0 end
         return math.abs(x - y) end end

local function minkowski(data1,row1,row2,      n,d)
  n,d = 0,0
  for _,col1 in pairs(data1.cols.y) do
    n = n + 1
    d = d + aha(col1,row1.cells[col1.at],row2.cells[col1.at])^the.p end
  return (d/n) ^ (1/the.p) end

local function neighbors(data1,row1,rows,     fun)
  fun = function(row2) return minkowski(data1,row1,row2) end
  return l.keysort(rows or data1.rows, fun) end
--------- --------- --------- --------- --------- --------- ----
local function better(data1, row1,row2)
  row1,row2 = assess(row1), assess(row2)
  return d2h(data1,row1) < d2h(data1,row2) end

local function d2h(data1,row1,       n,d)
  row1 = assess(row1)
  n,d = 0,0
  for _,col1 in pairs(data1.cols.y) do
    n = n + 1
    d = d + (col1.heaven - norm(col1, row1.cells[col1.at])) ^2  end
  return (d/n) ^ (1/the.p) end

local function corners(data1,rows,sortp,a)
  local  b,far,row1,row2
  far = (#rows*the.Far)//1
  a   = a or neighbors(data1, l.any(rows), rows)[far]
  b   = neighbors(data1, a, rows)[far]
  if sortp and d2h(data1,b) < d2h(data1,a) then a,b=b,a end
  return a, b, minkowski(data1,a,b) end

local function half(data1,rows,sortp,b4)
  local a,b,C,d,cos,as,bs
  a,b,C= corners(data1,
                 l.many(rows,math.min(the.Half,#rows)),sortp,b4)
  d    = function(r1,r2) return minkowski(data1,r1,r2) end
  cos  = function(r) return (d(r,a)^2+ C^2 - d(r,b)^2)/(2*C) end
  as,bs= {},{}
  for n,row1 in pairs(keysort(rows,cos)) do
    push(n <=(#rows)//2 and as or bs, row1) end
  return as,bs,a,b,C,minkowski(data1,a,bs[1])  end
--------- --------- --------- --------- --------- --------- ----
return { ROW=ROW, DATA=DATA, SYM=SYM, NUM=NUM,
         col=col, mid=mid, div=div, norm=norm, stats=stats,
         minkowski=minkowski,aha=aha,
         clone=clone, the=the, help=help}
