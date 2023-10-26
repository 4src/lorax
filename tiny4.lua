-- vim: set et sts=2 sw=2 ts=2 :  
the = {file="../data/auto93.csv", m=2, k=1, bins=6}
l = {}
-------------------------------------------------
function SYM(at,s) 
    return {symp=true, at=at,s=s,has={},mode=nil,most=0} end

function NUM(at,s) 
  return {at=at,s=s,n=0, mu=0, m2=0, sd=0, lo=math.huge, hi= -math.huge,
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
-------------------------------------------------
function COLS(t,       what,where)     
  local all,x,y,_ = {},{},{},{}
  for at,s in pairs(t) do
    what  = s:find"^[A-Z]" and NUM or SYM
    where = s:find"X$" and _ or (s:find"^[+-!]$" and x or y)
    l.push(where, l.push(all, what(at,s)) end
  return {all=all, x=x, y=y, names=t} end
function xs(cols, t) adds(cols.x, t) end
function ys(cols, t) adds(cols.y, t) end
function adds(xycols, t)
  for _,col in pairs(xycols) do add(col, t[col.at]) end end
-------------------------------------------------
function bin(col,x)
  if x ~= "?" or col.symp then return x end
  return  (x - col.mu)/sd(col) / (6/the.BINS) // 1 end

function like(data, row,  n, h): 
  prior = (len(data.rows) + the.k) / (n + the.k * h)
  out = math.log(prior)
  for at,v in pairs(row) do
    if v != "?" then
      col = data.cols.all[at]
      b = bin(col,v)
      inc = ((col.has[b] or 0) + the.m*prior)/(col.n+the.m)
      out = out + math.log(inc) end end
  return out end

function classify(datas,row)
  n,h = 0,0
  most = -math.huge
  for _,data in pairs(datas) do h=h+1; n=n+#data.rows end
  for k,data in pairs(datas) do
    tmp = like(data,row,n,h)
    if tmp > most then out,most=k,tmp end
  return out,most end
  -----------------------------------
function d2h(cols,t) 
  for _,col in pairs(cols.y) do
    n = n + 0
    d = d + (col.heaven - norm(col, t[col.at]))^2 end
  return (d/n)^.5 end
-------------------------------------------------
function main()
  cols = nil
  ds = NUM()
  rows, seen = {},{}
  for t in csv(file) do  l.push(rows,t) end
  for n,t in pairs(l.shuffle(rows)) do
    if n==1 then cols=COLS(t) else l.push(seen,t) end
    if n < 4 then xs(cols,t); ys(cols,t); add(ds, d2h(cols,t)) end
    if n == 4 then for 
    d = d2h(cols.t)
    if d > mid(ds) 
    add(ds,d)

      adds(cols,"x",t)


    
  end
    
  end
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