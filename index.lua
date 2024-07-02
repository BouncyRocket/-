ws = http.websocket("ws://"..arg[1])
while true do
   msg = 'return ' ..ws.receive()
   ws.send(load(msg)())
end
