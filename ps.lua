args = {...}

local psTag = args[1]
local fileName = args[2]

shell.run("rm " .. fileName)
shell.run("pastebin get " .. psTag .. " " .. fileName)