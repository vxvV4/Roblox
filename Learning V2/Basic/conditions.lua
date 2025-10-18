-- CONDITIONS
-- How to make decisions in code

-- Basic if statement
local health = 50

if health > 75 then
    print("Healthy")
elseif health > 25 then
    print("Hurt")
else
    print("Critical")
end

-- Comparison operators
-- > greater than
-- < less than
-- >= greater or equal
-- <= less or equal
-- == equal to
-- ~= not equal to

local score = 100
if score == 100 then
    print("Perfect score!")
end

if score ~= 0 then
    print("You scored something")
end

-- And operator (both must be true)
local hasKey = true
local doorUnlocked = false

if hasKey and doorUnlocked then
    print("Can enter")
end

-- Or operator (at least one must be true)
if hasKey or doorUnlocked then
    print("Might be able to enter")
end

-- Not operator (opposite)
local isDead = false

if not isDead then
    print("Still alive")
end

-- Simple boolean check
local canJump = true
if canJump then
    print("Jump!")
end

-- Check if variable exists
local myVar = "test"
if myVar then
    print("Variable has value")
end

-- Nested conditions
local level = 10
local hasWeapon = true

if level >= 5 then
    if hasWeapon then
        print("Ready for battle")
    else
        print("Need weapon first")
    end
end

-- Multiple conditions
local age = 18
local hasLicense = true
local hasCar = false

if age >= 18 and hasLicense and hasCar then
    print("Can drive")
elseif age >= 18 and hasLicense then
    print("Can drive but needs car")
elseif age >= 18 then
    print("Old enough but needs license")
else
    print("Too young")
end

-- Ternary-like pattern (short if)
local result = (health > 0) and "Alive" or "Dead"
print(result)
