package.path = '../src/?.lua;' .. package.path

function is(x) return x+1 end

print(is(10))

require"str"
