local hizo = loadstring(game:HttpGet("your_script_url"))()

local window = hizo:Window("hizo")

-- Toggle Example
window:Toggle("Auto Farm", false, function(state)
    if state then
        print("Auto Farm ON")
        -- Your auto farm code here or any function 
    else
        print("Auto Farm OFF")
    end
end)

-- Toggle Example 2
window:Toggle("ESP", true, function(state)
    print("ESP:", state)
end)

-- Button Example
window:Button("Kill All", function()
    print("Kill All activated!")
    -- Your kill all code here or any function 
end)

-- Button Example 2
window:Button("TP to Spawn", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
end)
