local l={}
l.seed = 937162211

function l.rint(nlo,nhi) return math.floor(0.5 + l.rand(nlo,nhi)) end

function l.rand(nlo,nhi)
  nlo,nhi   = nlo or 0, nhi or 1
  l.seed = (16807 * l.seed) % 2147483647
  return nlo + (nhi-nlo) * l.seed / 2147483647 end

function l.any(t) return t[l.rint(1,#t)] end

function l.many(t,n) 
  u={}; for i=1,(n or #t) do u[1+#u] = l.any(t) end 
  return u end

return l
