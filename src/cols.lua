local egs=require"egs"
local obj=require("obj").obj 
local Num=require"num"
local Sym=require"sym"

local Cols=obj"Cols"

function Cols.init(t,    col,i,what,a)
  i = {_is=Cols, x={}, y={}, all={}, names=t}
  for at,txt in pairs(t) do
    col = (txt:find"^[A-Z]" and NUM or SYM)(at,txt)
    i.cols[1+#i.cols] = col
    if not col.txt:find"X$" then
      a = col.txt:find"[+-]$" and i.y or i.x
      a[1+#a] = col end end end

function Cols.add(i,t)
  for _,xy in pairs{i.x, i.y} do for _,col in pairs(xy) do col.add(t[c.at]) end end
  return row end

return Cols
