local obj=require"obj"
local egs=require"egs"

local Data=obj"Data"

function Data:init(src,inits,      i)
  self.rows={}
  if   type(src)=="string" 
  then csv(src, function(t) self:add(Row(t,i)) end) 
  else for _,row in pairs(rows or {}) self:add(row) end end end 

function Data:add(row)
  if self.cols then push(self.rows, self.cols.add(row)) else self.cols = Cols(row.raw) end end
  
function Data:like(row,nh,nrows,     prior,out,x)
  prior = (#self.rows + the.k) / (nrows + the.k * nh)
  out   = log(prior) 
  for _,col in pairs(self.cols.x) do
    x   = row.raw[col.at]
    out = out + (x=="?"and 0 or log(col:like(x,prior))  end end
  return out end

return Data
