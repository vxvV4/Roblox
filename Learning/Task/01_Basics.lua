--[[
================================================================================
    LUA BASICS - START HERE
    File: 01_LUA_BASICS.lua
    Learn these first before moving to the next file
    i learn here Lmao :D
================================================================================
]]--

-- ============================================================================
-- SECTION 1: VARIABLES
-- ============================================================================

-- LOCAL VARIABLES (Always use these!)
local myNumber = 42
local myText = "Hello World"
local myBoolean = true
local myNil = nil

-- GLOBAL VARIABLES (Don't use these!)
globalVariable = "This is bad practice"

print("Number:", myNumber)
print("Text:", myText)
print("Boolean:", myBoolean)


-- ============================================================================
-- SECTION 2: DATA TYPES
-- ============================================================================

local number = 100              -- Number
local string = "Roblox"         -- String (text)
local boolean = true            -- Boolean (true/false)
local nilValue = nil            -- Nil (nothing)
local table = {1, 2, 3}         -- Table (list/array)

-- Check data type
print(type(number))   -- "number"
print(type(string))   -- "string"
print(type(boolean))  -- "boolean"


-- ============================================================================
-- SECTION 3: MATH OPERATIONS
-- ============================================================================

local a = 10
local b = 3

print("Addition:", a + b)        -- 13
print("Subtraction:", a - b)     -- 7
print("Multiplication:", a * b)  -- 30
print("Division:", a / b)        -- 3.333...
print("Power:", a ^ 2)           -- 100
print("Modulo:", a % b)          -- 1 (remainder)

-- Math library
print("Square root:", math.sqrt(16))    -- 4
print("Round:", math.floor(3.7))        -- 3
print("Round up:", math.ceil(3.2))      -- 4
print("Random:", math.random(1, 10))    -- Random number 1-10
print("Pi:", math.pi)                   -- 3.14159...


-- ============================================================================
-- SECTION 4: STRING OPERATIONS
-- ============================================================================

local firstName = "John"
local lastName = "Doe"

-- Concatenation (combining strings)
local fullName = firstName .. " " .. lastName
print(fullName)  -- "John Doe" -- yeah....

-- String length
print("Length:", #firstName)  -- 4

-- String functions
print("Uppercase:", string.upper(firstName))    -- "JOHN"
print("Lowercase:", string.lower(firstName))    -- "john"
print("Replace:", string.gsub("Hello World", "World", "Roblox"))  -- "Hello Roblox"
print("Substring:", string.sub("Hello", 1, 3))  -- "Hel"

-- String formatting
local name = "Bob"
local age = 15
local message = string.format("My name is %s and I'm %d years old", name, age)
print(message)


-- ============================================================================
-- SECTION 5: CONDITIONAL STATEMENTS (IF/ELSE)
-- ============================================================================

local health = 75

if health > 80 then
    print("Healthy!")
elseif health > 50 then
    print("Okay")
elseif health > 20 then
    print("Low health")
else
    print("Critical!")
end

-- Comparison operators
-- >   greater than
-- <   less than
-- >=  greater or equal
-- <=  less or equal
-- ==  equal to
-- ~=  not equal to (different from != in other languages)

local x = 10
local y = 20

if x == y then
    print("Equal")
elseif x ~= y then
    print("Not equal")
end

-- Logical operators
local isAlive = true
local hasWeapon = true

if isAlive and hasWeapon then  -- AND (both must be true)
    print("Ready to fight!")
end

if health < 20 or not isAlive then  -- OR (at least one must be true)
    print("Need help!")
end

if not isAlive then  -- NOT (reverses boolean)
    print("Dead")
end


-- ============================================================================
-- SECTION 6: LOOPS
-- ============================================================================

-- FOR LOOP (numeric)
print("Counting 1 to 5:")
for i = 1, 5 do
    print(i)
end

-- For loop with step
print("Counting backwards:")
for i = 10, 1, -1 do  -- Start, End, Step
    print(i)
end

-- Count by 2s
for i = 0, 10, 2 do
    print(i)  -- 0, 2, 4, 6, 8, 10
end


-- WHILE LOOP
local count = 0
while count < 5 do
    print("Count:", count)
    count = count + 1
end


-- REPEAT UNTIL LOOP
local number = 0
repeat
    print("Number:", number)
    number = number + 1
until number >= 5


-- INFINITE LOOP (be careful!)
-- while true do
--     print("This runs forever!")
--     wait(1)  -- Always use wait() to prevent crash!
-- end


-- ============================================================================
-- SECTION 7: TABLES (ARRAYS)
-- ============================================================================

-- Simple array (Lua starts at index 1, not 0!)
local fruits = {"Apple", "Banana", "Orange"}

print(fruits[1])  -- "Apple" (first item)
print(fruits[2])  -- "Banana"
print(fruits[3])  -- "Orange"

-- Table length
print("Number of fruits:", #fruits)  -- 3

-- Add to table
table.insert(fruits, "Grape")      -- Add to end
table.insert(fruits, 1, "Mango")   -- Add at position 1
print(#fruits)  -- 5

-- Remove from table
table.remove(fruits, 1)  -- Remove first item
table.remove(fruits)     -- Remove last item

-- Loop through array
print("All fruits:")
for index, fruit in ipairs(fruits) do
    print(index, fruit)
end

-- Another way to loop
for i = 1, #fruits do
    print(i, fruits[i])
end


-- ============================================================================
-- SECTION 8: TABLES (DICTIONARIES/KEY-VALUE)
-- ============================================================================

-- Dictionary (key-value pairs)
local player = {
    name = "Steve",
    health = 100,
    level = 5,
    isAlive = true
}

-- Access values
print(player.name)      -- "Steve"
print(player["health"]) -- 100 (alternative way)

-- Add new key
player.coins = 50
player["xp"] = 1000

-- Modify value
player.health = 75

-- Loop through dictionary
for key, value in pairs(player) do
    print(key, "=", value)
end

-- Check if key exists
if player.coins then
    print("Player has coins:", player.coins)
end


-- MIXED TABLE (array + dictionary)
local data = {
    "First item",      -- [1]
    "Second item",     -- [2]
    name = "Custom",   -- ["name"]
    value = 42         -- ["value"]
}

print(data[1])        -- "First item"
print(data.name)      -- "Custom"


-- ============================================================================
-- SECTION 9: FUNCTIONS
-- ============================================================================

-- Basic function
local function sayHello()
    print("Hello!")
end

sayHello()  -- Call the function


-- Function with parameters
local function greet(name)
    print("Hello, " .. name .. "!")
end

greet("Bob")


-- Function with multiple parameters
local function introduce(name, age)
    print("My name is " .. name .. " and I'm " .. age .. " years old")
end

introduce("Alice", 15)


-- Function with return value
local function add(a, b)
    return a + b
end

local result = add(5, 3)
print("5 + 3 =", result)  -- 8


-- Function with multiple return values
local function getStats()
    return 100, 50, 25  -- health, armor, ammo
end

local hp, armor, ammo = getStats()
print("Health:", hp, "Armor:", armor, "Ammo:", ammo)


-- Function with default parameter
local function power(base, exponent)
    exponent = exponent or 2  -- Default to 2 if not provided
    return base ^ exponent
end

print(power(5))      -- 25 (5^2)
print(power(5, 3))   -- 125 (5^3)


-- Anonymous function (function without name)
local multiply = function(a, b)
    return a * b
end

print(multiply(4, 5))  -- 20


-- ============================================================================
-- SECTION 10: SCOPE
-- ============================================================================

local globalVar = "I'm accessible everywhere in this script"

local function testScope()
    local localVar = "I only exist inside this function"
    print(globalVar)  -- Works
    print(localVar)   -- Works
end

testScope()
-- print(localVar)  -- ERROR! localVar doesn't exist here


-- ============================================================================
-- SECTION 11: COMMON PATTERNS
-- ============================================================================

-- Check if variable exists
local myVar = nil

if myVar then
    print("Variable exists")
else
    print("Variable is nil or false")
end


-- Default values
local username = playerName or "Guest"  -- Use "Guest" if playerName is nil


-- Ternary operator alternative
local status = (health > 50) and "Healthy" or "Injured"
print(status)


-- Swap variables
local x = 10
local y = 20
x, y = y, x  -- Swap in one line!
print(x, y)  -- 20, 10


-- Multiple assignment
local a, b, c = 1, 2, 3
print(a, b, c)  -- 1, 2, 3


-- ============================================================================
-- PRACTICE EXERCISES
-- ============================================================================

--[[
TRY THESE YOURSELF:

1. Create a function that takes a number and returns true if it's even
2. Make a table with 5 of your favorite games
3. Write a loop that prints numbers 1-100, but only multiples of 5
4. Create a function that calculates the area of a rectangle
5. Make a table representing a player with name, level, and coins
6. Write a function that returns the largest number from 3 numbers
7. Create a loop that counts down from 10 to 1
8. Make a function that checks if a word is longer than 5 characters

]]--


print("\n✅ You've completed LUA BASICS! Now move to 02_ROBLOX_BASICS.lua")
