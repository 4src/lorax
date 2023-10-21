local l,eg,the = {},{},{} -- lib utils and testsamd  config parans
local help=[[
SMO: sequential model optimization

  -b  --bins  number of bins     = 5
  -f  --file  data file          = ../data/auto93.csv
  -s  --seed  random number seed = 1234567891]]

local function create(t)
  local lo,hi,goal,freq = {},{},{},{}
  for c,x in pairs(t) do
    freq[c]    = {}
    freq[c][1] = {}
    freq[c][0] = {}
    if x:find"^[A-Z]" then hi[c] = -1E30; lo[c] = 1E30 end
    if x:find"-$"     then goal[c]=0 end
    if x:find"+$"     then goal[c]=1 end end 
  return {rows={}, cols={name=t, hi=hi,lo=lo, goal=goal}} end

local function update(data,t,     x)
  local rows,hi,lo = data.rows, data.cols.hi, data.cols.lo
  rows[1+#rows] = t
  for c,_ in pairs(hi) do
    x = t[c]
    if x ~= "?" then
      if x > hi[c] then hi[c] = x end
      if x < lo[c] then lo[c] = x end end end end

local function norm(data,c,x)
  local hi,lo = data.cols.hi, data.cols.lo
  return x=="?" and x or (x - lo[c]) / (hi[c] - lo[c] + 1E-30) end

local function d2h(data,t)
  local d,n,goal = 0,0,data.cols.goal
  for c,w in pairs(goal) do
    n = n + 1
    d = d + (w - norm(data,c,t[c]))^2 end
  return (d/n) ^ .5 end

local function train(data,rows,       t)
  t={}; for i=1,10 do t[1+#t] = rows[i] end
  table.sort(t, function (r1,r2) return d2h(data,r1) < d2h(data,r2) end)
  mid = math.floor(#t/2)
  for i=1,mid    do count(data,1,t[i]) end
  for i=mid+1,#t do count(data,0,t[i]) end  end 

local function main(      data)
  for t in l.csv(the.file) do
    if data then update(data,t) else data = create(t) end end
  return train(data,l.shuffle(data.rows)) end
--------- --------- --------- --------- --------- --------- --------- --------- --------- ---------
function l.shuffle(t,   j) 
  for i=#t,2,-1 do j=math.random(i); t[i],t[j]=t[j],t[i] end; return t end

function l.trim(s) return s:match'^%s*(.*%S)' end

function l.make(s)
  s=l.trim(s)
  return math.tointeger(s) or tonumber(s) or s=="true" or (s~="false" and s) end

function l.makes(s,      t)
  t={}; for x in s:gmatch("([^,]+)") do t[1+#t] = l.make(x) end; return t end

function l.settings(t, s)
  for k,v in s:gmatch("\n[%s]+[-][%S][%s]+[-][-]([%S]+)[^\n]+= ([%S]+)") do t[k]= l.make(v) end
  return t end

function l.csv(sFile,     src)
  src = io.input(sFile)
  return function(    s) s=io.read(); if s then return l.makes(s) else io.close(src) end end end

function l.oo(x) print(l.o(x)); return x end

function l.o(x,      u)
  if type(x) ~= "table" then return tostring(x) end
  u={}; for k,v in pairs(x) do u[1+#u] = #x==0 and string.format(":%s %s",k,l.o(v)) or l.o(v) end
  if #x==0 then table.sort(u) end
  return "{"..table.concat(u," ").."}" end
--------- --------- --------- --------- --------- --------- --------- --------- --------- ---------
function eg.csv()  for row in l.csv(the.file) do l.oo(row) end end
function eg.main(      d)
  d = main()
  l.oo(d) end

the = l.settings(the,help)
for _,arg in pairs(arg) do if eg[arg] then math.randomseed(the.seed); eg[arg]() end end