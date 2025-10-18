-- METATABLES (Advanced Table Behavior)
-- Control how tables behave when you do special operations

-- BASIC METATABLE
local myTable = {value = 10}
local metatable = {
    __index = function(tbl, key)
        return "Key not found: " .. key
    end
}

setmetatable(myTable, metatable)

print(myTable.value) -- prints 10
print(myTable.missing) -- prints "Key not found: missing"

-- GET METATABLE
local mt = getmetatable(myTable)

-- __INDEX (what happens when accessing missing key)

-- Option 1: Function
local mt1 = {
    __index = function(tbl, key)
        print("Trying to access:", key)
        return nil
    end
}

-- Option 2: Another table
local defaults = {health = 100, damage = 10}
local player = {name = "John"}
setmetatable(player, {__index = defaults})

print(player.name) -- "John"
print(player.health) -- 100 (from defaults)

-- __NEWINDEX (what happens when setting new key)
local locked = {}
local mt = {
    __newindex = function(tbl, key, value)
        print("Cannot add new keys!")
    end
}
setmetatable(locked, mt)

locked.test = 5 -- prints "Cannot add new keys!" but doesn't add

-- __ADD (custom addition)
local Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
    local self = {x = x, y = y}
    setmetatable(self, Vector)
    return self
end

function Vector.__add(a, b)
    return Vector.new(a.x + b.x, a.y + b.y)
end

local v1 = Vector.new(1, 2)
local v2 = Vector.new(3, 4)
local v3 = v1 + v2 -- uses __add
print(v3.x, v3.y) -- 4, 6

-- __SUB (custom subtraction)
function Vector.__sub(a, b)
    return Vector.new(a.x - b.x, a.y - b.y)
end

-- __MUL (custom multiplication)
function Vector.__mul(a, b)
    if type(b) == "number" then
        return Vector.new(a.x * b, a.y * b)
    end
end

local v4 = v1 * 2 -- doubles the vector

-- __TOSTRING (custom print format)
function Vector.__tostring(v)
    return "Vector(" .. v.x .. ", " .. v.y .. ")"
end

print(v1) -- prints "Vector(1, 2)"

-- __CALL (make table callable like function)
local counter = {count = 0}
setmetatable(counter, {
    __call = function(tbl)
        tbl.count = tbl.count + 1
        return tbl.count
    end
})

print(counter()) -- 1
print(counter()) -- 2
print(counter()) -- 3

-- CLASS-LIKE PATTERN (OOP)
local Player = {}
Player.__index = Player

-- Constructor
function Player.new(name, health)
    local self = {
        name = name,
        health = health or 100
    }
    setmetatable(self, Player)
    return self
end

-- Methods
function Player:takeDamage(amount)
    self.health = self.health - amount
    if self.health <= 0 then
        self:die()
    end
end

function Player:heal(amount)
    self.health = math.min(self.health + amount, 100)
end

function Player:die()
    print(self.name .. " died!")
end

-- Usage
local player1 = Player.new("John", 100)
player1:takeDamage(30)
print(player1.health) -- 70

-- READONLY TABLE
local function readOnly(tbl)
    local proxy = {}
    local mt = {
        __index = tbl,
        __newindex = function()
            error("Cannot modify readonly table!")
        end
    }
    setmetatable(proxy, mt)
    return proxy
end

local config = readOnly({maxPlayers = 10, mapName = "Arena"})
print(config.maxPlayers) -- works
-- config.maxPlayers = 20 -- ERROR!

-- DEFAULT VALUES TABLE
local function withDefaults(tbl, defaults)
    setmetatable(tbl, {__index = defaults})
    return tbl
end

local defaults = {health = 100, speed = 16}
local enemy = withDefaults({health = 50}, defaults)
print(enemy.health) -- 50
print(enemy.speed) -- 16 (from defaults)

-- PROPERTY TRACKING
local function tracked(tbl)
    local data = {}
    local proxy = {}
    
    local mt = {
        __index = function(t, key)
            print("Reading:", key)
            return data[key]
        end,
        __newindex = function(t, key, value)
            print("Writing:", key, "=", value)
            data[key] = value
        end
    }
    
    setmetatable(proxy, mt)
    
    for k, v in pairs(tbl) do
        data[k] = v
    end
    
    return proxy
end

local watched = tracked({x = 5, y = 10})
print(watched.x) -- prints "Reading: x" then 5
watched.y = 20 -- prints "Writing: y = 20"

-- INHERITANCE (class extends class)
local Animal = {}
Animal.__index = Animal

function Animal.new(name)
    local self = {name = name}
    setmetatable(self, Animal)
    return self
end

function Animal:speak()
    print("Some sound")
end

-- Dog inherits from Animal
local Dog = {}
Dog.__index = Dog
setmetatable(Dog, {__index = Animal}) -- inherit from Animal

function Dog.new(name, breed)
    local self = Animal.new(name)
    self.breed = breed
    setmetatable(self, Dog)
    return self
end

function Dog:speak()
    print(self.name .. " barks!")
end

local dog = Dog.new("Buddy", "Golden")
dog:speak() -- "Buddy barks!"

-- ALL METAMETHODS
local allMeta = {
    __index = function() end, -- read missing key
    __newindex = function() end, -- write new key
    __call = function() end, -- call table as function
    __tostring = function() end, -- convert to string
    __add = function() end, -- addition (+)
    __sub = function() end, -- subtraction (-)
    __mul = function() end, -- multiplication (*)
    __div = function() end, -- division (/)
    __mod = function() end, -- modulo (%)
    __pow = function() end, -- power (^)
    __unm = function() end, -- negation (-)
    __eq = function() end, -- equality (==)
    __lt = function() end, -- less than (<)
    __le = function() end, -- less or equal (<=)
    __concat = function() end, -- concatenation (..)
    __len = function() end, -- length (#)
}
