shell.run("monitor monitor_3 clear")

-- Function to display information about the smeltery
local function displaySmelteryInfo()
	local barConversionRate = 144
	local blockConversionRate = 1296
	local nuggetConversionRate = 16
	
    local smeltery = peripheral.wrap("back") 

    -- Check if the smeltery peripheral is detected
    if not smeltery then
        term.write("No smeltery detected on the specified side!")
        return
    end
	
	local controller = smeltery.getController() --null check this
	
	while true do
		term.setCursorPos(1, 1)
		
		local lineIndex = 1
		-- Get and display fluids in the smeltery
		local moltens = controller.getMolten()
		term.write("=== Smeltery Molten ===")
		if #moltens > 0 then
			for _, molten in ipairs(moltens) do
				lineIndex = lineIndex + 1
				term.setCursorPos(1, lineIndex)
				
				local moltenAmount = molten.amount
				local moltenBar = math.floor(moltenAmount / barConversionRate)
				local moltenBlock = math.floor(moltenAmount / blockConversionRate)
				local moltenNugget = math.floor(moltenAmount / nuggetConversionRate)
				
				term.write(molten.name .. ", Amount: " .. molten.amount .. " mb, Ba: " .. moltenBar .. ", Bl: " .. moltenBlock .. ", N: " .. moltenNugget)
			end
		else
			term.write("No moltens in the smeltery.")
		end
		
		lineIndex = lineIndex + 2
		term.setCursorPos(1, lineIndex)
		
		-- Get and display items being smelted
		local fuels = controller.getFuels()
		term.write("\n=== Smeltery Fuel ===")
		if #fuels > 0 then
		   for _, fuel in ipairs(fuels) do
				lineIndex = lineIndex + 1
				term.setCursorPos(1, lineIndex)
				term.write(fuel.name .. ", Current: " .. fuel.amount .. ", Max: " .. fuel.capacity)
		   end
		else
		   term.write("No fuel stored.")
		end
		
		sleep(0.2)
	end
end

-- Call the function to display smeltery information
displaySmelteryInfo()
