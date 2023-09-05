package.path = '../src/?.lua;' .. package.path

str=require"str"

print(str.coerce("8"))

str.oo{bb=1,_ff=2,cc={dd=3,ee=4},aa=5}

n=0
str.csv("../../data/auto93.csv",function(t)
  n=n+1
  if n%50==0 then str.oo(t) end end )
