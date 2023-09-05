local the,help={},[[
KAH : keys are (useful)heuristics 
(c) 2023 Tim Menzies <timm@ieee.org> BSD-2

USAGE
  lua kah.lua [OPTIONS] 

OPTIONS:
	-a  --act      start up action      = nothing
	-d  --decimals placed for float     = 2 
	-k  --k        NB low frequency     = 2 
	-m  --m        NB low frequency     = 1 
	-p  --p        distance coeffecient = 2
	-s  --seed     random number seed   = 937162211
]]

help:gsub("\n[%s]+[-][%S][%s]+[-][-]([%S]+)[^\n]+= ([%S]+)",function(k,v)
  the[k] = math.tointeger(v) or tonumber(v) or v=="true" or (v ~= "false" and v) or false end)

the._help=help

return the
