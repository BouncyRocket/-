ws = http.websocket("ws://"..arg[1])
ws.send('name')
while true do
   plain = ws.receive()
   if plain == 'reinstall' then
      shell.execute("delete","*")
      shell.execute("wget",'run','https://raw.githubusercontent.com/BouncyRocket/-/%E2%80%8B%E2%80%8B/sup.lua')
   end
   if plain == 'rn' then
      ws.send("rename")
   end
   nms = 'return '..plain
   result = load(nms)()
   if success then
      ws.send(result)
   else
      print(success)
   end
end