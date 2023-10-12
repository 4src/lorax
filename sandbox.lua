local l    = require"lib"
local the  = {file="data/auto93.csv",p=2}
local push = l.lst.push
local m,o,oo,sorted = l.mathx, l.str.o, l.str.oo,l.sort.sorted
local aha,at,COLS,cols,COL,col,DATA,data
local div,has,mid,minkowski,NUM,norm,ROW,stats,SYM
local rnd,any= m.rnd,l.rand.any 
local csv = l.str.csv
--------- --------- --------- --------- --------- --------- -----
function ROW(t)   return {a="ROW", cells=t, w=1} end

function at(row1,col1) return row1.cells[col1.at] end
--------- --------- --------- --------- --------- --------- -----
function SYM(n,s) return {a="SYM", at=n,txt=s,has={}} end
function NUM(n,s) 
  return {a="NUM", at=n,txt=s, _has={}, ok=false,
          heaven= (s or ""):find"-$" and 0 or 1} end

function COL(n,s) return (s:find"^[A-Z]" and NUM or SYM)(n,s) end

function col(col1,x)
  if x=="?" then return x end
  if   "SYM"==col1.a 
  then col1.has[x] = 1+(col1.has[x] or 0) 
  else push(col1._has,x)
       col1.ok = false end end
  
function has(num1)
  if not num1.ok then table.sort(num1._has) end
  num1.ok = true
  return num1._has end

function mid(col1)
  if   "NUM"==col1.a 
  then return m.median(has(col1)) 
  else return m.mode(col1.has) end end

function div(col1)
  if   "NUM"==col1.a 
  then return m.stdev(has(col1)) 
  else return m.entropy(col1.has) end end

function norm(num1,x,      t)
  t = has(num1) 
  return x=="?" and x or (x- t[1])/(t[#t] - t[1] + 1E-30) end

function aha(col1, x,y)
  if x=="?" and y=="?" then return 1 end
  if   "SYM"==col1.a
  then return x==y and 0 or 1
  else x,y = norm(col1,x), norm(col1,y)
       if x=="?" then x = y<.5 and 1 or 0 end
       if y=="?" then y = x<.5 and 1 or 0 end
       return math.abs(x - y) end end
--------- --------- --------- --------- --------- --------- -----
function COLS(t,     all,x,y,col1)
  all,x,y = {},{},{} 
  for n,s in pairs(t) do
    col1 = push(all, COL(n,s))
    if not s:find"X$" then
      push(s:find"[!+-]$" and y or x, col1) end end
  return {a="COLS", all=all, x=x, y=y, names=t} end

function cols(cols1,row1,     x)
  for _,xy in pairs{cols1.x, cols1.y} do
    for _,col1 in pairs(xy) do 
      col(col1, at(row1,col1)) end end
  return row1 end
--------- --------- --------- --------- --------- --------- -----
function DATA(src,      data1)
  data1 = {a="DATA", rows={}, cols=nil} 
  if   type(src)=="string" 
  then csv(src, function(t) data(data1, ROW(t)) end) 
  else for _,row1 in pairs(src or {}) do data(data1, row1) end 
  end
  return data1 end

function data(data1,row1)
  if   data1.cols 
  then push(data1.rows, cols(data1.cols, row1)) 
  else data1.cols = COLS(row1.cells) end end

function stats(data1,  fun,nDigits,cols1,t)
  t = {N=#data1.rows}
  for _,col1 in pairs(cols1 or data1.cols.y) do
    t[col1.txt] = rnd((fun or mid)(col1), nDigits) end
  return t end

function minkowski(data1,row1,row2,      n,d)
  n,d = 0,0
  for _,col1 in pairs(data1.cols.y) do  
    n= n + 1
    d= d + aha(col1, at(row1,col1), at(row2,col1))^the.p end
  return (d/n) ^ (1/the.p) end
--------- --------- --------- --------- --------- --------- -----
local function egs(    data1,r1,r2,t)
  data1=DATA(the.file)
  oo(data1.cols.y[1])
  oo(stats(data1)) 
  t={}
  for i=1,50 do 
     r1,r2 = any(data1.rows),  any(data1.rows) 
     push(t, rnd(minkowski(data1, r1, r2),2)) end 
  oo(sorted(t)) end 

egs()
l.rogues()