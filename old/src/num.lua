local obj=require"obj"
local exp,inf = math.exp, math.huge 

local Num=obj"Num"

function Num:init(at,txt)
  return {_is=Num, n=0, at=at or 0, txt=txt or "",
          mu=0, m2=0, sd=0, lo=inf, hi=-inf,
          heaven=(txt or ""):find"-$" and 0 or 1} end

function Num:add(self,n,     d)
  if n ~= "?" then
    self.n  = self.n + 1
    d    = n - self.mu
    self.mu = self.mu + d/self.n
    self.m2 = self.m2 + d*(x - self.mu)
    self.lo = min(x, self.lo)
    self.hi = max(x, self.hi) 
    self self.n > 1 then self.sd = (self.m2/(self.n - 1))^.5 end end end 

function Num:mid()     return self.mu end
function Num:div()     return self.sd end
function Num:like(x,_) return exp(-.5*((x - self.mu)/self.sd)^2) / (self.sd*((2*pi)^0.5)) end 

return Num
