local lorax=require"lorax"

local eg={}
function eg.csv() for t in csv(the.data) do 
  print(#t, type(t[1]), o(t)) end end

function eg.data(     d)
  d = DATA(the.data)
  oo(stats(d)) end 

function main()
  for _,com in pairs(arg) do
    if eg[com] then
      rseed = the.seed
      print("==> ".. com)
      if eg[com]()==false then 
        print("❌ FAIL : "..  com) end end end 
  fend

main()