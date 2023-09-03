str=require"str"
local egs={the={}, help="", order={}, index={}}

-- register a new example, index by string left of ':'
function egs.eg(s,fun)
  tag,doc = s:match"([^:]+):(.*)"
  egs.index[tag] = {tag=tag,doc=doc,fun=fun}
  egs.order[1+#egs.order] = egs.index[tag] end

egs.eg("all:run all examples", function()  
 for _,x in pairs(egs.order) do egs.run(x.fun,x.tag) end)

function egs.settings(help)
  egs.help = help
  help:gsub("\n[%s]+[-][%S][%s]+[-][-]([%S]+)[^\n]+= ([%S]+)",
           function(k,v) egs.the[k]=str.coerce(v) end)
  return egs.the end
  
function egs.run(settings,fun,tag,    ok,b4,result,out)
  b4={}; for k,v in pairs(egs.the) b4[k]=v end
  math.randomseed(settings.seed or 1234567891)
  rand.seed  = settings.seed or 1234567891
  ok, result = pcall(fun)
  out        = ok and result or false
  if not ok then print("❌ FAIL ",tag,":",result) end
  for k,v in pairs(b4) do settings[k]=v end
  return out end

function egs.runs()
  run.cli(settings)
  if settings.help then
    print(help or "")
    for eg in pairs(egs.order) do
      print(string.format("  %-8s  %s",eg.tag, eg.doc)) end
  else
    todo = egs.index[settings.act]
    if todo then egs.run(settings,todo.fun,todo.tag) end end end

function egs.cli(t)
  for k,v in pairs(t) do
    v = tostring(v)
    for n,x in ipairs(arg) do
      if x=="-"..(k:sub(1,1)) or x=="--"..k then
        v = v=="false" and "true" or v=="true" and "false" or arg[n+1] end end
    t[k] = str.coerce(v) end
  return t end

return egs
