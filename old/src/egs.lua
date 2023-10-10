the=require"about"
rand=require"rand"
local egs={}

function egs.all_run_all_examples() 
 fails=0
 for name,fun in pairs(egs.Egs()) do fails = fails + egs.Run(name,fun)==fail and 1 or 0 end
 return fails end
  
function egs.Run(name,fun,    ok,b4,result,out)
  b4={}; for k,v in pairs(the) b4[k]=v end
  math.randomseed(the.seed or 1234567891)
  rand.seed  = the.seed or 1234567891
  ok, result = pcall(fun)
  out        = ok and result or false
  if not ok then print("❌ FAIL ",name,":",result) end
  for k,v in pairs(b4) do the[k]=v end
  return out end

function egs.Go(    t)
  egs.Cli(the)
  if the.help then
    print(the._help or "")
    for name,_ in pairs(egs) do
      tag,help= name:match("(%w+)_(.+)")
      print(string.format("  %-8s  %s",tag,help:gsub("_"," "))) end
  else
    t={}; for name,_ in pairs(egs) do t[1+#t] = name  end
    for _,name in  sort(t) do
      if name:find("^"..the.act) then egs.Run(name,egs[name]) end end end end

function egs.Cli(t)
  for k,v in pairs(t) do
    v = tostring(v)
    for n,x in ipairs(arg) do
      if x=="-"..(k:sub(1,1)) or x=="--"..k then
        v = v=="false" and "true" or v=="true" and "false" or arg[n+1] end end
    t[k] = math.tointeger(v) or tonumber(v) or v=="true" or v ~= "false" and v or false) end
  return t end

return egs
