--Disk install for other apps
shell.execute("wget",'https://raw.githubusercontent.com/BouncyRocket/-/%E2%80%8B%E2%80%8B/startup.lua','../startup.lua')
shell.execute("wget",'https://raw.githubusercontent.com/BouncyRocket/-/%E2%80%8B%E2%80%8B/index.lua','../index')
shell.execute("clear")
if peripheral.find("drive") then
    print("Remove Disk Drive")
    while peripheral.find("drive") do
        os.sleep(0.1)
    end
    os.reboot()
else
    os.reboot()
end