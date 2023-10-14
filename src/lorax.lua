local l    = require"lib"
local the  = {file="../data/auto93.csv",p=2, Far=.95, 
              seed=937162211, go="all", Half=256}

local push,csv      = l.lst.push, l.str.csv
local m,o,oo,sorted = l.mathx, l.str.o, l.str.oo,l.sort.sorted
local keysort,lt    = l.sort.keysort,l.sort.lt
local show,any,many  = m.show, l.rand.any, l.rand.many
local kap,slice     = l.lst.kap,l.lst.slice
local min           = math.min

local aha,at,clone,cols,col,corners,data,d2h
local div,half,mid,minkowski,neighbors,norm,ok,stats,branch

local COLS,COL,DATA,NUM,ROW,SYM
--------- --------- --------- --------- --------- --------- -----
function ROW(t)   return {ako="ROW", cells=t, heaven=1,cost=0} end

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
  else   push(col1._has, x)
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
       return (x - t[1])/(t[#t] - t[1] + 1E-30) end end
--------- --------- --------- --------- --------- --------- -----
function COLS(t)
  local all,x,y,ignore,also = {},{},{},{},nil
  for n,s in pairs(t) do
    also = s:find"X$" and ignore or (s:find"[!+-]$" and y or x)
		also[n] = push(all, COL(n,s)) end
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
    t[col1.txt] = show((fun or mid)(col1), nDigits) end
  return t end
--------- --------- --------- --------- --------- --------- ----
function aha(col1, x,y)
  if     x=="?" and y=="?" then return 1
  elseif col1.ako=="SYM"
  then   return x==y and 0 or 1
  else   x,y = norm(col1,x), norm(col1,y)
         if x=="?" then x = y<.5 and 1 or 0 end
         if y=="?" then y = x<.5 and 1 or 0 end
         return math.abs(x - y) end end

function minkowski(data1,row1,row2,      n,d)
  n,d = 0,0
  for _,col1 in pairs(data1.cols.y) do
    n = n + 1
    d = d + aha(col1, at(row1,col1), at(row2,col1))^the.p end
  return (d/n) ^ (1/the.p) end

function neighbors(data1,row1,rows,     fun)
  fun = function(row2) return minkowski(data1,row1,row2) end
  return keysort(rows or data1.rows, fun) end
--------- --------- --------- --------- --------- --------- ----
function d2h(data1,row1,       n,d)
  row1.cost = 1
  n,d = 0,0
  for _,col1 in pairs(data1.cols.y) do
    n = n + 1
    d = d + (col1.heaven - norm(col1, at(row1,col1)))^2  end
  return (d/n) ^ (1/the.p) end

  function corners(data1,rows,sortp,a,  b,far,row1,row2)
  far = (#rows*the.Far)//1
  print(#rows, far)
  a   = a or neighbors(data1, any(rows), rows)[far]
  b   = neighbors(data1, a, rows)[far]
  print("a",d2h(data1,a),"b", d2h(data1,b)) 
  return a, b, minkowski(data1,a,b) end

function half(data1,rows,sortp,b4,    a,b,C,d,cos,as,bs)
  a,b,C= corners(data1,many(rows,min(the.Half,#rows)),sortp,b4) 
  d    = function(r1,r2) return minkowski(data1,r1,r2) end
  cos  = function(r) return (d(r,a)^2+ C^2 - d(r,b)^2)/(2*C) end
  as,bs= {},{}
  for n,row1 in pairs(keysort(rows,cos)) do 
    push(n <=(#rows)//2 and as or bs, row1) end
  return as,bs,a,b,C,minkowski(data1, a,bs[1])  end

function branch(data1, sortp,      _,rest,_branch)    
  rest = {}
  function _branch(data2,  above,    left,lefts,rights)
    if #(data2.rows) > 2* (#(data1.rows))^.5 then
      lefts,rights,left,_,_,_ =
                           half(data1, data2.rows, sortp, above)
      for _,row1 in pairs(rights) do push(rest,row1) end
      return _branch(clone(data1,lefts),left)
    else
      return data2.rows, rest end end
  return _branch(data1) end
--------- --------- --------- --------- --------- --------- -----
local eg = {}
function eg.fails() return false end

function eg.sym(s)
  s=SYM()
  for _,x in pairs{1,1,1,1,2,2,3} do col(s,x) end
  return 1.37< m.ent(s.has) and m.ent(s.has)< 1.38 end

function eg.num(     n,r,sd,m)
  n,r = NUM(), l.rand.rand
  for i=1,100 do col(n, i) end
  m,sd = mid(n), div(n) 
  return 49 < m and m < 51 and 30 < sd and sd < 32 end

function eg.csv(      n)
  n=0; for t in csv(the.file) do n = n + #t end 
  return n ==399*8 end  
    
function eg.data(      d)
  d=DATA(the.file); oo(d.cols["y"][1])
  return #d.rows==398 end

function eg.stats(     d)
  d=DATA(the.file)
  print("mid",o(stats(d)))
  print("div",o(stats(d,div,d.cols["x"]))) end

function eg.clone(      d1,s1,s2,good)
  d1  = DATA(the.file)
  s1  = stats(d1)
  s2  = stats(clone(d1,  d1.rows))
  good= true
  for k,v in pairs(s1) do good = good and v == s2[k] end 
  print("original", o(s1))
  print("cloned  ", o(s2))
  return good end

function eg.dist(     t,r1,r2,d)
  t,d={},DATA(the.file); 
  for i=1,20 do 
    r1,r2 = any(d.rows),  any(d.rows) 
    push(t, show(minkowski(d, r1, r2),2)) end 
  oo(sorted(t)) end

function eg.heaven(     t,r1,r2,d)
  t,d={},DATA(the.file); 
  for i=1,20 do 
    r1  = any(d.rows)
    push(t, show(d2h(d,r1),3)) end
  oo(sorted(t)) end

function eg.heavens(     t,d,n)
  t,d={},DATA(the.file)
  n = (#d.rows) ^.5
  t = keysort(d.rows, function(r) return d2h(d,r) end) 
  print("best", o(stats(clone(d, slice(t,1,n)))))
  print("worst", o(stats(clone(d, slice(t,-n))))) 
end

function eg.around(     t,d,n)
  d = DATA(the.file)
  t = neighbors(d, d.rows[1], d.rows)
  for i = 1, #t,50 do
    print(i,show(minkowski(d,t[1],t[i]),2),
            o(d.rows[i].cells)) end end

function eg.neighbors(     t,d,n)
  d = DATA(the.file)
  t = neighbors(d, d.rows[1], d.rows)
  for i = 1, #t,50 do
    print(i,o(d.rows[i].cells),
            show(minkowski(d,t[1],t[i]),2)) end end

function eg.half(      _,d,as,bs)
  d = DATA(the.file)
  as,bs,_,_,_,_  = half(d,d.rows) 
  print(#as, #bs) end 

function eg.branch(      d,as,bs,t,u)
    d = DATA(the.file)
    t,u,_ = branch(d,true) 
    print("best",o(stats(clone(d,t))))
    print("rest",o(stats(clone(d,l.lst.slice(u,-30)))))
     end
--------- --------- --------- --------- --------- --------- ----
local function main(     fails)
  the   = l.str.cli(the)
  fails = 0
  for key,fun in l.lst.items(eg) do 
    if the.go== key or the.go=="all" then
      l.rand.seed = the.seed
      print(string.format("==> %s", key))
      if fun()==false then
        fails = fails + 1
        print("❌ FAIL : "..  key) end end end
  l.rogues()
  os.exit(fails - 1) end

if not  pcall(debug.getlocal,4,1)  then main() end

 