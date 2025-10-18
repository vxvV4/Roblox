-- INSTANCES
-- Creating, finding, and modifying objects

-- CREATE NEW PART
local part = Instance.new("Part")
part.Parent = workspace
part.Position = Vector3.new(0, 10, 0)
part.Size = Vector3.new(4, 1, 2)
part.BrickColor = BrickColor.new("Bright red")
part.Material = Enum.Material.Neon
part.Anchored = true
part.CanCollide = true
part.Transparency = 0

-- CREATE OTHER INSTANCES
local folder = Instance.new("Folder")
folder.Name = "MyFolder"
folder.Parent = workspace

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://12345678"
sound.Parent = workspace
sound.Volume = 0.5

-- FIND EXISTING OBJECTS
local myPart = workspace:FindFirstChild("PartName")
local myPart2 = workspace:WaitForChild("PartName") -- waits if not found

-- Find with timeout
local found = workspace:WaitForChild("PartName", 5) -- wait 5 seconds max
if found then
    print("Found it")
end

-- Find recursively (search in children too)
local deepFind = workspace:FindFirstChild("Name", true)

-- Find by class
local firstPart = workspace:FindFirstChildOfClass("Part")
local allParts = workspace:GetDescendants()

-- DESTROY OBJECTS
if myPart then
    myPart:Destroy()
end

-- CLONE OBJECTS
local original = workspace.Part
local copy = original:Clone()
copy.Parent = workspace
copy.Position = Vector3.new(10, 10, 10)

-- PARENT (where object is located)
part.Parent = workspace -- makes it visible
part.Parent = game.ServerStorage -- hides it from clients

-- Always set Parent LAST when creating instances
local newPart = Instance.new("Part")
newPart.Size = Vector3.new(10, 1, 10)
newPart.Position = Vector3.new(0, 0, 0)
newPart.Parent = workspace -- do this last for performance

-- GET CHILDREN
local children = workspace:GetChildren()
for _, child in pairs(children) do
    print(child.Name)
end

-- GET DESCENDANTS (children of children too)
local descendants = workspace:GetDescendants()

-- Check if instance is a certain type
if part:IsA("BasePart") then
    print("This is a part")
end

if humanoid:IsA("Humanoid") then
    print("This is a humanoid")
end

-- Get instance properties
print(part.Name)
print(part.ClassName)
print(part.Parent.Name)

-- Wait for child with specific class
local humanoid = character:WaitForChild("Humanoid")

-- Instance attributes (custom properties)
part:SetAttribute("CustomData", 100)
local data = part:GetAttribute("CustomData")

-- Check if instance still exists
if part and part.Parent then
    print("Part still exists")
end
