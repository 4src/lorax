local rand={}
rand.seed = 937162211

function rand.rint(nlo,nhi) return floor(0.5 + rand.rand(nlo,nhi)) end

function rand.rand(nlo,nhi)
  nlo,nhi=nlo or 0, nhi or 1
  rand.seed = (16807 * rand.seed) % 2147483647
  return nlo + (nhi-nlo) * rand.seed / 2147483647 end

return rand
