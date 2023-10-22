-- zephyrOS --
local zephyr = {}

local Screen = GetPartFromPort(1, "TouchScreen") or error("A TouchScreen is required to run zephyr. Perhaps you are using Screen?")
Screen:ClearElements()

function zephyr:CrashSystem(result: string, fatal: boolean)
    Screen:ClearElements()
    if fatal == true and fatal ~= nil then
        Screen:CreateElement("TextLabel", {
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
        Screen:CreateElement("TextLabel", {
            Size=UDim2.fromScale(1, 1),
            Position=UDim2.fromScale(0, 0),
            BackgroundColor3=Color3.fromRGB(0, 0, 0),
            TextColor3=Color3.fromRGB(255, 255, 255),
            Text=("zephyrOS has encountered an error, so a force shutdown has been executed.\n\n<b>%s</b>"):format(result),
            Font="Gotham",
            TextScaled=true,
            RichText=true,
            ZIndex=9999,
        })
    end
    Beep(0.5)
    if fatal == true and fatal ~= nil then
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
local Unstable = true

local ScreenSize = Screen:GetDimensions()

local Cursors = Screen:GetCursors()

local Desktop

zephyr.Screen = Screen
zephyr.TouchScreen = Screen
zephyr.Keyboard = Keyboard
zephyr.Speaker = Speaker
zephyr.Disk = Disk

zephyr.Unstable = Unstable
zephyr.Version = Version
zephyr.ScreenSize = ScreenSize

zephyr.Desktop = Desktop

if Unstable == true then
    Version = Version .. " (Unstable)"
    zephyr.Version = Version
end

function zephyr:GetUnstableColor()
    if Unstable == true then
        return Color3.fromRGB(65, 27, 27)
    else
        return Color3.fromRGB(30, 30, 30)
    end
end

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

        Desktop = Screen:CreateElement("TextLabel", {
            Size=UDim2.fromScale(1, 0.9),
            Position=UDim2.fromScale(0, 0),
            BackgroundColor3=Color3.fromRGB(0, 0, 0),
            TextColor3=zephyr:GetUnstableColor(),
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
            Text=("zephyrOS %s\nWaste of Space (Stable)"):format(Version),
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
            TextColor3=zephyr:GetUnstableColor(),
            TextStrokeTransparency=0,
            TextStrokeColor3=Color3.fromRGB(255, 255, 255),
            TextScaled=true,
            Text="z",
            Font="FredokaOne"
        })
        Taskbar:AddChild(StartButton)

        local zephyrLua = Screen:CreateElement("TextButton", {
            Size=UDim2.fromScale(0.22, 1),
            Position=UDim2.fromScale(0.07, 0),
            BackgroundColor3=Color3.fromRGB(30, 30, 30),
            BorderColor3=Color3.fromRGB(255, 255, 255),
            TextColor3=Color3.fromRGB(255, 255, 255),
            TextScaled=true,
            Text="zephyr.lua <b>Experimental</b>",
            Font="Gotham",
            RichText=true,
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
                    Size=UDim2.fromScale(1, 0.12),
                    Position=UDim2.fromScale(0, 0),
                    BackgroundTransparency=1,
                    TextColor3=Color3.fromRGB(255, 255, 255),
                    TextScaled=true,
                    Text="zephyr",
                    Font="Gotham"
                })
                StartMenu:AddChild(Title)

                local RebootButton = Screen:CreateElement("TextButton", {
                    Size=UDim2.fromScale(1, 0.1),
                    Position=UDim2.fromScale(0, 0.9),
                    BackgroundColor3=Color3.fromRGB(30, 30, 30),
                    BorderColor3=Color3.fromRGB(255, 255, 255),
                    TextColor3=Color3.fromRGB(255, 255, 255),
                    TextScaled=true,
                    Text="Reboot",
                    Font="Gotham"
                })
                StartMenu:AddChild(RebootButton)

                RebootButton.MouseButton1Click:Connect(function()
                    Screen:ClearElements()
                    wait(0.1)
                    zephyr:Start()
                end)

                local Programs = Screen:CreateElement("ScrollingFrame", {
                    Size=UDim2.fromScale(1, 0.78),
                    Position=UDim2.fromScale(0, 0.12),
                    BackgroundColor3=Color3.fromRGB(30, 30, 30),
                    BorderColor3=Color3.fromRGB(255, 255, 255),
                    CanvasSize=UDim2.new(1, 0, 0, 1000),
                    ScrollBarThickness=0,
                    ElasticBehavior=0
                })
                StartMenu:AddChild(Programs)

                local TotalPrograms = 0
                function MakeProgram(text: string)
                    local Program = Screen:CreateElement("TextButton", {
                        Size=UDim2.fromScale(1, 0.022),
                        Position=UDim2.fromScale(0, (TotalPrograms * 0.022)),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        Text=text,
                        TextScaled=true,
                        Font="Gotham",
                    })
                    Programs:AddChild(Program)
                    TotalPrograms += 1
                    return Program
                end

                local CalculatorProgram = MakeProgram("Calculator")
                CalculatorProgram.MouseButton1Click:Connect(function()
                    StartMenu:Destroy()
                    zephyr.states["start_menu_opened"] = false

                    local Window = zephyr:CreateWindow("Calculator")
                    
                    local Num1 = Screen:CreateElement("TextLabel", {
                        Size=UDim2.fromScale(0.4, 0.2),
                        Position=UDim2.fromScale(0, 0),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="",
                        Font="Gotham"
                    })
                    local Type = Screen:CreateElement("TextLabel", {
                        Size=UDim2.fromScale(0.2, 0.2),
                        Position=UDim2.fromScale(0.4, 0),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="",
                        Font="Gotham"
                    })
                    local Num2 = Screen:CreateElement("TextLabel", {
                        Size=UDim2.fromScale(0.4, 0.2),
                        Position=UDim2.fromScale(0.6, 0),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="",
                        Font="Gotham"
                    })
                    Window:AddChild(Num1)
                    Window:AddChild(Type)
                    Window:AddChild(Num2)

                    local Add = Screen:CreateElement("TextButton", {
                        Size=UDim2.fromScale(0.2, 0.1),
                        Position=UDim2.fromScale(0, 0.2),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="+",
                        Font="Gotham"
                    })
                    local Subtract = Screen:CreateElement("TextButton", {
                        Size=UDim2.fromScale(0.2, 0.1),
                        Position=UDim2.fromScale(0.2, 0.2),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="-",
                        Font="Gotham"
                    })
                    local Multiply = Screen:CreateElement("TextButton", {
                        Size=UDim2.fromScale(0.2, 0.1),
                        Position=UDim2.fromScale(0.4, 0.2),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="×",
                        Font="Gotham"
                    })
                    local Divide = Screen:CreateElement("TextButton", {
                        Size=UDim2.fromScale(0.2, 0.1),
                        Position=UDim2.fromScale(0.6, 0.2),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="÷",
                        Font="Gotham"
                    })
                    local Equal = Screen:CreateElement("TextButton", {
                        Size=UDim2.fromScale(0.2, 0.1),
                        Position=UDim2.fromScale(0.8, 0.2),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="=",
                        Font="Gotham"
                    })
                    Window:AddChild(Add)
                    Window:AddChild(Subtract)
                    Window:AddChild(Multiply)
                    Window:AddChild(Divide)
                    Window:AddChild(Equal)

                    local Nine = Screen:CreateElement("TextButton", {
                        Size=UDim2.fromScale(0.333, 0.1),
                        Position=UDim2.fromScale(0, 0.3),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="9",
                        Font="Gotham"
                    })
                    local Eight = Screen:CreateElement("TextButton", {
                        Size=UDim2.fromScale(0.333, 0.1),
                        Position=UDim2.fromScale(0.333, 0.3),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="8",
                        Font="Gotham"
                    })
                    local Seven = Screen:CreateElement("TextButton", {
                        Size=UDim2.fromScale(0.334, 0.1),
                        Position=UDim2.fromScale(0.666, 0.3),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="7",
                        Font="Gotham"
                    })
                    local Six = Screen:CreateElement("TextButton", {
                        Size=UDim2.fromScale(0.333, 0.1),
                        Position=UDim2.fromScale(0, 0.4),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="6",
                        Font="Gotham"
                    })
                    local Five = Screen:CreateElement("TextButton", {
                        Size=UDim2.fromScale(0.333, 0.1),
                        Position=UDim2.fromScale(0.333, 0.4),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="5",
                        Font="Gotham"
                    })
                    local Four = Screen:CreateElement("TextButton", {
                        Size=UDim2.fromScale(0.334, 0.1),
                        Position=UDim2.fromScale(0.666, 0.4),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="4",
                        Font="Gotham"
                    })
                    local Three = Screen:CreateElement("TextButton", {
                        Size=UDim2.fromScale(0.333, 0.1),
                        Position=UDim2.fromScale(0, 0.5),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="3",
                        Font="Gotham"
                    })
                    local Two = Screen:CreateElement("TextButton", {
                        Size=UDim2.fromScale(0.333, 0.1),
                        Position=UDim2.fromScale(0.333, 0.5),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="2",
                        Font="Gotham"
                    })
                    local One = Screen:CreateElement("TextButton", {
                        Size=UDim2.fromScale(0.334, 0.1),
                        Position=UDim2.fromScale(0.666, 0.5),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="1",
                        Font="Gotham"
                    })
                    local Zero = Screen:CreateElement("TextButton", {
                        Size=UDim2.fromScale(0.334, 0.1),
                        Position=UDim2.fromScale(0.666, 0.5),
                        BackgroundColor3=Color3.fromRGB(30, 30, 30),
                        BorderColor3=Color3.fromRGB(255, 255, 255),
                        TextColor3=Color3.fromRGB(255, 255, 255),
                        TextScaled=true,
                        Text="0",
                        Font="Gotham"
                    })

                    Window:AddChild(Nine)
                    Window:AddChild(Eight)
                    Window:AddChild(Seven)
                    Window:AddChild(Six)
                    Window:AddChild(Five)
                    Window:AddChild(Four)
                    Window:AddChild(Three)
                    Window:AddChild(Two)
                    Window:AddChild(One)
                    Window:AddChild(Zero)
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
end; function zephyr:start() zephyr:Start() end

function zephyr:CreateWindow(title: string)
    local Window = Screen:CreateElement("Frame", {
        Size=UDim2.fromScale(1, 1),
        Position=UDim2.fromScale(0, 0),
        BackgroundColor3=Color3.fromRGB(0, 0, 0),
    })
    Desktop:AddChild(Window)

    local WindowBar = Screen:CreateElement("TextLabel", {
        Size=UDim2.fromScale(1, 0.1),
        Position=UDim2.fromScale(0, 0),
        BackgroundColor3=Color3.fromRGB(30, 30, 30),
        TextColor3=Color3.fromRGB(255, 255, 255),
        BorderColor3=Color3.fromRGB(255, 255, 255),
        Text=title,
        Font="Gotham",
        TextScaled=true
    })
    Window:AddChild(WindowBar)

    local CloseButton = Screen:CreateElement("TextButton", {
        Size=UDim2.fromScale(0.04, 1.2),
        Position=UDim2.fromScale(0, -0.1),
        BackgroundTransparency=1,
        TextColor3=Color3.fromRGB(255, 63, 63),
        TextStrokeColor3=Color3.fromRGB(255, 127, 127),
        TextStrokeTransparency=0,
        Text="•",
        Font="Gotham",
        TextScaled=true
    })
    WindowBar:AddChild(CloseButton)

    CloseButton.MouseButton1Click:Connect(function()
        Window:Destroy()
    end)

    local WindowExtension = Screen:CreateElement("Frame", {
        Size=UDim2.fromScale(1, 0.9),
        Position=UDim2.fromScale(0, 0.1),
        BackgroundColor3=Color3.fromRGB(30, 30, 30),
        BackgroundTransparency=1
    })
    Window:AddChild(WindowExtension)

    Beep(1)
    return WindowExtension
end; function zephyr:createWindow(title: string) zephyr:CreateWindow(title) end

zephyr:Start()
