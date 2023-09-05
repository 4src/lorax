local rand={}
rand.seed = 937162211

function rand.rint(nlo,nhi) return math.floor(0.5 + rand.rand(nlo,nhi)) end

function rand.rand(nlo,nhi)
  nlo,nhi   = nlo or 0, nhi or 1
  rand.seed = (16807 * rand.seed) % 2147483647
  return nlo + (nhi-nlo) * rand.seed / 2147483647 end

function rand.any(t) return t[rand.rint(1,#t)] end

function rand.many(t,n) 
  u={}; for i=1,(n or #t) do u[1+#u] = rand.any(t) end 
  return u end

return rand
