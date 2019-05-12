--AUTHOR: Dale Foley
--DATE: 2019-05-12 2209

--TODO: Fuel calculations, how much fuel do I need to get back to my starting position?
--TODO: Enhance inventory full check to inspect block to be digged and check if we have space left for it.
--TODO: Blacklist/Whitelist function
--TODO: Fix gravel bug where turtle will not dig up after gravel.

--1 move = 1 fuel consumption
--1 piece of coal refuels 80

--NOTE: be cautious with global variables..
local minimumFuelRequired = 100
local turtleMaxInvSlot = 16
local turtleMaxStackSlot = 64
local turtleMaxInvStackSlot = turtleMaxInvSlot * turtleMaxStackSlot

local forwardCounter = 0

--Generally, when some kind of liqued flows in minecraft, it will flow 'X' amount of blocks further down, 0 to disable.
local flowOffsetValue = 0

--Go home if the turtle gets submerged by water?
local isGoHomeOnSubmerge = false

--If true the turtle will place a torch down if it has one in it's inventory 
local isPlaceTorchesDown = false

function handleGravelBlocks()
	local gravelName = "minecraft:gravel"
	local inspectSuccess, inspectionBlockDetails = turtle.inspect()
	
	while(inspectSuccess)
	do
		inspectedBlockName = inspectionBlockDetails.name
		if(inspectedBlockName == gravelName) then
			print("Destroying gravel block.")
			turtle.dig()
			
			inspectSuccess, inspectionBlockDetails = turtle.inspect()
		else
			print("No more gravel to destroy.")
			break
		end
	end
end

function dropPredeterminedListOfItems()
	local counter = 0
	local numberOfItemStacksDropped = 0
	
	local chiselAndesiteName = "chisel:andesite"
	local chiselGraniteName = "chisel:granite"
	local chiselLimestoneName = "chisel:limestone"
	local cobblestoneItemName = "minecraft:cobblestone"
	local gravelName = "minecraft:gravel"
	local dirtName = "minecraft:dirt"
	
	while counter ~= turtleMaxInvSlot
	do
		counter = counter + 1
		turtle.select(counter)
		
		local itemDetails = turtle.getItemDetail()
		if(itemDetails ~= nil) then
			local itemName = itemDetails.name
			if(itemName == chiselAndesiteName or
				itemName == chiselGraniteName or
				itemName == chiselLimestoneName or
				itemName == cobblestoneItemName or
				itemName == gravelName or
				itemName == dirtName) then
				print("Dropping item [" .. itemName .. "].")
				turtle.drop()
				
				numberOfItemStacksDropped = numberOfItemStacksDropped + 1
			end
		end
	end
	
	return numberOfItemStacksDropped
end

function dropAllItemsMatchingName(nameOfItemToDrop)
	--DRY: looks like a copy paste from isInvetoryFull
	local counter = 0
	local numberOfItemStacksDropped = 0
	
	while counter ~= turtleMaxInvSlot
	do
		counter = counter + 1
		turtle.select(counter)
		
		local itemDetails = turtle.getItemDetail()
		if(itemDetails ~= nil) then
			local itemName = itemDetails.name
			if(itemName == nameOfItemToDrop) then
				print("Dropping item [" .. itemName .. "].")
				turtle.drop()
				
				numberOfItemStacksDropped = numberOfItemStacksDropped + 1
			end
		end
	end
	
	return numberOfItemStacksDropped
end

function isSubmerged()
	local submerged = false

	local flowingWaterName = "minecraft:flowing_water"
	local waterName = "minecraft:water"
	
	local success, blockInspectionDetails = turtle.inspect()
	if(success) then
		local inspectedBlockName = blockInspectionDetails.name
		
		if(inspectedBlockName == flowingWaterName or inspectedBlockName == waterName) then
			submerged = true
		end
	end
	
	return submerged
end

function returnToStartingPosition()
	turtle.turnLeft()
	turtle.turnLeft()
	
	--TODO: what if forwardCounter is zero? Possible infinite loop..
	for idx = 1, forwardCounter + flowOffsetValue, 1
	do
		--TODO: Refuel check?
		turtle.forward()
	end
end

function isNeedRefuel(minimumFuelRequired)
	return turtle.getFuelLevel() < minimumFuelRequired	
end

function isInventoryStackSpaceFull()
	local turtleCurrentInventoryStackSpaceCount = 0
	local counter = 0
	
	while counter ~= turtleMaxInvSlot
	do
		counter = counter + 1
		turtle.select(counter)
		
		local itemDetails = turtle.getItemDetail()
		if(itemDetails ~= nil) then
			turtleCurrentInventoryStackSpaceCount = turtleCurrentInventoryStackSpaceCount + 1
		end
	end
	
	turtle.select(1)
	
	return turtleCurrentInventoryStackSpaceCount == turtleMaxInvSlot
end

function isInventoryFull()
	local turtleCurrentInventoryCount = 0
	local turtleCurrentInventoryStackSpaceCount = 0
	
	local counter = 0
	
	while counter ~= turtleMaxInvSlot
	do
		counter = counter + 1
		turtle.select(counter)
		
		local itemDetails = turtle.getItemDetail()
		if(itemDetails ~= nil) then
			turtleCurrentInventoryCount = turtleCurrentInventoryCount + itemDetails.count
			turtleCurrentInventoryStackSpaceCount = turtleCurrentInventoryStackSpaceCount + 1
		end
	end
	
	turtle.select(1)
	
	return turtleCurrentInventoryCount == turtleMaxInvStackSlot, turtleCurrentInventoryStackSpaceCount == turtleMaxInvSlot
end

--TODO: Refactor to generic find item position function
function findTorch()
	local torchPosition = nil
	
	local torchName = "minecraft:torch"
	local itemDetail = {}
		
	for idx = 1, turtleMaxInvSlot, 1
	do
		turtle.select(idx)
			
		itemDetail = turtle.getItemDetail()
		
		if(itemDetail ~= nil) then
			if(itemDetail.name == torchName) then
				torchPosition = idx
				break
			end		
		end
	end
	
	turtle.select(1)
	
	return torchPosition
end

function stripMine()
	local isBlockInFrontOfMe, inspectedBlock = turtle.inspect()
	
	if(isBlockInFrontOfMe) then
		print("Block in front of me, performing strip mine.")
		
		turtle.dig()
		handleGravelBlocks()
		
		if(turtle.up() ~= true) then
			turtle.digUp()
			turtle.up()
			turtle.dig()
		end
		
		turtle.dig()
		
		if(turtle.up() ~= true) then
			turtle.digUp()
			turtle.up()
			turtle.dig()
		end
		turtle.dig()
		
		turtle.down()
		turtle.down()	
	end
	
	print("Moving forward.")
	
	turtle.forward()
	forwardCounter = forwardCounter + 1
end

--Start inventory at first position
turtle.select(1)

--When we take x amount of steps forward, try placing a torch down, reset the counter
local torchMoveCounterCurrent = 0
local torchMoveCounterTarget = 6

local isRefuelRequired = false

--TODO: Implement some kind of switch that can be turned on or off via rednet.
while true
do
	isRefuelRequired = isNeedRefuel(minimumFuelRequired)
	if(isRefuelRequired) then
		print("I need refueling. I'm not smart enough to go back home..stopping for now..")
		break
	end
	
	local isInventoryFull, isInventoryStackSpaceFull = isInventoryFull()
	local numberOfItemsDropped = 0
	if(isInventoryStackSpaceFull) then
		print("No inventory stack spaces left..will try removing any garbage.")
		
		--local cobblestoneItemName = "minecraft:cobblestone"
		--numberOfItemsDropped = dropAllItemsMatchingName(cobblestoneItemName)		
		numberOfItemsDropped = dropPredeterminedListOfItems()	
		print("Dropped a total of [" .. numberOfItemsDropped .. "] items.")
	end
	
	if(isInventoryFull and numberOfItemsDropped == 0) then
		print("No invetory space left. I'll stop now..")
		break
	end	
	
	if(isGoHomeOnSubmerge) then
		if(isSubmerged()) then
			returnToStartingPosition()
		break
		end
	end

	handleGravelBlocks()
	stripMine()
	
	if(isPlaceTorchesDown) then
		torchMoveCounterCurrent = torchMoveCounterCurrent + 1
		
		if(torchMoveCounterCurrent == torchMoveCounterTarget) then
			local torchInventoryLocation = findTorch()
			
			if(torchInventoryLocation ~= nil) then
				turtle.select(torchInventoryLocation)
				
				turtle.turnLeft()
				turtle.turnLeft()
				turtle.place()
				turtle.turnRight()
				turtle.turnRight()
				
				turtle.select(1)
			end
			
			torchMoveCounterCurrent = 0
		end	
	end
end
