-- [
    This is not my script! This script was made by Aidez on V3rm.
    I added this to my github because loadstrings are cool.
-- ]

repeat wait() until game.Players ~= nil
repeat wait() until game.Players.LocalPlayer ~= nil
repeat wait() until game.Workspace ~= nil
repeat wait() until game.Workspace.CurrentCamera ~= nil

local Drawings = {}

local function checkproperty(Object, Property)
    local toreturn = pcall(function()
        if typeof(Object[Property]) == "Instance" then
            error()
        end
    end)
    return toreturn
end

local function mark(part, txt, color)
    if part == nil or txt == nil then
        return
    end
    if not checkproperty(part, "Position") then
        print("Cannot mark, selected object has no position property")
    end
    local TableAddition = {}
    local NewDrawing = Drawing.new("Text")
    NewDrawing.Size = 20
    NewDrawing.Visible = true
    NewDrawing.Outline = true
    NewDrawing.Center = true
    NewDrawing.Text = tostring(txt)
    if color ~= nil then
        NewDrawing.OutlineColor = Color3.new(color.R/255,color.G/255,color.B/255)
    else
        NewDrawing.OutlineColor = Color3.new(255,0,0)
    end
    TableAddition.Part = part
    TableAddition.Drawing = NewDrawing
    table.insert(Drawings, TableAddition)
    part.AncestryChanged:Connect(function(old, new)
        if old == nil or new == nil then
            part:Destroy()
        end
    end)
end


game:GetService("RunService").Stepped:Connect(function()
    for i,v in pairs(Drawings) do
        if v.Drawing ~= nil then
            if v.Part ~= nil and v.Part.Parent ~= nil then
                local ScreenPos,OnScreen = game.Workspace.CurrentCamera:WorldToScreenPoint(v.Part.Position)
                if OnScreen and game.Players.LocalPlayer:DistanceFromCharacter(v.Part.Position) <= 1000 then
                    v.Drawing.Visible = true
                    v.Drawing.Position = Vector2.new(ScreenPos.X,ScreenPos.Y)
                else
                    v.Drawing.Visible = false
                end
                if v.Part.Parent ~= nil and v.Part.Parent:FindFirstChildOfClass("ClickDetector") then
                    if game.Players.LocalPlayer:DistanceFromCharacter(v.Part.Position) <= 10 then
                        fireclickdetector(v.Part.Parent:FindFirstChildOfClass("ClickDetector"))
                    end
                end
            else
                v.Drawing.Visible = false
                v.Drawing:Remove()
                table.remove(Drawings, i)
            end
        end
    end
end)
for i,v in pairs(game.Workspace:GetDescendants()) do
    if v.Name == "Handle" and v:FindFirstAncestor("TrinketSpawn") then
        mark(v,"Trinket")
    end
end
game.Workspace.DescendantAdded:Connect(function(v)
    if v.Name == "Handle" and v:FindFirstAncestor("TrinketSpawn") then
        mark(v,"Trinket")
    end
end)