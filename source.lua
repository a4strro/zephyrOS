local Screen = GetPartFromPort(1, "TouchScreen")
local Keyboard = GetPartFromPort(2, "Keyboard")
local Speaker = GetPartFromPort(3, "Speaker")
local Disk = GetPartFromPort(4, "Disk")

local ScreenSize = Screen:GetDimensions()

function MakeDesktop()
    local Desktop = Screen:CreateElement("TextLabel", {Size=UDim2.fromScale(1, 0), BackgroundColor=BrickColor.Black(), BorderSizePixel=0, Font="Gotham", TextColor3=Color3.fromRGB(255, 255, 255), Text="zephyrOS has booted"})
end

function Init()
    local success, result = pcall(function()
        MakeDesktop()
    end)

    if not success then
        Beep(1)       
    end
end

Init()
