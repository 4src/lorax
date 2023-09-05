local stat=require"stat"
local obj=require"obj"

local Sym=obj"Sym"

function Sym:init(at,txt)
  return {n=0, at=at or 0, txt=txt or "",has ={}, most=0, mode=None} end

function Sym:add(s,     d)
  if s ~= "?" then
    self.n = self.n + 1
    self.has[s] = (self.has[s] or 0) + 1
    if self.has[s] > self.most then self.most, self.mode = self.has[s],s end end end 
    
function Sym:mid()         return self.mode end
function Sym:div()         return stat.entropy(self.has) end
function Sym:like(x,prior) return ((self.has[x] or 0) + the.m*prior)/(self.n+the.m) end

return Sym
