local l={}

function l.entropy(t,    e,n) 
  e,n = 0,0
  for _,m in pairs(t) do n = n + m end
  for _,m in pairs(t) do e = e - m/n * log(m/n,2) end
  return e end

function l.rnd(n,  nPlaces,     mult)
  mult = 10^(nPlaces or 2)
  return math.floor(n * mult + 0.5) / mult end

return l
