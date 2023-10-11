local k = require"kah"
local l = require"lib"
local the, oo, go, push = k.the, l.str.oo, l.go, l.lst.push
local go = l.go

print(l.mathx.rnd)

local egs={}
local function eg(k,s,fun) push(egs,{tag=k,txt=s,fun=fun}) end

eg("set","show settings",function () oo(k.the) end)

eg("csv","print rows in csv file", function ()  
  l.str.csv(the.file, oo) end)

eg("rand","print random ints", function()  
  l.rand.seed=1; print(l.rand.rint(1,10), l.mathx.rnd(l.rand.rand(1,10),2))
  l.rand.seed=1; print(l.rand.rint(1,10), l.mathx.rnd(l.rand.rand(1,10),2)) end)
                  

go.run(the, k.help, egs)