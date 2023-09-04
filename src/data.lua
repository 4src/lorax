local obj=require("klass").obj
local egs=require"egs"

local Data=obj"Data"

function Data.init(src,inits,      i)
  i = {_is=Data, rows={}}
  if   type(src)=="string" 
  then csv(src, function(t) i.add(Row(t,i)) end) 
  else for _,row in pairs(rows or {}) i.add(i,row) end end end

function Data.add(i,row)
  if i.cols then push(i.rows, i.cols.add(row)) else i.cols = Cols(row.raw) end end
  
function Data.like(i,row,nh,nrows,     prior,out,x)
  prior = (#i.rows + the.k) / (nrows + the.k * nh)
  out   = log(prior) 
  for _,col in pairs(i.cols.x) do
    x   = row.raw[col.at]
    out = out + (x=="?"and 0 or log(col.like(),x,prior))  end end
  return out end

return Data
