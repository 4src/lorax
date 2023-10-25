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

local o,oo,push  = l.o,l.oo,l.push
local SYM,NUM,DATA=l.obj"SYM", l.obj"NUM",  l.obj"DATA"
local ROW, COLS= l.obj"ROW", l.obj"COLS"
--------- --------- --------- --------- --------- --------- -----
local function COL(n,s)
  return ((s or ""):find"^[A-Z]" and NUM or SYM)(n,s) end

function SYM:new(n, s) return {at=n, txt=s, has={}} end
function NUM:new(n,s)  return {at=n, txt=s, has={}, nump=true,
                        ok=false,lo=1E30, hi=-1E30,
                        heaven=(s or ""):find"-$" and 0 or 1} end

function SYM:add(x)
  if x ~= "?" then self.has[x] = 1 + (self.has[x] or 0) end end

function NUM:add(x)
  if x ~= "?" then
    push(self.has, x); self.ok=false
    if x > self.hi then self.hi = x end
    if x < self.lo then self.lo = x end end end

function SYM:ok() return self end
function NUM:ok()
  if not self.ok then table.sort(self.has); self.ok=true end
  return self end

function SYM:mid() return l.mode(self:ok().has)   end
function NUM:mid() return l.median(self:ok().has) end

function SYM:div() return l.ent(self:ok().has)   end
function NUM:div() return l.stdev(self:ok().has) end

function SYM:norm(x) return x end
function NUM:norm(x)
  if x=="?" then return x end
  return (x - self.lo)/(self.hi - self.lo + 1E-30) end
--------- --------- --------- --------- --------- --------- -----
function COLS:new(t,      u,_)
  self.x,self.y,self.all,_ = {},{},{},{}
  for n,s in pairs(t) do
    u= s:find"X$" and _ or (s:find"[!+-]$" and self.y or self.x)
    u[n] = push(self.all, COL(n,s)) end end

function COLS:add(row) 
  for _,xy in pairs{self.x, self.y} do
    for _,col in pairs(xy) do 
      col:add(row.cells[col.at]) end end end
--------- --------- --------- --------- --------- --------- -----
function ROW:new(t) return {cells=t, cost=0} end

function ROW:evaluate() self.cost = 1; return self end
--------- --------- --------- --------- --------- --------- -----
function DATA:new(src)
  self.rows,self.cols ={},nil 
  if type(src) == "string"
  then for t     in l.csv(src)       do self:add(ROW(t))  end
  else for _,row in pairs(src or {}) do self:add(row) end end
end

function DATA:add(row)
  if   self.cols
  then self.cols:add(push(self.rows, row))
  else self.cols = COLS(row.cells) end end

function DATA:clone(rows,    data)
  data = DATA({ROW(self.cols.names)})
  for _,row in pairs(rows or {} ) do  data:add(row) end
  return data end

function DATA:stats(  fun,cols,nDigits,    t,get)
  function get(col)
    return getmetatable(col)[fun or "mid"](col) end
  t = {N = #data1.rows}
  for _,col in pairs(cols or self.cols.y) do
    t[col.txt] = o(get(col), nDigits) end
  return t end
--------- --------- --------- --------- --------- --------- -----
function SYM:dist(x,y) 
  return  x=="?" and y=="?" and 1 or (x==y and 0 or 1) end

function NUM:dist(x,y)
  if x=="?" and y=="?" then return 1  end
  x,y = self:norm(x), self:norm(y)
  if x=="?" then x = y<.5 and 1 or 0 end
  if y=="?" then y = x<.5 and 1 or 0 end 
  return math.abs(x - y) end 

function DATA:dist(row1,row2,      n,d)
  n,d = 0,0
  for _,col in pairs(self.cols.y) do
    n= n +1
    d= d + 
      col:dist(row1.cells[col.at],row2.cells[col.at])^the.p end
  return (d/n) ^ (1/the.p) end

function DATA:neighbors(row1,rows,     fun)
  fun = function(row2) return self:dist(row1,row2) end
  return l.keysort(rows or self.rows, fun) end
--------- --------- --------- --------- --------- --------- ----
function DATA:d2h(row,       n,d)
  row = row:evaluate()
  n,d = 0,0
  for _,col in pairs(self.cols.y) do
    n= n + 1
    d= d + (col.heaven - col:norm(row.cells[col.at]))^2 end
  return (d/n) ^ (1/the.p) end

function DATA:corners(rows,sortp,a)
  local b,far,row1,row2
  far = (#rows*the.Far)//1
  a   = a or self:neighbors(l.any(rows), rows)[far]
  b   = self:neighbors(a, rows)[far]
  if sortp and self:d2h(b) < self:d2h(a) then a,b=b,a end
  return a, b, self:dist(a,b) end

function DATA:half(rows,sortp,b4)
  local a,b,C,d,project,as,bs
  a,b,C= self:corners(
               l.many(rows,math.min(the.Half,#rows)),sortp,b4)     
  function project(r)
    return (self.dist(r,a)^2 + C^2 - self.dist(r,b)^2)/(2*C) end
  as,bs= {},{}
  for n,row1 in pairs(l.keysort(rows,project)) do
    push(n <=(#rows)//2 and as or bs, row1) end
  return as,bs,a,b,C,self:dist(a,bs[1])  end
--------- --------- --------- --------- --------- --------- ----
return { ROW=ROW, DATA=DATA, SYM=SYM, NUM=NUM,
         the=the, help=help}