local maxInventorySlots = 16
local maxFuelLevel = 100000

for idx = 1, maxInventorySlots, 1
do
	turtle.select(idx)
	
	local currentFuelLevel = turtle.getFuelLevel()
		print("Will attempt refuel using item at index [" .. idx .. "]. Current fuel at [" .. currentFuelLevel .. "] out of [" .. maxFuelLevel .. "]")
		
	if(currentFuelLevel < maxFuelLevel) then
		turtle.refuel()
	else
		print("Will exit since current fuel level [" .. currentFuelLevel .. "] is maxed out.")
		break
	end
end

print("Refuel attempt based on current inventory done.")