local k = require"kah"
local l = require"lib"
local the, o, oo  = k.the, l.str.o, l.str.oo
local go, push = l.go, l.lst.push

local egs={}
local function eg(k,s,fun) push(egs,{tag=k,txt=s,fun=fun}) end

eg("set","show settings",function () oo(k.the) end)

eg("csv","print rows in csv file", function ()  
  l.str.csv(the.file, oo) end)

eg("rand","does resetting seed geenrate same nums?", 
  function( good,t,u,r)  
    r=l.rand
    r.seed=1
    t,u={},{}
    for i=1,10 do  
      t[i] = r.rint(3,10)
      u[i]= l.mathx.rnd(r.rand(1,10),2)  end 
    r.seed=1;
    good=true
    for i=1,10 do  
      good = good and (t[i]== r.rint(3,10) and
                      u[i]== l.mathx.rnd(r.rand(1,10),2))end
    return good end)

go.run(the, k.help, egs)