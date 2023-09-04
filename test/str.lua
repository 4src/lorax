package.path = '../src/?.lua;' .. package.path

str=require"str"

print(str.coerce("8"))

str.oo{aa=1,bb=2,cc={dd=3,ee=4},_ff=5}

str.csv("../../data/auto93.csv",function(t) str.oo(t) end)
