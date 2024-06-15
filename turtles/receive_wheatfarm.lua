local modem = peripheral.find("modem") or error("No modem attached", 0)
rednet.open("left")

local id, message = rednet.receive("farmer000")
shell.run(message)
