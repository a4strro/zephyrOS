-- zephyrOS --
local zephyr = {}

local Screen = GetPartFromPort(1, "TouchScreen") or error("A TouchScreen is required to run zephyr. Perhaps you are using Screen?")
Screen:ClearElements()

zephyr.crashSystem = function(result: string)
    Screen:ClearElements()
    local Error = Screen:CreateElement("TextLabel", {
        Size=UDim2.fromScale(1, 1),
        Position=UDim2.fromScale(0, 0),
        BackgroundColor3=Color3.fromRGB(0, 0, 0),
        TextColor3=Color3.fromRGB(255, 255, 255),
        Text=("zephyrOS has encountered an error, so a force shutdown has been executed.\n\n<b>%s</b>\n\nYour microcontroller will restart in 10 seconds."):format(result),
        Font="Gotham",
        TextScaled=true,
        RichText=true,
        ZIndex=9999,
    })
    Beep(0.5)
    wait(10)
    zephyr.start()
end

local Keyboard = GetPartFromPort(2, "Keyboard") or zephyr.crashSystem("A Keyboard is required to run zephyr")
local Speaker = GetPartFromPort(3, "Speaker") or zephyr.crashSystem("A Speaker is required to run zephyr")
local Disk = GetPartFromPort(4, "Disk") or zephyr.crashSystem("A Disk is required to run zephyr")

local Version = "0.0"
local ScreenSize = Screen:GetDimensions() or zephyr.crashSystem("Cannot get dimensions of TouchScreen")

zephyr.icons = {
    ["cursor"] = 7091753340,
    ["files"] = {
        ["prg"] = 7072706318,
        ["img"] = 7072717759,
        ["aud"] = 7072722921
    }
}

zephyr.start = function()
    local success, result = pcall(function()
        local Desktop = Screen:CreateElement("TextLabel", {
            Size=UDim2.fromScale(1, 0.9),
            Position=UDim2.fromScale(0, 0),
            BackgroundColor3=Color3.fromRGB(0, 0, 0),
            TextColor3=Color3.fromRGB(30, 30, 30),
            Text="zephyr",
            Font="FredokaOne",
            TextStrokeTransparency=0,
            TextScaled=true,
            TextStrokeColor3=Color3.fromRGB(255, 255, 255),
            ZIndex=-99,
        })

        local Taskbar = Screen:CreateElement("Frame", {
            Size=UDim2.fromScale(1, 0.1),
            Position=UDim2.fromScale(0, 0.9),
            BackgroundColor3=Color3.fromRGB(30, 30, 30),
            BorderColor3=Color3.fromRGB(255, 255, 255),
            ZIndex=9999
        })

        local DebugInfo = Screen:CreateElement("TextLabel", {
            Size=UDim2.fromScale(1, 1),
            Position=UDim2.fromScale(0, -1),
            BackgroundTransparency=1,
            TextTransparency=0.5,
            TextColor3=Color3.fromRGB(255, 255, 255),
            Text=("zephyrOS %s (In Development)\nWaste of Space - Stable"):format(Version),
            Font="Gotham",
            TextXAlignment="Right",
            TextScaled=true
        })
        Taskbar:AddChild(DebugInfo)

        local StartButton = Screen:CreateElement("TextButton", {
            Size=UDim2.fromScale(0.07, 1),
            Position=UDim2.fromScale(0, 0),
            BackgroundColor3=Color3.fromRGB(30, 30, 30),
            BorderColor3=Color3.fromRGB(255, 255, 255),
            TextColor3=Color3.fromRGB(30, 30, 30),
            TextStrokeTransparency=0,
            TextStrokeColor3=Color3.fromRGB(255, 255, 255),
            TextScaled=true,
            Text="z",
            Font="FredokaOne"
        })
        Taskbar:AddChild(StartButton)

        local InjectLua = Screen:CreateElement("TextButton", {
            Size=UDim2.fromScale(0.3, 1),
            Position=UDim2.fromScale(0.07, 0),
            BackgroundColor3=Color3.fromRGB(30, 30, 30),
            BorderColor3=Color3.fromRGB(255, 255, 255),
            TextColor3=Color3.fromRGB(255, 255, 255),
            TextScaled=true,
            Text="Inject pilot.lua",
            Font="Gotham"
        })
        Taskbar:AddChild(InjectLua)

        Beep(1)
        return success
    end)

    if not success then
        zephyr.crashSystem(result)
    end
end

zephyr.start()
