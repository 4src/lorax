local l=require"lib"
local o,oo,ooo,push  = l.o,l.oo,l.ooo,l.push
local r=require"lorax"
local the = r.the
local eg={}
--------- --------- --------- --------- --------- --------- -----
local function main()
  l.cli(the)
  if the.help then print(r.help) else
    for _,com in pairs(arg) do
      if eg[com] then
        l.rseed = the.seed
        print("==> ".. com)
        if eg[com]()==false then 
          print("❌ FAIL : "..  com) end end end
    l.rogues() end end
--------- --------- --------- --------- --------- --------- -----
function eg.csv(      n)
  n=0; for t in l.csv(the.file) do n = n + #t end 
  return n ==399*8 end  

function eg.data(     d)
  d = r.DATA(the.file)
  oo(r.stats(d)) end
  
function eg.fails() return false end

function eg.sym(s)
  s=r.SYM()
  for _,x in pairs{1,1,1,1,2,2,3} do r.col(s,x) end
  return 1.37< l.ent(s.has) and l.ent(s.has)< 1.38 end

function eg.num(     n,md,sd)
  n = r.NUM() 
  for i=1,100 do r.col(n, i) end
  md,sd = r.mid(n), r.div(n) 
  return 49 < md and md < 51 and 30 < sd and sd < 32 end

function eg.stats(     d)
  d=r.DATA(the.file)
  print("mid",o(r.stats(d)))
  print("div",o(r.stats(d,r.div,d.cols.y))) end

function eg.clone(      d1,s1,s2,good)
  d1  = r.DATA(the.file)
  s1  = r.stats(d1)
  s2  = r.stats(r.clone(d1,  d1.rows))
  good= true
  for k,v in pairs(s1) do good = good and v == s2[k] end 
  print("original", o(s1))
  print("cloned  ", o(s2))
  return good end

function eg.dist(     t,r1,r2,d)
  t,d={},DATA(the.file); 
  for i=1,20 do 
    r1,r2 = any(d.rows),  any(d.rows) 
    push(t, xshow(minkowski(d, r1, r2),2)) end 
  oo(sorted(t)) end

function eg.heaven(     t,r1,r2,d)
  t,d={},DATA(the.file); 
  for i=1,20 do 
    r1  = any(d.rows)
    push(t, xshow(d2h(d,r1),3)) end
  oo(sorted(t)) end

function eg.heavens(     t,d,n)
  t,d={},DATA(the.file)
  n = (#d.rows) ^.5
  t = keysort(d.rows, function(r) return d2h(d,r) end) 
  print("best", o(stats(clone(d, slice(t,1,n)))))
  print("worst", o(stats(clone(d, slice(t,-n))))) 
end

function eg.around(     t,d,n)
  d = DATA(the.file)
  t = neighbors(d, d.rows[1], d.rows)
  for i = 1, #t,50 do
    print(i,xshow(minkowski(d,t[1],t[i]),2),
            o(d.rows[i].cells)) end end

function eg.neighbors(     t,d,n)
  d = DATA(the.file)
  t = neighbors(d, d.rows[1], d.rows)
  for i = 1, #t,50 do
    print(i,o(d.rows[i].cells),
            xshow(minkowski(d,t[1],t[i]),2)) end end

function eg.half(      _,d,as,bs)
  d = DATA(the.file)
  as,bs,_,_,_,_  = half(d,d.rows) 
  print(#as, #bs) end 

function eg.branch(      d,t,u,cost)
  d = DATA(the.file)
  t,u,_ = branch(d,true) 
  print("best",o(stats(clone(d,t))))
  print("rest",o(stats(clone(d,u)))) 
  cost=0; for _,row in pairs(d.rows) do cost=cost+row.cost end
  print(cost) end

function eg.tree(      d)
  d = DATA(the.file)
  tshow(tree(d,true))
  end
--------- --------- --------- --------- --------- --------- ----- 
main()