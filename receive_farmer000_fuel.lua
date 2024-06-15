local modem = peripheral.find("modem") or error("No modem attached", 0)
rednet.open("back")

while true do
	local id, message = rednet.receive("farmer000")
	print(message)
	
	sleep(0.1)
end
