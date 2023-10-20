local l=require"lib"
local o,oo,push  = l.o,l.oo,l.push
local lorax = require("lorax")
local ROW,SYM,DATA,NUM=lorax.ROW,lorax.SYM,lorax.DATA,lorax.NUM
local the = lorax.the
local eg={}
--------- --------- --------- --------- --------- --------- -----
local function trip(s,fun,     oops)
  l.rseed = the.seed
  print("==> ".. s)
  oops = fun()==false 
  if oops then print("❌ FAIL : "..  s) end 
  return oops end

local function run(help)
  l.cli(the)
  if the.help then print(help) else
    for _,com in pairs(arg) do
      if eg[com] then trip(com,eg[com]) end end end
  l.rogues() end
--------- --------- --------- --------- --------- --------- -----
function eg.fails() return false end

function eg.all(     bad)
  bad = 0
  for k,fun in l.items(eg) do
    if k~="all" then if trip(k,fun) then bad = bad+1 end end end
  l.rogues()
  os.exit(bad) end

function eg.csv(      n)
  n=0; for t in l.csv(the.file) do n = n + #t end 
  return n ==399*8 end  

function eg.data(     d)
  d = DATA(the.file)
  oo(d:stats()) end
  

function eg.sym(s)
  s = SYM()
  for _,x in pairs{1,1,1,1,2,2,3} do s:add(x) end
  print(s:mid(), s:div())
  return 1.37< s:div() and s:div()< 1.38 end

function eg.num(     n,md,sd)
  n = NUM() 
  for i=1,100 do n:add( i) end
  md,sd = n:mid(), n:div()
  print(md,sd)
  return 49 < md and md < 51 and 30 < sd and sd < 32 end

function eg.stats(     d)
  d = DATA(the.file)
  print("mid",o(d:stats())) 
  print("div",o(d:stats(d,"div",d.cols.y))) end

function eg.clone(      d1,d2,s1,s2,good)
  d1  = DATA(the.file)
  d2  = d1.clone(d1.rows)
  s1  = d1:stats()
  s2  = d2:stats()
  good= true
  for k,v in pairs(s1) do good = good and v == s2[k] end 
  print("original", o(s1))
  print("cloned  ", o(s2)) 
  return good end

function eg.dist(     t,r1,r2,d)
  t,d = {}, DATA(the.file); 
  for i=1,20 do 
    r1,r2 = l.any(d.rows),  l.any(d.rows) 
    push(t, o(d:dist(r1, r2),2)) end 
  oo(l.sort(t),2) end

function eg.heaven(     t,r1,r2,d)
  t, d = {}, DATA(the.file); 
  for i=1,20 do 
    r1  = l.any(d.rows)
    push(t, d:d2h(r1)) end
  oo(t,2) end

function eg.heavens(     t,d,n)
  t, d = {}, DATA(the.file)
  n = (#d.rows) ^.5  
  t = l.keysort(d.rows, function(row1,x) return d:d2h(row1) end) 
  print("best", o(d:clone(l.slice(t,1,n)):stats()))
  print("worst", o(d:clone(l.slice(t,-n)):stats())) end

function eg.around(     t,d,n)
  d = DATA(the.file)
  t = d:neighbors(d.rows[1], d.rows)
  for i = 1, #t,50 do
    print(i,o(d:dist(t[1],t[i]),2),
            o(d.rows[i].cells)) end end

function eg.neighbors(     t,d,n)
  d = DATA(the.file)
  t = d:neighbors(d.rows[1], d.rows)
  for i = 1, #t,50 do
    print(i,o(d.rows[i].cells),
            l.o(d:dist(t[1],t[i]),2)) end end

function eg.half(      _,d,as,bs)
  d =  DATA(the.file)
  as,bs  = d:half(d.rows) 
  print(#as, #bs) end 

-- function eg.branch(      d,t,u,cost)
--   d = DATA(the.file)
--   t,u,_ = branch(d,true) 
--   print("best",o(stats(clone(d,t))))
--   print("rest",o(stats(clone(d,u)))) 
--   cost=0; for _,row in pairs(d.rows) do cost=cost+row.cost end
--   print(cost) end

-- function eg.tree(      d)
--   d = DATA(the.file)
--   tshow(tree(d,true))
--   end
--------- --------- --------- --------- --------- --------- ----- 
run(lorax.help)