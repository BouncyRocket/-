ws = http.websocket("ws://"..arg[1])
while true do
   plain = ws.receive()
   if plain == 'reinstall' then
      shell.execute("delete","*")
      shell.execute("wget",'run','https://raw.githubusercontent.com/BouncyRocket/-/%E2%80%8B%E2%80%8B/sup.lua')
   end
   if plain == 'wipe' then
      shell.execute("delete","*")
      os.exit()
   end
      msg = 'return ' ..plain
      ws.send(load(msg)())
end
