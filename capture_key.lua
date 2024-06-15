-- Attach the monitor peripheral
local monitor = peripheral.wrap("left") -- Change "left" to the side the monitor is on

-- Initialize the monitor
monitor.setTextScale(1)
monitor.clear()
monitor.setCursorPos(1, 1)

-- Display initial message
monitor.write("Press any key...")

while true do
    -- Capture key events
    local event, key = os.pullEvent("key")

    -- Clear the monitor
    monitor.clear()
    monitor.setCursorPos(1, 1)

    -- Display the key code
    monitor.write("Key pressed: " .. keys.getName(key))
end
