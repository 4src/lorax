local l=require"lib"
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

local aha,any,csv=l.aha,l.any,l.csv
local ent,fmt,keysort,make  = l.ent,l.fmt,l.keysort,l.make
local main,median,mode       = l.main,l.median,l.mode
local o,oo,ooo               = l.o,l.oo,l.ooo
local per,push,rand,rint     = l.per,l.push,l.rand,l.rint
local rseed,sort,stats,stdev = l.rseed,l.sort,l.stats,l.stdev
--------- --------- --------- --------- --------- --------- -----
local ROW,y

function ROW(t)   return {cells=t, cost=0} end

function y(row1) row1.cost = 1 ; return row1 end
--------- --------- --------- --------- --------- --------- -----
local SYM,NUM,COL,col,mid,div,norm

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

for k,v in pairs(l.locals()) do print(k,v) end

return l.locals() 
