package.path = '../src/?.lua;' .. package.path

local rand=require"rand"
local the=require"about"

rand.seed=the.seed
t={}
for i=1,10 do t[1+#t]=rand.rand() end

rand.seed=the.seed
for i=1,10 do print("reset",t[i]==rand.rand()) end

t={}
for i=1,10^5 do x = rand.any{10,20,30,40,50,60,70,80,90,100}; t[x]= (t[x] or 0) + 1 end
for k,v in pairs(t) do print("any",k,v) end

for i=1,10 do
  print("five",table.concat(rand.many({1,2,3,4,5,6,7,8,9,0},5))) end
  
t={}
for _,x in pairs(rand.many({10,20,30,40,50,60,70,80,90,100},1000)) do t[x] = (t[x] or 0) + 1 end
for k,v in pairs(t) do print("many",k,v) end
