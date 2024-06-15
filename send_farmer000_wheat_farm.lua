local modem = peripheral.find("modem") or error("No modem attached", 0)
rednet.open("back")

rednet.send(2, "farm_wheat", "farmer000")
