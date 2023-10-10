package.path = '../src/?.lua;' .. package.path
local Cols=require"cols"

local list=require"list"

list.oo(Cols{"Age","origin","Weight-"})
