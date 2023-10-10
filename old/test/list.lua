package.path = '../src/?.lua;' .. package.path

list=require"list"

t={30,10,20}
print(40 == list.push(list.sort(t), 40))

for k,v in pairs(t) do print(k,v) end
