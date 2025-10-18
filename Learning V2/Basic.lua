-- VARIABLES BASICS
-- How to store and use data

-- Local variable (use this most of the time)
local myVar = "hello"
local number = 42
local isTrue = true

-- Global variable (avoid unless needed)
globalVar = "world"

-- Multiple variables at once
local x, y, z = 1, 2, 3
local name, age = "John", 25

-- nil means no value
local nothing = nil
local empty

-- Different data types
local text = "string"
local num = 123
local decimal = 3.14
local bool = false

-- Check if variable exists
if myVar then
    print("Variable exists and has value")
end

if not empty then
    print("This variable is nil or false")
end

-- Update variable value
local score = 0
score = score + 10
score = score + 5
print(score) -- prints 15

-- Constants (variables that shouldn't change)
local MAX_HEALTH = 100
local GAME_NAME = "My Game"
