-- MODULE SCRIPTS
-- Reusable code that can be shared across scripts

-- === CREATING A MODULE ===

-- Put this in a ModuleScript in ReplicatedStorage or ServerScriptService

-- Basic module
local MyModule = {}

function MyModule.sayHello(name)
    print("Hello " .. name)
end

function MyModule.add(a, b)
    return a + b
end

return MyModule

-- === USING A MODULE ===

-- In a regular Script or LocalScript
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MyModule = require(ReplicatedStorage.MyModule)

MyModule.sayHello("John") -- prints "Hello John"
local result = MyModule.add(5, 3) -- returns 8

-- === MODULE WITH DATA ===

local DataModule = {}

DataModule.maxHealth = 100
DataModule.weapons = {"Sword", "Bow", "Staff"}

function DataModule.getWeapon(index)
    return DataModule.weapons[index]
end

return DataModule

-- === CLASS MODULE (OOP) ===

local Player = {}
Player.__index = Player

function Player.new(name, health)
    local self = setmetatable({}, Player)
    self.name = name
    self.health = health or 100
    self.alive = true
    return self
end

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
    self.alive = false
    print(self.name .. " died")
end

return Player

-- Using the class module
local Player = require(ReplicatedStorage.PlayerModule)
local player1 = Player.new("John", 100)
player1:takeDamage(30)

-- === UTILITY MODULE ===

local Utils = {}

-- Math utilities
function Utils.round(num, decimals)
    local mult = 10 ^ (decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

function Utils.clamp(num, min, max)
    return math.max(min, math.min(max, num))
end

function Utils.lerp(a, b, t)
    return a + (b - a) * t
end

-- String utilities
function Utils.split(str, delimiter)
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

function Utils.trim(str)
    return str:match("^%s*(.-)%s*$")
end

-- Table utilities
function Utils.deepCopy(tbl)
    local copy = {}
    for key, value in pairs(tbl) do
        if type(value) == "table" then
            copy[key] = Utils.deepCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

function Utils.tableContains(tbl, value)
    for _, v in pairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

return Utils

-- === DATA STORE MODULE ===

local DataStoreService = game:GetService("DataStoreService")
local PlayerData = {}

local dataStore = DataStoreService:GetDataStore("PlayerData")

function PlayerData.load(player)
    local success, data = pcall(function()
        return dataStore:GetAsync(player.UserId)
    end)
    
    if success then
        return data or {coins = 0, level = 1}
    else
        warn("Failed to load data for " .. player.Name)
        return {coins = 0, level = 1}
    end
end

function PlayerData.save(player, data)
    local success = pcall(function()
        dataStore:SetAsync(player.UserId, data)
    end)
    
    if success then
        print("Saved data for " .. player.Name)
    else
        warn("Failed to save data for " .. player.Name)
    end
end

return PlayerData

-- === CONFIG MODULE ===

local Config = {}

-- Game settings
Config.maxPlayers = 10
Config.roundTime = 300
Config.mapName = "Arena"

-- Player settings
Config.startingHealth = 100
Config.startingMoney = 500
Config.walkSpeed = 16
Config.jumpPower = 50

-- Weapon data
Config.weapons = {
    Sword = {damage = 25, cooldown = 1, range = 5},
    Bow = {damage = 15, cooldown = 0.5, range = 50},
    Staff = {damage = 40, cooldown = 2, range = 30}
}

return Config

-- === PRIVATE FUNCTIONS IN MODULES ===

local MyModule = {}

-- Private function (not in return table)
local function privateHelper()
    return "This is private"
end

-- Public function
function MyModule.publicFunction()
    local result = privateHelper() -- can use private function
    return result
end

return MyModule

-- === SINGLETON MODULE (runs once) ===

local Singleton = {}

-- This code runs once when first required
print("Singleton initialized!")
local sharedData = {count = 0}

function Singleton.increment()
    sharedData.count = sharedData.count + 1
    return sharedData.count
end

function Singleton.getCount()
    return sharedData.count
end

return Singleton

-- If you require it multiple times, code only runs once
local S1 = require(script.Singleton)
local S2 = require(script.Singleton)
S1.increment() -- count = 1
print(S2.getCount()) -- prints 1 (same instance!)

-- === MODULE WITH EVENTS ===

local EventModule = {}

local event = Instance.new("BindableEvent")

function EventModule.fire(...)
    event:Fire(...)
end

function EventModule.connect(callback)
    return event.Event:Connect(callback)
end

return EventModule

-- === REQUIRING FROM DIFFERENT LOCATIONS ===

-- From ReplicatedStorage
local module1 = require(game.ReplicatedStorage.ModuleName)

-- From ServerScriptService
local module2 = require(game.ServerScriptService.ModuleName)

-- From same parent
local module3 = require(script.Parent.ModuleName)

-- From same folder
local module4 = require(script.Parent.ModuleName)

-- === MODULE BEST PRACTICES ===

--[[
1. Put modules in ReplicatedStorage if both client and server need them
2. Put modules in ServerScriptService if only server needs them
3. Use clear naming: PlayerModule, UtilsModule, DataModule
4. Keep modules focused on one purpose
5. Use local functions for private helpers
6. Return the module table at the end
7. Cache requires at top of script
]]
