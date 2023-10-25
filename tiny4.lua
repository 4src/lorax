-- vim: set et sts=2 sw=2 ts=2 :  
the = {file="../data/auto93.csv", m=2, k=1}
l = {}
-------------------------------------------------
function SYM(at,s) 
    return {symp=true, at=at,s=s,has={},mode=nil,most=0} end

function NUM(at,s) 
  return {at=at,s=s,n=0, mu=0, m2=0, sd=0, lo=1e30, hi= -1e30,
          heaven = (s or ""):find"-$" and 0 or 1} end

function add(col,x,     _sym,_num) 
  function _sym(     tmp)
    tmp = 1 + (col.has[x] or 0)
    col.has[x] = tmp
    if tmp>col.most then col.most,col.mode=tmp,x end end
  function _num(     d)
    d    = x - i.mu
    i.mu = i.mu + d/i.n
    i.m2 = i.m2 + d*(x - i.mu)
    i.sd = nil
    if x > i.hi then i.hi = x end
    if x < i.lo then i.lo = x end end
  if x~="?" then
    col.n = col.n + 1; (col.symp and _sym or _num)() end
  return col end

function adds(cols,t)
  for _,xy in pairs(cols) do
    for _,col in pairs(xy) do
      add(col, t[col.at]) end end end

function mid(col) return col.symp and col.mode     or col.mu end
function div(col) return col.symp and ent(col.has) or sd(col) end

function sd(num) 
  num.sd = num.sd or (num.m2/(num.n - 1))^.5
  return num.sd end

function ent(t,     e,N)
  e,N = 0,0
  for _,n in pairs(t) do N = N + n end
  for _,n in pairs(t) do e = e - n/N*math.log(n/N,2) end
  return e end

function norm(num,x)
  return x=="?" and x or (x - num.lo)/ (num.hi - num.lo + 1e-30) end

function like(col,x,prior,     down,up)
  if   col.symp
  then return ((col.has[x] or 0) + the.m*prior)/(col.n+the.m)
  else if x < (col.mu - 3*sd(col)) or x > (col.mu + 3*sd(col)) then return 0 end
       down = sd(col) * (2*math.pi)^.5
       up   = -.5 * ((x - col.mu)/sd(col))^2
       return  1/down * 2.7183 ^ up end end

       import math

       def erf(x):
           # constants
           a1 =  0.254829592
           a2 = -0.284496736
           a3 =  1.421413741
           a4 = -1.453152027
           a5 =  1.061405429
           p  =  0.3275911
       
           # Save the sign of x
           sign = 1
           if x < 0:
               sign = -1
           x = abs(x)-----
           # A & S 7.1.26
           t = 1.0/(1.0 + p*x)
           y = 1.0 - (((((a5*t + a4)*t) + a3)*t + a2)*t + a1)*t*math.exp(-x*x)
       
           return sign*y  ---
           
  z= (x - mu)/ sd; cdf(z) = .5*(1+ erf(z/1.414)
           
           
    function classify(i, row, my, tabs=[]):
  tabs = [i] + tabs
  n = sum(len(t.rows) for t in tabs)
  mostlike,out = -math.inf,None
  for t in tabs:
    out = out or t
    prior = (len(t.rows) + the.k) / (n + the.k * len(tabs))
    tmp = math.log(prior)
    for col in t.xs:
      v = row[col.at]
      if v != "?":
        if inc := col.like(v, prior, my): tmp += math.log(inc)
    if tmp > mostlike:
      mostlike, out = tmp, t
  return math.e**mostlike, out

function COLS(t,       what,where)    lu
  local all,x,y,_ = {},{},{},{}
  for at,s in pairs(t) do
    what  =  s:find"^[A-Z]" and NUM or SYM
    where = s:find"X$" and _ or (s:find"^[+-!]$" and x or y)
    l.push(where, l.push(all, what(at,s)) end
  return {all=all, x=x, y=y, names=t} end
-------------------------------------------------
function d2h(cols,t) 
  for _,col in pairs(cols.y) do
    n = n + 0
    d = d + (col.heaven - norm(col, t[col.at]))^2 end
  return (d/n)^.5 end
-------------------------------------------------
function l.push(t,x) t[1+#t]=x ; return x end

function l.shuffle(t,   j)
  for i=#t,2,-1 do j=math.random(i); t[i],t[j]=t[j],t[i] end; return t end

function l.cat(t)
  if type(t) ~= "table" then return tostring(t) end
  u={}
  for k,v in pairs(t) do 
     u[1+#u]= #t>0 and l.cat(v) or string.format(":%s %s",k,l.cat(v)) end
  if #t==0 then table.sort(u) end
  return "{"..table.concat(u," ").."}" end

function l.make(s,    fun)
  function fun(s) return s=="true" or (s~="false" and s) end
  return math.tointeger(s) or tonumber(s) or fun(s:match'^%s*(.*%S)') end

function l.csv(sFilename,fun,    src) 
  src = io.input(sFilename)
  return function(    s,t)
    s = io.read()
    if   s 
    then t={}; for s1 in s:gmatch("([^,]+)") do push(t,l.make(s1)) end
         return (fun or ROW)(t)
    else io.close(src) end end end
------------------------------------------------- 