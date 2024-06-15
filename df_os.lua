local globalScreenWidth, globalScreenHeight = term.getSize()
local osWaitTime = 0.001 -- The time to wait before yielding to the next thread.

local globalHeaderGUIWindowCoords = {}
globalHeaderGUIWindowCoords[0] = 1
globalHeaderGUIWindowCoords[1] = 1
globalHeaderGUIWindowCoords[2] = globalScreenWidth
globalHeaderGUIWindowCoords[3] = 2

local globalBodyGUIWindowCoords = {}
globalBodyGUIWindowCoords[0] = 1
globalBodyGUIWindowCoords[1] = 3
globalBodyGUIWindowCoords[2] = globalScreenWidth
globalBodyGUIWindowCoords[3] = globalScreenHeight

term.clear()
term.setBackgroundColour(colours.black)
term.setTextColour(colours.white)

-- what if there are more than 1 attached monitor?
local globalMonitor = peripheral.find("monitor") or error("No attached monitor!")
globalMonitor.clear()	
globalMonitor.setBackgroundColour(colours.black)
globalMonitor.setTextColour(colours.white)
globalMonitor.setTextScale(0.5)

function drawFolder(title, locX, locY, width, height, scale)
	paintutils.drawBox(locX, locY, width*scale, height*scale, colours.white)
	
	local cursorX = locX + width / 2
	cursorX = cursorX - 3
	cursorX = cursorX * scale
	
	local cursorY = locY + height / 3
	cursorY = cursorY * scale
	
	term.setCursorPos(cursorX, cursorY)
	
	term.setTextColour(colours.white)
	term.setBackgroundColour(colours.black)
	term.write(title)
end
		
function serializeTable(tbl)
    local serialized = "{"
    local first = true
    for k, v in pairs(tbl) do
        if type(k) == "number" then
            if not first then
                serialized = serialized .. ", "
            end
            serialized = serialized .. "[" .. k .. "]=" .. textutils.serialize(v)
            first = false
        end
    end
    serialized = serialized .. "}"
    return serialized
end

function writeToDebugFile(variableName, variable)
    -- Create the debug directory if it doesn't exist
    if not fs.exists("debug") then
        fs.makeDir("debug")
    end

    -- Check if the variable is a function
    if type(variable) == "function" then
        print("Cannot serialize type function.")
        return
    end

    -- Write the variable to a file
    local filePath = fs.combine("debug", variableName .. ".txt")
    local file = fs.open(filePath, "w")
    if file then
        if type(variable) == "table" then
            file.write(serializeTable(variable))
        else
            file.write(textutils.serialize(variable))
        end
        file.close()
        print("Variable '" .. variableName .. "' written to file '" .. filePath .. "'.")
    else
        print("Failed to open file for writing.")
    end
end

function renderX()
    local w, h = term.getSize()
    term.clear()
    for y = 1, h do
        for x = 1, w do
            term.setCursorPos(x, y)
            term.write("X")
        end
    end
end

function renderGUI()
	local headerOSWindow = window.create(term.current(), globalHeaderGUIWindowCoords[0],
		globalHeaderGUIWindowCoords[1], globalHeaderGUIWindowCoords[2], globalHeaderGUIWindowCoords[3])
		
	local bodyOSWindow = window.create(term.current(), globalBodyGUIWindowCoords[0],
		globalBodyGUIWindowCoords[1], globalBodyGUIWindowCoords[2], globalBodyGUIWindowCoords[3])					

	function renderTime()
		local timeXStart = globalScreenWidth - 4
		local timeYStart = 1
		
		local time = os.time()
		headerOSWindow.setCursorPos(timeXStart, timeYStart)
		headerOSWindow.write(time)		
	end
	
	function renderComputerLabel()
		local labelXStart = 1
		local labelYStart = 1
		
		local computerLabel = os.getComputerLabel() .. " | ID: " .. os.getComputerID()
		headerOSWindow.setCursorPos(labelXStart, labelYStart)
		headerOSWindow.write(computerLabel)			
	end
	
	function renderHeader()
		headerOSWindow.clear()
		paintutils.drawLine(1, 2, globalScreenWidth, 2, colors.white)
		renderComputerLabel()		
	
		while true do
			renderTime()			
			os.sleep(osWaitTime)
		end		
	end
	
	function renderBody()
		bodyOSWindow.clear()
		bodyOSWindow.setTextColour(colours.white)
		drawFolder("games", 3, 4, 12, 11, 1.1)
		term.setCursorPos(0,0)
		while true do	
			os.sleep(osWaitTime)
		end	
	end
	
	parallel.waitForAny(renderHeader, renderBody)
end

local function tick()
    while true do
        os.sleep(osWaitTime)
        print("Tick")
    end
end

function captureMouse()
	while true do	
		term.setTextColour(colours.white)
		term.setBackgroundColour(colours.black)
		
		local event, button, x, y = os.pullEvent("mouse_click")
		print(("The mouse button %s was pressed at %d, %d"):format(button, x, y))
		sleep(osWaitTime)	
	end
end


--drawFolder("games", 3, 4, 12, 11, 1.1)
--term.setCursorPos(0, 0)
-- os.sleep(60)

--uncomment to start OS!
parallel.waitForAny(renderGUI, captureMouse)