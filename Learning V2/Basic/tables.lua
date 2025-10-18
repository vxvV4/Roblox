-- TABLES
-- Arrays and dictionaries in Lua

-- ARRAY (list of items)
local players = {"John", "Sarah", "Mike"}
print(players[1]) -- prints "John" (Lua starts at 1, not 0!)
print(players[2]) -- prints "Sarah"

-- Empty array
local emptyList = {}

-- Add to end of array
table.insert(players, "New Player")

-- Add to specific position
table.insert(players, 1, "First Player") -- adds at position 1

-- Another way to add
players[#players + 1] = "Last Player"

-- Remove from array
table.remove(players, 1) -- removes first item
table.remove(players) -- removes last item

-- Get array length
print(#players)

-- Loop through array
for i, name in pairs(players) do
    print(i, name)
end

-- Loop with ipairs (better for arrays)
for i, name in ipairs(players) do
    print(i, name)
end

-- DICTIONARY (key-value pairs)
local player = {
    name = "John",
    health = 100,
    level = 5,
    isAlive = true
}

-- Access dictionary values
print(player.name)
print(player["health"])

-- Add to dictionary
player.score = 1000
player["damage"] = 25

-- Update dictionary value
player.health = 50

-- Remove from dictionary
player.score = nil

-- Check if key exists
if player.level then
    print("Level exists")
end

-- Loop through dictionary
for key, value in pairs(player) do
    print(key, value)
end

-- MIXED TABLE (array + dictionary)
local item = {
    name = "Sword",
    damage = 50,
    "Rare", -- array position 1
    "Weapon" -- array position 2
}
print(item.name)
print(item[1])

-- NESTED TABLES
local game = {
    players = {
        {name = "John", score = 100},
        {name = "Sarah", score = 200}
    },
    settings = {
        maxPlayers = 10,
        mapName = "Arena"
    }
}
print(game.players[1].name)
print(game.settings.maxPlayers)

-- Table functions
local numbers = {5, 2, 8, 1, 9}

-- Sort table
table.sort(numbers)
print(table.concat(numbers, ", ")) -- prints as string

-- Find in table
local function findInTable(tbl, value)
    for i, v in pairs(tbl) do
        if v == value then
            return i
        end
    end
    return nil
end

-- Clear table
local function clearTable(tbl)
    for i in pairs(tbl) do
        tbl[i] = nil
    end
end

-- Copy table (shallow)
local function copyTable(tbl)
    local copy = {}
    for key, value in pairs(tbl) do
        copy[key] = value
    end
    return copy
end
