local egs = require"egs"
local obj = require("klass").obj

local Row=obj"Row"

function Row.init(t,    u) 
  u={}; for k,v in pairs(t) u[k]=v end
  return {i._is=Row, raw=t, bins=u} end

function Row.classify(i, datas)
  max,out = -big, datas[1]
  ndata,nrows=0,0
  for _,data in pairs(datas) do ndata = ndata+1, nrows = nrows + #data.rows end
  for _,data in pairs(datas) do 
    tmp = like(data, i, ndata, nrows) 
    if tmp > max then max,out = tmp,data end end
  return out,max end 

return Row
