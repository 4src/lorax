---@diagnostic disable: lowercase-global, undefined-field, undefined-global
the={data="../data/auto93.csv", p=2}
local cat,make,makes,csv
--------- --------- --------- --------- --------- --------- --------- --------- --------- ---------
function ROW(t,n)   return {cells=t, n=n or 1} end

function merges(data1,row1,row2,     t)
	t={}; for _,col1 in pairs(data1.cols.all) do
		    t[col1.at] = merge(col1,row1,row2) end
	return ROW(t, row1.n + row2.n) end

function merge(col1,row1,row2,     a,b,N)
	a,b,N = row1.cells[col1.at],row2.cells[col1.at], row1.n + row2.n
	if a=="?" and b=="?" then return "?" end
	if a=="?"            then return b end
	if b=="?"            then return a end
	return col1.sym and (rand() <= row1.n/N and a or b) or (a*row1.n + b*row2.n)/N end
--------- --------- --------- --------- --------- --------- --------- --------- --------- ---------
function NUM(n,s) return {at=n, txt=s, n=0, mu=0, m2=0, sd=0, lo=1E30, hi=-1E30} end
function SYM(n,s) return {at=n, txt=s, has={}, mode=nil, most=0, symp=true } end
function COL(n,s) return (s:find"^[A-Z]*" and NUM or SYM)(n,s) end

function col(col1,x,      _num,_sym)
  function _sym(     tmp)
    tmp =  1 + (col1.has[x] or 0)
    if tmp > col1.most then col1.most, col1.mode = tmp, x end
    col1.has[x] = tmp end
  function _num(      d)
    d       = x - col1.mu
    col1.mu = col1.mu + d/col1.n
    col1.m2 = col1.m2 + d*(x - col1.mu)
    if x < col1.lo then col1.lo = x end
    if x > col1.hi then col1.hi = x end
    if col1.n > 1  then col1.sd = (col1.m2/(col1.n - 1))^.5 end end
	if x ~= "?" then
	  col1.n = col1.n + 1
		return col1.symp and _sym() or _num() end end

function mid(col1) 
  return col1.symp and col1.mode     or col1.mu end

function div(col1) 
  return col1.symp and ent(col1.has) or col1.sd end

function norm(col1,x)
	if x=="?" then return x end
  return (x - col1.lo) / (col1.hi - col1.lo + 1E-30) end

function dist(col1, x,y)
	if x=="?" and y=="?" then return 1 end
	if col1.symp then return x==y and 0 or 1 else
		x,y = norm(col1, x), norm(col1, y)
		if x=="?" then x=y<.5 and 1 or 0 end
		if y=="?" then y=x<.5 and 1 or 0 end
		return math.abs(x-y) end end
--------- --------- --------- --------- --------- --------- --------- --------- --------- ---------
function COLS(t,     x,y,all,also,_)
	x,y,all,_ = {},{},{},{}
	for n,s in pairs(t) do
		also = s:find"X$" and _ or (s:find"[!+-]$" and y or x)
		push(also, push(all, COL(n,s))) end
	return {x=x, y=y, all=all, names=t} end

function cols(cols1, t)
	for _,xy in pairs{cols1.x, cols1.y} do
		for _,col1 in pairs(xy) do 
			col(col1, t[col1.at]) end end end
--------- --------- --------- --------- --------- --------- --------- --------- --------- ---------
function DATA(src)
	data1={rows={}, cols=nil}
	if   type(src)=="string" 
	then for      t in csv(src)       do data(data1,ROW(t)) end
  else for _,row1 in pairs(src or {}) do data(data1,row1)   end end
	return data1 end 

function data(data1,row1)
	if data1.cols then cols(data1.cols, push(data1.rows, row1).cells) else
	   data1.cols = COLS(row1.cells) end end

function stats(data1, what,cols,digits,t)
	t = {N = #data1.rows}
	for _,col1 in pairs(cols or data1.cols.y) do 
		   t[col1.txt] = show((what or mid)(col1),digits) end
	return t end

function dists(data1,row1,row2,     n,d)
	n,d = 0,0 
	for _,col1 in pairs(data1.cols.x) do
		n = n + 1
		d = d + gap(col1, row1.cells[col1.at], row2.cells[col1.at])^the.p end
	return (d/n) ^ (1/the.p) end

function neighbors(data1,row1,rows)
	return keysort(rows or data1.rows, function(row2) return dists(data1,row1,row2) end) end
--------- --------- --------- --------- --------- --------- --------- --------- --------- ---------
function DATA(src)
	data1={rows={}, cols=nil}
	if   type(src)=="string" 
	then for      t in csv(src)       do data(data1,ROW(t)) end
  else for _,row1 in pairs(src or {}) do data(data1,row1)   end end
	return data1 end 

function data(data1,row1)
	if data1.cols then cols(data1.cols, push(data1.rows, row1).cells) else
	   data1.cols = COLS(row1.cells) end end
--------- --------- --------- --------- --------- --------- --------- --------- --------- ---------
rseed = 937162211
function rint(nlo,nhi) return math.floor(0.5 + rand(nlo,nhi))  end
function rand(nlo,nhi)
  nlo,nhi = nlo or 0, nhi or 1
  rseed = (16807 * rseed) % 2147483647
  return nlo + (nhi-nlo) * rseed / 2147483647 end

function keysort(t,fun,      u,v)
  u={}; for _,x in pairs(t) do u[1+#u] = {x=x, y=fun(x)} end
  table.sort(u, function(a,b) return a.y < b.y end)
  v={}; for _,xy in pairs(u) do v[1+#v] = xy.x end
	return v end

function show(x,  digits,      mult)
  if type(x) ~= "number" then return tostring(x) end
  if math.floor(x) == x  then return x end
  mult = 10^(digits or 2)
  return math.floor(x * mult + 0.5) / mult end

function push(t,x) t[1+#t] = x; return x end

function oo(x,d) print(o(x,d)) return x end

function o(t,d,    u,s)
	if type(t) ~= "table" then return show(t,d) end
  u={}; for k,v in pairs(t) do 
		      s = o(v,d)
					u[1+#u]= #t>1 and s or string.format(":%s %s",k,s) end
	if #t==0 then table.sort(u) end
	return "{".. table.concat(u,", ") .."}" end

function ent(t,       e,N)
	N=0; for _,n in pairs(t) do N = N + n end
	e=0; for _,n in pairs(t) do e = e - n/N * math.log(n/N,2) end
	return e end

function make(s)
	return math.tointeger(s) or tonumber(s) or (s=="true" or (s ~="false" and s)) end

function makes(s,    t)
	t={}; for s1 in s:gmatch("([^,]+)") do 
		      t[1+#t]=make(s1:match'^%s*(.*%S)' or '') end
	return t end

function csv(sFile,     src)
	src = io.input(sFile)
	return function(     s)
		s = io.read()
		if s then return makes(s) else io.close(src) end end end
--------- --------- --------- --------- --------- --------- --------- --------- --------- ---------
function main(      d)
  d = DATA(the.data)
  oo(stats(d))
  oo(d.cols.y[1])
	row1 = d.rows[1]
  for i,row2 in pairs(neighbors(d, row1, d.rows)) do
		if i % 50 == 0 then print(i, show(dists(d,row1,row2)),o(row2.cells)) end end end

main()