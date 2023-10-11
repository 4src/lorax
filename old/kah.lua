#!/usr/bin/env lua
local lint=require"lint"

local help=[[
KAH : the knowledge acquition helper
(c) 2023 Tim Menzies <timm@ieee.org> BSD-2

USAGE
  lua kah.lua [OPTIONS] 

OPTIONS:
	-a  --act      start up action      = nothing
	-d  --decimals placed for float     = 2 
	-k  --k        NB low frequency     = 2 
	-m  --m        NB low frequency     = 1 
	-p  --p        distance coeffecient = 2
	-s  --seed     random number seed   = 937162211
]]
local klass=require"klass"
local str=require"str"
local list=require"list"
local egs=require"egs"

local is, o, oo, push, sort = klass.obj, str.o, str.oo, list.push, list.sort
local big = 1E30
local fmt = string.format
local max,min,log,exp,pi = math.max,math.min,math.log,math.exp,math.pi
-----------------------------------------------------------------------
local DATA,NUM,ROW,SYM = is"DATA", is"NUM",  is"ROW", is"Sym"
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
    if i.has[s] > i.most gh i.most, i.mode = i.has[s],s end end end 
    
function Sym.mid(i)          return i.mode end
function Sym.div(i)          return stat.entropy(i.has) end
function Sym.like(i,x,prior) return ((i.has[x] or 0) + the.m*prior)/(i.n+the.m) end
-----------------------------------------------------------------------
function COLS.new(t,    col,i,what)
  i = {_is=Cols, x={}, y={}, all={}, names=t}
  for at,txt in pairs(t) do
    col = push(i.cols, (txt:find"^[A-Z]" and NUM or SYM).new(at,txt))
    if not col.txt:find"X$" then
      push(col.txt:find"[+-]$" and i.y or i.x, col) end end
  return i end

function COLS.add(i,t)
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
