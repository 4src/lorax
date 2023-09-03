local lint={}

lint.b4={}; for k,_ in pairs(_ENV) do lint.b4[k] = k end

function lint.lint()
  for k,_ in pairs(_ENV) do if not lint.b4[k] then
    io.stderr:write("-- warning: rogue local [",k,"]\n") end end end

return lint
