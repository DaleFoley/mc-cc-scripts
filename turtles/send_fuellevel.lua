local modem = peripheral.find("modem") or error("No modem attached", 0)
rednet.open("left")

local fuel = "Fuel level is: " .. turtle.getFuelLevel() .. " turtle: " .. os.getComputerLabel()
rednet.send(4, fuel, "farmer000")