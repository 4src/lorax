local l    = require"lib"
local the  = {file="data/auto93.csv",p=2, seed=937162211,go="all"}

local push = l.lst.push
local m,o,oo,sorted = l.mathx, l.str.o, l.str.oo,l.sort.sorted
local rnd,any= m.rnd,l.rand.any
local kap = l.lst.kap
local lt = l.sort.lt
local csv = l.str.csv

local aha,at,clone,cols,col,data
local div,mid,minkowski,norm,ok,stats

local COLS,COL,DATA,NUM,ROW,SYM
--------- --------- --------- --------- --------- --------- -----
function ROW(t)   return {ako="ROW", cells=t, w=1} end

function at(row1,col1) return row1.cells[col1.at] end
--------- --------- --------- --------- --------- --------- -----
function SYM(n,s) return {ako="SYM", at=n,txt=s,has={}} end
function NUM(n,s)
  return {ako="NUM", at=n, txt=s, _has={}, ready=false,
          heaven= (s or ""):find"-$" and 0 or 1} end

function COL(n,s) return (s:find"^[A-Z]" and NUM or SYM)(n,s) end

function col(col1,x)
  if     x=="?" then return x
  elseif col1.ako == "SYM"
  then   col1.has[x] = 1 + (col1.has[x] or 0)
  else   push(col1._has,x)
         col1.ready = false end end

function ok(col1)
  if   col1.ako=="NUM" and not col1.ready
  then table.sort(col1._has)
       col1.ready = true end
  return col1 end

function mid(col1)
  if   col1.ako=="NUM"
  then return m.median(ok(col1)._has)
  else return m.mode(col1.has) end end

function div(col1)
  if   col1.ako=="NUM"
  then return m.stdev(ok(col1)._has)
  else return m.ent(col1.has) end end

function norm(col1,x,      t)
  if   x=="?" or col1.ako=="SYM"
  then return x
  else t = ok(col1)._has
       return (x- t[1])/(t[#t] - t[1] + 1E-30) end end
--------- --------- --------- --------- --------- --------- -----
function COLS(t,     all,x,y,col1)
  all,x,y = {},{},{} 
  for n,s in pairs(t) do
    col1 = push(all, COL(n,s))
    if not s:find"X$" then
      push(s:find"[!+-]$" and y or x, col1) end end
  return {ako="COLS", all=all, x=x, y=y, names=t} end

function cols(cols1,row1,     x)
  for _,xy in pairs{cols1.x, cols1.y} do
    for _,col1 in pairs(xy) do 
      col(col1, at(row1,col1)) end end end
--------- --------- --------- --------- --------- --------- -----
function DATA(src,     data1)
  data1  = {ako="DATA", rows={}, cols=nil}
  if   type(src)=="string"
  then for t      in csv(src)         do data(data1, ROW(t)) end
  else for _,row1 in pairs(src or {}) do data(data1, row1)   end
  end
  return data1 end

function data(data1,row1)
  if   data1.cols
  then cols(data1.cols, push(data1.rows,row1))
  else data1.cols = COLS(row1.cells) end end

function clone(data1,rows,    data2) 
  data2 = DATA({ROW(data1.cols.names)})
  for _,row1 in pairs(rows or {} ) do data(data2,row1) end
  return data2 end

function stats(data1,  fun,cols1,nDigits,    t)
  t = {N = #data1.rows}
  for _,col1 in pairs(cols1 or data1.cols.y) do
    t[col1.txt] = rnd((fun or mid)(col1), nDigits) end
  return t end
--------- --------- --------- --------- --------- --------- -----
function minkowski(data1,row1,row2,      n,d)
  n,d = 0,0
  for _,col1 in pairs(data1.cols.y) do
    n = n + 1
    d = d + aha(col1, at(row1,col1), at(row2,col1))^the.p end
  return (d/n) ^ (1/the.p) end

 function aha(col1, x,y)
  if     x=="?" and y=="?" then return 1
  elseif col1.ako=="SYM"
  then   return x==y and 0 or 1
  else   x,y = norm(col1,x), norm(col1,y)
         if x=="?" then x = y<.5 and 1 or 0 end
         if y=="?" then y = x<.5 and 1 or 0 end
         return math.abs(x - y) end end
--------- --------- --------- --------- --------- --------- -----
local eg = {}
function eg.fails() return false end

function eg.data(      d)
  d=DATA(the.file); oo(d.cols["y"][1])
  return #d.rows==398 end

function eg.ent(s)
  s=SYM()
  for _,x in pairs{1,1,1,1,2,2,3} do col(s,x) end
  return 1.37< m.ent(s.has) and m.ent(s.has)< 1.38 end

function eg.stats(     d)
  d=DATA(the.file)
  print("mid",o(stats(d)))
  print("div",o(stats(d,div,d.cols["x"]))) end

function eg.clone(      d1)
  d1=DATA(the.file)
  print("original", o(stats(d1)))
  print("cloned  ", o(stats(clone(d1,  d1.rows)))) end

function eg.dist(     t,r1,r2,d)
  t,d={},DATA(the.file); 
  for i=1,20 do 
    r1,r2 = any(d.rows),  any(d.rows) 
    push(t, rnd(minkowski(d, r1, r2),2)) end 
  oo(sorted(t))  end
--------- --------- --------- --------- --------- --------- ----
local function egs(     tmp,fails)
  the   = l.str.cli(the)
  tmp   = kap(eg,function(key,fun) return {key=key,fun=fun} end)
  fails = 0
  for _,one in pairs(sorted(tmp, lt"key")) do
    if the.go==one.key or the.go=="all" then
      l.rand.seed = the.seed
      if one.fun()==false then
        fails = fails + 1
        print("❌ FAIL : ".. one.key) end end end
  l.rogues()
  os.exit(fails - 1) end

egs()