local obj=require("klass").obj
local exp,inf = math.exp, math.huge 

local Num=obj"Num"

function Num.init(at,txt)
  return {_is=Num, n=0, at=at or 0, txt=txt or "",
          mu=0, m2=0, sd=0, lo=inf, hi=-inf,
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

return Num
