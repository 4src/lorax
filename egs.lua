local k = require"kah"
local l = require"lib"
local oo, go, push = l.str.oo, l.go, l.lst.push
local go = l.go

local egs={}
local function eg(k,s,fun) push(egs,{tag=k,txt=s,fun=fun}) end

eg("set","show settings",function () oo(k.the) end)

eg()
go.run(k.the, k.help, egs)