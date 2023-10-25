-- zephyrOS --
local zephyr = {}

local Screen = GetPartFromPort(1, "TouchScreen") or error("A TouchScreen is required on port 1 to run zephyr. Perhaps you are using Screen?")
Screen:ClearElements()

function zephyr:LoopCheckForPart(port, part)
    coroutine.resume(coroutine.create(function()
        while wait(0.1) do
            if GetPartFromPort(port, part) then return GetPartFromPort(port, part) else
                zephyr:CrashSystem(("A(n) %s is required on port %i to run zephyr."):format(part, port))
            end
        end
    end))
end

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

local Keyboard = zephyr:LoopCheckForPart(2, "Keyboard")
local Speaker = zephyr:LoopCheckForPart(3, "Speaker")
local Disk = zephyr:LoopCheckForPart(4, "Disk")
local Modem = zephyr:LoopCheckForPart(5, "Modem")
local Instrument = zephyr:LoopCheckForPart(6, "Instrument")

local Version = "0.0"
local Unstable = true

local Desktop
local StartMenu

zephyr.Library = {
    Screen = Screen,
    TouchScreen = Screen,
    Keyboard = Keyboard,
    Speaker = Speaker,
    Disk = Disk,
    Modem = Modem,
    Instrument = Instrument,

    Unstable = Unstable,
    Version = Version,

    Desktop = Desktop,
    StartMenu = StartMenu
}

zephyr.Icons = {
    Cursor = 7091753340,
}

zephyr.States = {
    StartMenuOpened = false
}

if Unstable == true then
    Version = Version .. " (Unstable)"
    zephyr.Library.Version = Version
end

function zephyr:GetUnstableColor()
    if Unstable == true then
        return Color3.fromRGB(65, 27, 27)
    else
        return Color3.fromRGB(30, 30, 30)
    end
end

function zephyr:Start()
    local success, result = pcall(function()
        Screen:ClearElements()

        zephyr.States.StartMenuOpened = false

        local PlayerCursors = {}
        coroutine.resume(coroutine.create(function()
            for _, cursor in Screen:GetCursors() do

            end
        end))

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
            Size=UDim2.fromScale(1, 0.1),
            Position=UDim2.fromScale(0, 0.9),
            BackgroundTransparency=1,
            TextTransparency=0.5,
            TextColor3=Color3.fromRGB(255, 255, 255),
            Text=("zephyrOS %s\nWaste of Space (Stable)"):format(Version),
            Font="Gotham",
            TextXAlignment="Right",
            TextScaled=true,
            ZIndex=-1
        })
        Desktop:AddChild(DebugInfo)

        local RegionTime = Screen:CreateElement("TextLabel", {
            Size=UDim2.fromScale(0.12, 1),
            Position=UDim2.fromScale(0.88, 0),
            BackgroundColor3=Color3.fromRGB(30, 30, 30),
            BorderColor3=Color3.fromRGB(255, 255, 255),
            TextColor3=Color3.fromRGB(255, 255, 255),
            TextScaled=true,
            Text="--:--",
            Font="Gotham",
            RichText=true,
        })
        Taskbar:AddChild(RegionTime)

        coroutine.resume(coroutine.create(function()
            while wait(0.5) do
                RegionTime:Configure({Text=("%s"):format(Instrument:GetReading(3))})
            end
        end))

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

        zephyrLua.MouseButton1Click:Connect(function()
            local Window = zephyr:CreateWindow("zephyr.lua")
            
            local Text = Screen:CreateElement("TextLabel", {
                Size=UDim2.fromScale(1, 1),
                Position=UDim2.fromScale(0, 0),
                BackgroundColor3=Color3.fromRGB(30, 30, 30),
                TextColor3=Color3.fromRGB(255, 255, 255),
                TextSize=40,
                Text="Copy and paste your zephyr.lua code using the keyboard. [zephyr.lua coding is experimental, doesn't actually do anything yet]",
                Font="Gotham"
            })

            Keyboard:Connect("TextInputted", function()
                if not Window then return end
                Text:Configure({Text="Found pasted code."})
            end)
        end)

        StartButton.MouseButton1Click:Connect(function()
            if zephyr.States.StartMenuOpened == false then
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

                    Program.MouseButton1Click:Connect(function()
                        StartMenu:Destroy()
                        zephyr.States.StartMenuOpened = false
                    end)

                    return Program
                end

                local CalculatorProgram = MakeProgram("Calculator")
                CalculatorProgram.MouseButton1Click:Connect(function()
                    local Calculator = {}

                    Calculator.IsNum1 = true
                    Calculator.IsNum2 = false

                    Calculator.Num1 = nil
                    Calculator.Operation = nil
                    Calculator.Num2 = nil

                    local Window = zephyr:CreateWindow("Calculator [Bugged]")

                    function Calculator:CreateElement(object: string, text: string, size: UDim2, position: UDim2)
                        local Object = Screen:CreateElement(object, {
                            Size=size,
                            Position=position,
                            BackgroundColor3=Color3.fromRGB(30, 30, 30),
                            BorderColor3=Color3.fromRGB(255, 255, 255),
                            TextColor3=Color3.fromRGB(255, 255, 255),
                            TextScaled=true,
                            Text=text,
                            Font="Gotham"
                        })
                        Window:AddChild(Object)
                        return Object
                    end

                    function Calculator:Query(query: string, isOperation: bool)
                        if isOperation == false then
                            if Calculator.IsNum1 == true then
                                Calculator.Num1 = Calculator.Num1 .. query
                                Num1:Configure({Text=Calculator.Num1})
                            elseif Calculator.IsNum2 == true then
                                Calculator.Num2 = Calculator.Num2 .. query
                                Num2:Configure({Text=Calculator.Num2})
                            end
                        elseif isOperation == true and Calculator.IsNum2 == false then
                            Calculator.IsNum1 = false
                            Operation:Configure({Text=query})
                            Calculator.IsNum1 = true
                        end
                    end
                    
                    local Num1 = Calculator:CreateElement("TextLabel", "", UDim2.fromScale(0.4, 0.1), UDim2.fromScale(0, 0))
                    local Operation = Calculator:CreateElement("TextLabel", "", UDim2.fromScale(0.2, 0.1), UDim2.fromScale(0.4, 0))
                    local Num2 = Calculator:CreateElement("TextLabel", "", UDim2.fromScale(0.4, 0.1), UDim2.fromScale(0.6, 0))

                    local Add = Calculator:CreateElement("TextButton", "+", UDim2.fromScale(1 / 7, 0.1), UDim2.fromScale((1 / 7) * 0, 0.1))
                    Add.MouseButton1Click:Connect(function() Calculator:Query("+", true) end)
                    local Subtract = Calculator:CreateElement("TextButton", "-", UDim2.fromScale(1 / 7, 0.1), UDim2.fromScale((1 / 7) * 1, 0.1))
                    Subtract.MouseButton1Click:Connect(function() Calculator:Query("-", true) end)
                    local Multiply = Calculator:CreateElement("TextButton", "×", UDim2.fromScale(1 / 7, 0.1), UDim2.fromScale((1 / 7) * 2, 0.1))
                    Multiply.MouseButton1Click:Connect(function() Calculator:Query("×", true) end)
                    local Divide = Calculator:CreateElement("TextButton", "÷", UDim2.fromScale(1 / 7, 0.1), UDim2.fromScale((1 / 7) * 3, 0.1))
                    Divide.MouseButton1Click:Connect(function() Calculator:Query("÷", true) end)
                    local Exponent = Calculator:CreateElement("TextButton", "^", UDim2.fromScale(1 / 7, 0.1), UDim2.fromScale((1 / 7) * 4, 0.1))
                    Exponent.MouseButton1Click:Connect(function() Calculator:Query("^", true) end)
                    local SquareRoot = Calculator:CreateElement("TextButton", "√", UDim2.fromScale(1 / 7, 0.1), UDim2.fromScale((1 / 7) * 5, 0.1))
                    SquareRoot.MouseButton1Click:Connect(function() Calculator:Query("√", true) end)
                    local Equal = Calculator:CreateElement("TextButton", "=", UDim2.fromScale(1 / 7, 0.1), UDim2.fromScale((1 / 7) * 6, 0.1))

                    local Nine = Calculator:CreateElement("TextButton", "9", UDim2.fromScale(1 / 3, 0.2), UDim2.fromScale(0, 0.2))
                    Nine.MouseButton1Click:Connect(function() Calculator:Query("9", false) end)
                    local Eight = Calculator:CreateElement("TextButton", "8", UDim2.fromScale(1 / 3, 0.2), UDim2.fromScale(1 / 3, 0.2))
                    Eight.MouseButton1Click:Connect(function() Calculator:Query("8", false) end)
                    local Seven = Calculator:CreateElement("TextButton", "7", UDim2.fromScale(1 / 3, 0.2), UDim2.fromScale((1 / 3) * 2, 0.2))
                    Seven.MouseButton1Click:Connect(function() Calculator:Query("7", false) end)
                    local Six = Calculator:CreateElement("TextButton", "6", UDim2.fromScale(1 / 3, 0.2), UDim2.fromScale(0, 0.4))
                    Six.MouseButton1Click:Connect(function() Calculator:Query("6", false) end)
                    local Five = Calculator:CreateElement("TextButton", "5", UDim2.fromScale(1 / 3, 0.2), UDim2.fromScale(1 / 3, 0.4))
                    Five.MouseButton1Click:Connect(function() Calculator:Query("5", false) end)
                    local Four = Calculator:CreateElement("TextButton", "4", UDim2.fromScale(1 / 3, 0.2), UDim2.fromScale((1 / 3) * 2, 0.4))
                    Four.MouseButton1Click:Connect(function() Calculator:Query("4", false) end)
                    local Three = Calculator:CreateElement("TextButton", "3", UDim2.fromScale(1 / 3, 0.2), UDim2.fromScale(0, 0.6))
                    Three.MouseButton1Click:Connect(function() Calculator:Query("3", false) end)
                    local Two = Calculator:CreateElement("TextButton", "2", UDim2.fromScale(1 / 3, 0.2), UDim2.fromScale(1 / 3, 0.6))
                    Two.MouseButton1Click:Connect(function() Calculator:Query("2", false) end)
                    local One = Calculator:CreateElement("TextButton", "1", UDim2.fromScale(1 / 3, 0.2), UDim2.fromScale((1 / 3) * 2, 0.6))
                    One.MouseButton1Click:Connect(function() Calculator:Query("1", false) end)
                    local Zero = Calculator:CreateElement("TextButton", "0", UDim2.fromScale(1, 0.2), UDim2.fromScale(0, 0.8))
                    Zero.MouseButton1Click:Connect(function() Calculator:Query("0", false) end)

                    local Clear = Calculator:CreateElement("TextButton", "CE", UDim2.fromScale(0.2, 0.2), UDim2.fromScale(0.8, 0.8))
                    Clear.MouseButton1Click:Connect(function()
                        Calculator.IsNum1 = true
                        Calculator.IsNum2 = false

                        Calculator.Num1 = nil
                        Calculator.Operation = nil
                        Calculator.Num2 = nil

                        Num1:Configure({Text=""})
                        Operation:Configure({Text=""})
                        Num2:Configure({Text=""})
                    end)
                end)

                zephyr.States.StartMenuOpened = true
            elseif zephyr.States.StartMenuOpened == true then
                StartMenu:Destroy()
                zephyr.States.StartMenuOpened = false
            end
        end)

        Beep(1)
        return success
    end)

    if not success then
        zephyr:CrashSystem(result)
    end
end

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

    wait(0.1)

    local CloseButton = Screen:CreateElement("TextButton", {
        Size=UDim2.fromScale(0.04, 1.2),
        Position=UDim2.fromScale(0, -0.1),
        BackgroundTransparency=1,
        TextColor3=Color3.fromRGB(255, 63, 63),
        TextStrokeColor3=Color3.fromRGB(255, 96, 96),
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

    function self:Destroy()
        Window:Destroy()
    end

    Beep(1)
    return WindowExtension
end

zephyr:Start()
