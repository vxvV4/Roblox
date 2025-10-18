-- LOOPS
-- How to repeat code multiple times

-- While loop - runs while condition is true
local i = 0
while i < 5 do
    print(i)
    i = i + 1
    wait(0.1)
end

-- For loop - counting from start to end
for i = 1, 10 do
    print(i) -- prints 1 to 10
end

-- For loop with step (count by 2s)
for i = 0, 100, 10 do
    print(i) -- prints 0, 10, 20, 30, etc
end

-- For loop counting down
for i = 10, 1, -1 do
    print(i) -- prints 10, 9, 8, etc
end

-- Loop through array/table
local fruits = {"apple", "banana", "orange"}
for i, fruit in pairs(fruits) do
    print(i, fruit)
end

-- Loop with just values (no index)
for _, fruit in pairs(fruits) do
    print(fruit)
end

-- Loop through dictionary
local player = {name = "John", age = 25, level = 5}
for key, value in pairs(player) do
    print(key, value)
end

-- Infinite loop (careful with these!)
while true do
    print("This runs forever")
    wait(1) -- always add wait() to prevent crash!
end

-- Break out of loop early
for i = 1, 100 do
    if i == 10 then
        break -- stops the loop
    end
    print(i)
end

-- Continue to next iteration
for i = 1, 10 do
    if i == 5 then
        continue -- skip number 5
    end
    print(i)
end

-- Repeat until loop
local count = 0
repeat
    count = count + 1
    print(count)
until count >= 5
