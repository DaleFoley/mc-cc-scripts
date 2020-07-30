	local windowX, windowY = term.getSize()
	local windowSize = "The terminal size is X [" .. windowX .. "] and Y [" .. windowY .. "]"
	
while true do
	
	local windowXPercentileCoefficient = windowX / 100 * 10
	
	local progressX = windowXPercentileCoefficient
	local progressY = windowY - 2

	local currentTime = "The current time is [" .. os.time() .. "]"
	local currentDay = "Total days elapsed [" .. os.days() .. "]"
	local computerTimeElapsedSinceStartup = "The PC has been on for [" .. os.clock() .. "] seconds"
	local computerLabelAndID = "The label for this computer is [" .. os.getComputerLabel() .. "] and the ID is [" .. os.getComputerID() .. "]"
	
	term.setBackgroundColor(colors.black)
	
	shell.run("clear")
	
	print(windowSize .. "\n")
	print(computerLabelAndID .. "\n\n" .. currentTime .. "\n" .. currentDay .. "\n\n" .. computerTimeElapsedSinceStartup)
	
	while progressX < windowX do
		paintutils.drawFilledBox(windowXPercentileCoefficient, windowY - 3, progressX, windowY - 2, colors.green)
		progressX = progressX + windowXPercentileCoefficient
		
		sleep(0.100)
	end
end

