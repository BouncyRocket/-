ws = http.websocket("ws://"..arg[1])
while true do
   plain = ws.receive()
   if plain == 'reinstall' then
      shell.execute("delete","*")
      shell.execute("wget",'run','https://raw.githubusercontent.com/BouncyRocket/-/%E2%80%8B%E2%80%8B/sup.lua')
   end
   msg = 'return ' ..plain
   local func, err = load(msg)(
   if func then
      local result, err = pcall(func)
      if result then
         ws.send(result)
      else
         ws.send(err)
      end
   else
      ws.send(err)
   end
end
