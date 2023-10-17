-- zephyrOS --
local zephyr = {}

local Screen = GetPartFromPort(1, "TouchScreen") or error("A TouchScreen is required to run zephyr. Perhaps you are using Screen?")
Screen:ClearElements()

function zephyr:CrashSystem(result: string, fatal: boolean)
    Screen:ClearElements()
    local Error
    if fatal == true then
        Error = Screen:CreateElement("TextLabel", {
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
    else
        Error = Screen:CreateElement("TextLabel", {
            Size=UDim2.fromScale(1, 1),
            Position=UDim2.fromScale(0, 0),
            BackgroundColor3=Color3.fromRGB(0, 0, 0),
            TextColor3=Color3.fromRGB(255, 255, 255),
            Text=("zephyrOS has encountered an error, so a force shutdown has been executed.\n\n<b>%s</b>\n\nYou will need to force restart your microcontroller to continue using zephyrOS."):format(result),
            Font="Gotham",
            TextScaled=true,
            RichText=true,
            ZIndex=9999,
        })
    end
    Beep(0.5)
    if fatal == true then
        wait(9e9)
    else
        wait(10)
        zephyr:Start()
    end
end

local Keyboard = GetPartFromPort(2, "Keyboard") or zephyr.crashSystem("A Keyboard is required to run zephyr")
local Speaker = GetPartFromPort(3, "Speaker") or zephyr.crashSystem("A Speaker is required to run zephyr")
local Disk = GetPartFromPort(4, "Disk") or zephyr.crashSystem("A Disk is required to run zephyr")

local Version = "0.0"
local ScreenSize = Screen:GetDimensions()

local Cursors = Screen:GetCursors()

zephyr.Screen = Screen
zephyr.TouchScreen = Screen
zephyr.Keyboard = Keyboard
zephyr.Speaker = Speaker
zephyr.Disk = Disk

zephyr.Version = Version
zephyr.ScreenSize = ScreenSize

zephyr.icons = {
    ["cursor"] = 7091753340,
    ["files"] = {
        ["prg"] = 7072706318,
        ["img"] = 7072717759,
        ["aud"] = 7072722921
    }
}

zephyr.states = {
    ["start_menu_opened"] = false
}

function zephyr:Start()
    local success, result = pcall(function()
        Screen:ClearElements()

        zephyr.states["start_menu_opened"] = false

        local PlayerCursors = {}
        coroutine.wrap(function()
            for _, cursor in Screen:GetCursors() do

            end
        end)

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

        local zephyrLua = Screen:CreateElement("TextButton", {
            Size=UDim2.fromScale(0.2, 1),
            Position=UDim2.fromScale(0.07, 0),
            BackgroundColor3=Color3.fromRGB(30, 30, 30),
            BorderColor3=Color3.fromRGB(255, 255, 255),
            TextColor3=Color3.fromRGB(255, 255, 255),
            TextScaled=true,
            Text="zephyr.lua",
            Font="Gotham"
        })
        Taskbar:AddChild(zephyrLua)

        local StartMenu
        StartButton.MouseButton1Click:Connect(function()
            if zephyr.states["start_menu_opened"] == false then
                StartMenu = Screen:CreateElement("Frame", {
                    Size=UDim2.fromScale(0.4, 0.8),
                    Position=UDim2.fromScale(0, 0.2),
                    BackgroundColor3=Color3.fromRGB(30, 30, 30),
                    BorderColor3=Color3.fromRGB(255, 255, 255),
                    Visible=false
                })
                Desktop:AddChild(StartMenu)

                local Title = Screen:CreateElement("TextLabel", {
                    Size=UDim2.fromScale(1, 0.1),
                    Position=UDim2.fromScale(0, 0),
                    BackgroundTransparency=1,
                    TextColor3=Color3.fromRGB(255, 255, 255),
                    TextScaled=true,
                    Text=("zephyrOS %s"):format(Version),
                    Font="Gotham"
                })
                StartMenu:AddChild(Title)

                local RestartButton = Screen:CreateElement("TextButton", {
                    Size=UDim2.fromScale(1, 0.1),
                    Position=UDim2.fromScale(0, 0.9),
                    BackgroundColor3=Color3.fromRGB(30, 30, 30),
                    BorderColor3=Color3.fromRGB(255, 255, 255),
                    TextColor3=Color3.fromRGB(255, 255, 255),
                    TextScaled=true,
                    Text="Restart",
                    Font="Gotham"
                })
                StartMenu:AddChild(RestartButton)

                RestartButton.MouseButton1Click:Connect(function()
                    Screen:ClearElements()
                    wait(0.1)
                    zephyr:Start()
                end)

                zephyr.states["start_menu_opened"] = true
            elseif zephyr.states["start_menu_opened"] == true then
                StartMenu:Destroy()
                zephyr.states["start_menu_opened"] = false
            end
        end)

        Beep(1)
        return success
    end)

    if not success then
        zephyr:CrashSystem(result)
    end
end

zephyr:Start()
