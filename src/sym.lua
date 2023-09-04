local stat=require"stat"
local obj=require("klass").obj

local Sym=obj"Sym"

function Sym.init(at,txt)
  return {_is=Sym, n=0, at=at or 0, txt=txt or "",has ={}, most=0, mode=None} end

function Sym.add(i,s,     d)
  if s ~= "?" then
    i.n = i.n + 1
    i.has[s] = (i.has[s] or 0) + 1
    if i.has[s] > i.most: i.most, i.mode = i.has[s],s end end end 
    
function Sym.mid(i)          return i.mode end
function Sym.div(i)          return stat.entropy(i.has) end
function Sym.like(i,x,prior) return ((i.has[x] or 0) + the.m*prior)/(i.n+the.m) end

return Sym
