-- A* Pathfinding Algorithm for ComputerCraft Turtles with Recalibration

-- Define the map size
local mapWidth = 3000
local mapHeight = 3000

-- Define the start and end points
local start = {x = 417, y = 2670}
local goal = {x = 419, y = 2660}

-- Define the turtle movements
local movements = {
  {x = 1, y = 0},   -- Right
  {x = -1, y = 0},  -- Left
  {x = 0, y = 1},   -- Up
  {x = 0, y = -1}   -- Down
}

-- List to keep track of obstacles
local obstacles = {}

-- Function to calculate the heuristic (Manhattan distance)
local function heuristic(node)
  return math.abs(node.x - goal.x) + math.abs(node.y - goal.y)
end

-- Function to check if a point is valid (within bounds and not obstructed)
local function isValid(x, y)
  if x < 1 or x > mapWidth or y < 1 or y > mapHeight then
    return false
  end
  for _, obstacle in ipairs(obstacles) do
    if obstacle.x == x and obstacle.y == y then
      return false
    end
  end
  return true
end

-- A* Pathfinding Algorithm
local function findPath(start, goal)
  local openSet = {{x = start.x, y = start.y}}
  local cameFrom = {}
  local gScore = {}
  gScore[start.x * mapWidth + start.y] = 0
  local fScore = {}
  fScore[start.x * mapWidth + start.y] = heuristic(start)

  while #openSet > 0 do
    -- Get the node with the lowest fScore
    local current, currentIndex
    for i, node in ipairs(openSet) do
      local index = node.x * mapWidth + node.y
      if not current or fScore[index] < fScore[currentIndex] then
        current = node
        currentIndex = index
      end
    end

    -- If reached the goal, reconstruct the path and return
    if current.x == goal.x and current.y == goal.y then
      local path = {current}
      while cameFrom[currentIndex] do
        current = cameFrom[currentIndex]
        table.insert(path, 1, current)
        currentIndex = current.x * mapWidth + current.y
      end
      return path
    end

    -- Remove the current node from openSet
    for i, node in ipairs(openSet) do
      if node.x == current.x and node.y == current.y then
        table.remove(openSet, i)
        break
      end
    end

    -- Check neighbors
    for _, movement in ipairs(movements) do
      local neighbor = {x = current.x + movement.x, y = current.y + movement.y}
      if isValid(neighbor.x, neighbor.y) then
        local neighborIndex = neighbor.x * mapWidth + neighbor.y
        local tentative_gScore = gScore[currentIndex] + 1

        if not gScore[neighborIndex] or tentative_gScore < gScore[neighborIndex] then
          cameFrom[neighborIndex] = current
          gScore[neighborIndex] = tentative_gScore
          fScore[neighborIndex] = tentative_gScore + heuristic(neighbor)

          local found = false
          for _, node in ipairs(openSet) do
            if node.x == neighbor.x and node.y == neighbor.y then
              found = true
              break
            end
          end

          if not found then
            table.insert(openSet, neighbor)
          end
        end
      end
    end
  end

  return nil -- No path found
end

-- Function to determine direction to turn and move the turtle
local function moveTurtleTo(node, currentDirection)
  -- Determine the target direction
  local targetDirection
  if node.y > currentDirection.y then
    targetDirection = "up"
  elseif node.y < currentDirection.y then
    targetDirection = "down"
  elseif node.x > currentDirection.x then
    targetDirection = "right"
  elseif node.x < currentDirection.x then
    targetDirection = "left"
  end

  -- Turn the turtle to face the target direction
  if targetDirection == "up" then
    if currentDirection.direction == "right" then
      turtle.turnLeft()
    elseif currentDirection.direction == "left" then
      turtle.turnRight()
    elseif currentDirection.direction == "down" then
      turtle.turnLeft()
      turtle.turnLeft()
    end
  elseif targetDirection == "down" then
    if currentDirection.direction == "right" then
      turtle.turnRight()
    elseif currentDirection.direction == "left" then
      turtle.turnLeft()
    elseif currentDirection.direction == "up" then
      turtle.turnLeft()
      turtle.turnLeft()
    end
  elseif targetDirection == "right" then
    if currentDirection.direction == "up" then
      turtle.turnRight()
    elseif currentDirection.direction == "down" then
      turtle.turnLeft()
    elseif currentDirection.direction == "left" then
      turtle.turnLeft()
      turtle.turnLeft()
    end
  elseif targetDirection == "left" then
    if currentDirection.direction == "up" then
      turtle.turnLeft()
    elseif currentDirection.direction == "down" then
      turtle.turnRight()
    elseif currentDirection.direction == "right" then
      turtle.turnLeft()
      turtle.turnLeft()
    end
  end

  -- Move the turtle forward and check for obstructions
  if turtle.forward() then
    -- Update the current direction
    currentDirection.x = node.x
    currentDirection.y = node.y
    currentDirection.direction = targetDirection
  else
    -- Mark the obstruction
    table.insert(obstacles, {x = node.x, y = node.y})
    print("Obstruction detected at: ", node.x, node.y)
    return false
  end
  return true
end

-- Example usage
local function navigate(start, goal)
  local path = findPath(start, goal)
  if path then
    -- Initialize the current direction
    local currentDirection = {x = start.x, y = start.y, direction = "forward"}

    -- Follow the path
    local i = 1
    while i <= #path do
      if not moveTurtleTo(path[i], currentDirection) then
        -- Recalculate the path if an obstruction is detected
        print("Recalculating path due to obstruction...")
        path = findPath({x = currentDirection.x, y = currentDirection.y}, goal)
        if not path then
          print("No path found after recalculation!")
          return
        end
        i = 1 -- Restart path following from the beginning
      else
        i = i + 1
      end
    end
  else
    print("No path found!")
  end
end

navigate(start, goal)
