-- FUNCTIONS
-- Reusable blocks of code

-- Basic function
local function greet()
    print("Hello!")
end
greet() -- call the function

-- Function with parameters
local function greet2(name)
    print("Hello " .. name)
end
greet2("John")

-- Function with multiple parameters
local function add(a, b)
    return a + b
end
local result = add(5, 3)
print(result) -- prints 8

-- Function with return value
local function getHealth()
    return 100
end
local hp = getHealth()

-- Function with multiple returns
local function getStats()
    return 100, 50, 25 -- hp, damage, speed
end
local hp, dmg, spd = getStats()

-- Function with default parameter
local function greet3(name)
    name = name or "Player" -- if no name, use "Player"
    print("Hello " .. name)
end
greet3() -- prints "Hello Player"
greet3("Mike") -- prints "Hello Mike"

-- Anonymous function
local multiply = function(x, y)
    return x * y
end
print(multiply(4, 5))

-- Function inside function
local function outer()
    local function inner()
        print("Inside inner function")
    end
    inner()
end
outer()

-- Function with variable arguments
local function sum(...)
    local total = 0
    for _, num in pairs({...}) do
        total = total + num
    end
    return total
end
print(sum(1, 2, 3, 4, 5)) -- prints 15

-- Callback function
local function doSomething(callback)
    print("Doing something...")
    callback()
end

doSomething(function()
    print("Callback executed!")
end)

-- Early return
local function checkAge(age)
    if age < 18 then
        return false
    end
    return true
end

-- Function scope
local function test()
    local x = 10 -- only exists inside function
    print(x)
end
test()
-- print(x) -- ERROR: x doesn't exist here
