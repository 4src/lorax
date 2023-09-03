local list={}

function list.sort(t,fun) table.sort(t,fun); return t end
function list.push(t,x)   t[1+#t] = x; return x end

return list
