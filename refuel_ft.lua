--Advanced turtle max fuel = 100,000
--1 lava bucket = 1000
--Need 100 buckets of lava to hit fuel cap

--Refuel using a fluid transposer
local maxFuelLevel = 100000
local currentFuelLevel = turtle.getFuelLevel()

local fluidTransposerBlockName = "ThermalExpansion:Machine"
local fluidTransposerBlockMetaData = 5

local minecraftBucketItemName = "minecraft:bucket"

local isInspectSuccess, inspectedItem = turtle.inspect()

if(isInspectSuccess) then
	if(inspectedItem.name ~= fluidTransposerBlockName and inspectedItem.metadata ~= fluidTransposerBlockMetaData) then
		print("Didn't find machine [" .. fluidTransposerBlockName .. "] with meta data [" .. fluidTransposerBlockMetaData .. "]. Won't attempt refuel operation.")
	end

	while(currentFuelLevel < maxFuelLevel)
	do
		if(turtle.up() ~= true) then
			print("Can't move up. Quitting.")
			break
		end
		
		while(true)
		do
			if(turtle.forward()) then
				break
			end
		end
		
		-- if(turtle.forward() ~= true) then
			-- print("Can't move forward. Quitting.")
			-- break
		-- end
		
		turtle.select(1)
		local selectedItemDetails = turtle.getItemDetail(1)
		
		if(selectedItemDetails.name ~= minecraftBucketItemName) then
			print("Require empty bucket in item slot. Quitting.")
			break
		end
		
		--Check if it is a bucket item selected (empty)
		turtle.dropDown()
		
		turtle.back()
		turtle.down()
		
		--Don't know exactly how long the fluid transposer will take, just keep trying to refuel. Be careful of infinite loop. Suggest timeout.
		while(true)
		do
			if(turtle.refuel()) then
				break
			end
		end
		
		currentFuelLevel = turtle.getFuelLevel()
		
		print("Fuel level is currently at [" .. currentFuelLevel .. "] out of [" .. maxFuelLevel .. "]")
	end
	
	print("Finished refuelling.")
else
	print("Didn't find anything in front of me. Expecting a fluid transposer.")
end


