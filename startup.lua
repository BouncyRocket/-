iscon = '0'
function sleep(a)
    local sec = tonumber(os.clock() + a)
    while (os.clock() < sec) do
    end
end

function ison(n)
  	ws = http.websocket("ws://"..n)
  	if ws then
     		print("Success")
     		ws.close()
     		iscon = '1'
     		shell.run("index ".. n)
		shell.execute("clear")
     		
  	else 
     		print("Failed :(")
  	end
end

while true do
	if iscon == '0' then
		local request = http.get("https://github.com/BouncyRocket/-/blob/%E2%80%8B%E2%80%8B/ngrok-url.txt")
		local response = request.readAll()
		local json = response
		local pattern = '"tcp://.-"' -- regex pattern to match the string containing "tcp://"
		local match = json:match(pattern)
		if match ~= 'Offline' then
		    match = string.sub(match, 8, -2)
		    print(match) -- output
		    ison(match)
		else
		    print("No match found")
		end
		sleep(1.75)
	else
		break
	end
end
print(response)
