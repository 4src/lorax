local l    = require"lib"
local the  = {file="data/auto93.csv"}
local push = l.lst.push
local o,oo = l.str.o, l.str.oo
local COLS,cols,COL,col,DATA,data,div,has,mid,NUM,ROW,stats,SYM
--------- --------- --------- --------- --------- --------- -----
function ROW(t)   return {cells=t, w=1} end
--------- --------- --------- --------- --------- --------- -----
function SYM(n,s) return {is=SYM,at=n,txt=s,has={}} end
function NUM(n,s) return {is=NUM,at=n,txt=s,ok=false,has={}} end

function COL(n,s) return (s:find"^[A-Z]" and NUM or SYM)(n,s) end

function col(col1,x)
  if SYM==col1.is then col1.has[x] = 1+(col1.has[x] or 0) else
    push(col1.has,x)
    col1.ok = false end end
  
function has(col1)
  if not col1.ok then table.sort(col1.has) end
  col1.ok = true
  return col1.has end

function mid(col1)
  if NUM==col1.is then return m.median(has(col1.has)) else
                       return m.mode(col1.has) end end

function div(col1)
  if NUM==col1.is then return m.stdev(has(col1.has)) else
                       return m.entropy(col1.has) end end
--------- --------- --------- --------- --------- --------- -----
function COLS(t,     all,x,y,col1)
  all,x,y = {},{},{}
  for n,s in pairs(t) do
    col1 = push(all, COL(n,s))
    if not s:find"X$" then
      push(s:find"[!-+]$" and y or x, col1) end end
  return {is=COLS, all=all, x=x, y=y, names=t} end

function cols(cols1,row)
  for _,xy in pairs{cols1.x, cols1.y} do
    for _,col1 in pairs(xy) do
      x = row.cells[col1.at]
      if x ~= "?" then col(col1, x) end end end
  return row end
--------- --------- --------- --------- --------- --------- -----
function DATA(src,      data1)
  data1 = {rows={}, cols=nil} 
  if   type(src)=="string" 
  then l.str.csv(src, function(t) data(data1, ROW(t)) end) 
  else for _,row in pairs(src or {}) do data(data1, row) end 
  end
  return data1 end

function data(data1,row)
  if data1.cols then push(data1.rows, col(data1.cols, row)) else 
    data1.cols = COLS(row.cells) end end

function stats(data1,  fun,nDigits,cols1)
  t = {N=#data1.rows}
  for _,col1 in pairs(cols1 or data1.cols.y) do
    t[col1.txt] = l.mathx.rnd((fun or mid)(col1), nDigits) end
  return t end
--------- --------- --------- --------- --------- --------- -----
DATA(the.file)
l.rogues()