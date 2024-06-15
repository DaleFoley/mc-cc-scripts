local debug = true
local checkMaturedCrop = false -- needs work, gets stuck false reporting saying an empty block is not matured crop...

local function debug_inspect(block)
	if debug then
		print("metadata: " .. block["metadata"] .. ", name: " .. block["name"] .. ", age: " .. block['state']['age'])
	end
end

local function get_block_age()
	local isInspected = false
	local blockInfo
	
	isInspected, cropInfo = turtle.inspectDown()
	if isInspected == true then
		if debug then print("block inspoection down has returned true") end
		
		local cropAge = (cropInfo['state']['age'])
		return cropAge
	end
end

local function check_crops()
	local cropsReady = {}
	local cropsReadyIndex = 0
	
	turtle.up()
	turtle.forward()
	turtle.turnRight()

	local maturedAge = 7
	local steps = 7
	
	for i = 0, steps, 1 do
		local cropAge = get_block_age()
		if cropAge ~= nill then
			cropsReady[i] = cropAge >= maturedAge
			
			if debug then print(cropsReady[i]) end
		else
			cropsReady[i] = false
		end		
		turtle.forward()
		
		cropsReadyIndex = cropsReadyIndex + 1
	end	
	
	turtle.turnLeft()
	turtle.forward()
	turtle.forward()
	turtle.forward()
	turtle.turnLeft()
	
	for i = 0, steps, 1 do
		local cropAge = get_block_age()
		if cropAge ~= nill then
			cropsReady[i] = cropAge >= maturedAge

			if debug then print(cropsReady[i]) end
		else
			cropsReady[i] = false
		end		
		turtle.forward()
		
		cropsReadyIndex = cropsReadyIndex + 1
	end
	
	for i = 0, #cropsReady, 1 do
		if cropsReady[i] == false or nil then return cropsReady[i] else return true end
	end
end

local function dig()
	if checkMaturedCrop then
		dig_matured_crop()
	else
		turtle.dig()
	end
end

local function dig_matured_crop()
	local maturedAge = 7
	local isInspected, cropInfo = turtle.inspect()
	if isInspected then	
		debug_inspect(cropInfo)
		local cropAge = (cropInfo['state']['age'])
		while cropAge < maturedAge do
			print("crop not matured. won't dig.")
			sleep(1)
			dig_matured_crop()
		end
		print("turtle dig")
		turtle.dig()
	end
end

local function select_seeds(item_name, min_required_count)
    for slot = 1, min_required_count do
        local item = turtle.getItemDetail(slot)
        if item and item.name == item_name then
            if item.count >= min_required_count then
                turtle.select(slot)
                print(item_name .. " selected in slot " .. slot .. " with count " .. item.count)
                return true
            else
                error("Error: Found " .. item_name .. " in slot " .. slot .. ", but count is less than " .. min_required_count .. " (count: " .. item.count .. ")")
            end
        end
    end
    error("Error: No " .. item_name .. " found in the turtle's inventory. Need at least " .. min_required_count .. ".")
end

local function suck_positive_y()
	turtle.suck()
	turtle.suckDown()
	turtle.turnLeft()
	turtle.forward()
	turtle.suck()
	turtle.suckDown()
	turtle.turnRight()	
	turtle.turnRight()	
	turtle.forward()	
	turtle.forward()
	turtle.suck()
	turtle.suckDown()
	turtle.turnLeft()
	turtle.turnLeft()
	turtle.forward()	
	turtle.turnRight()	
end

local function suck_negative_y()
	turtle.suck()
	turtle.suckDown()
	turtle.turnLeft()
	turtle.forward()
	turtle.suck()
	turtle.suckDown()
	turtle.turnRight()	
	turtle.turnRight()	
	turtle.forward()	
	turtle.turnLeft()
end

local function harvest()
	dig()
	turtle.suck()
	turtle.suckDown()
	
	turtle.forward()
	turtle.turnRight()
	
	local steps = 7
	for i = 0, steps, 1 do
		dig()
		suck_positive_y()
		turtle.forward()
	end
	
	turtle.turnLeft()
	turtle.forward()
	turtle.forward()
	turtle.forward()
	turtle.turnLeft()
	
	for i = 0, steps, 1 do
		dig()
		suck_negative_y()
		turtle.forward()
	end
end

local function return_home()
	turtle.turnRight()
	turtle.turnRight()
	
	local steps = 7
	for i = 0, steps, 1 do
		turtle.forward()
	end	
	
	turtle.turnRight()
	turtle.forward()
	turtle.forward()
	turtle.turnRight()
	
	for i = 0, steps, 1 do
		turtle.forward()
	end

	turtle.turnLeft()	
	turtle.forward()
	turtle.turnLeft()	
	turtle.turnLeft()
	turtle.down()	
end

local function till_and_plant()	
	local steps = 7
	for i = 0, steps, 1 do
		turtle.turnRight()
		turtle.turnRight()
		
		turtle.forward()
		
		turtle.turnLeft()
		turtle.turnLeft()
		
		turtle.dig()
		turtle.place()
	end	
	
	turtle.turnRight()
	turtle.turnRight()
	turtle.forward()
	turtle.turnRight()
	turtle.forward()
	turtle.forward()
	turtle.turnRight()	
	turtle.forward()
	
	steps = 6
	for i = 0, steps, 1 do
		turtle.forward()
		
		turtle.turnLeft()
		turtle.turnLeft()
		
		turtle.dig()
		turtle.place()

		turtle.turnRight()
		turtle.turnRight()		
	end
		
	turtle.turnLeft()
	turtle.forward()
	turtle.turnLeft()
	turtle.turnLeft()
	
	turtle.dig()
	turtle.place()	
end

while true do
	select_seeds("minecraft:wheat_seeds", 16)
	
	local isCropsReadyForHarvest = check_crops()
	return_home()
	
	if isCropsReadyForHarvest then
		print("crops ready for harvesting!")
			
		--harvest()
		--till_and_plant()
	else
		print("crops not ready for harvesting!") 
	end
	
	sleep(60)
end
