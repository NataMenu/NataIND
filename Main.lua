-- Aimbot API atualizada
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/src/Aimbot.lua"))()

if getgenv().NataMenu then return end
getgenv().NataMenu = true

--// Serviços
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local mouse = LocalPlayer:GetMouse()

--// ID do Decal Topográfico
local TOPOGRAPHIC_DECAL_ID = "124921377810103"

--// Configurações
local Config = {
    Aimbot = {
        Enabled = true,
        FOV = 100,
        Smoothness = 0.5,
        TargetPart = "Head",
        VisibleCheck = true,
        TeamCheck = true
    },
    Visuals = {
        Enabled = true,
        Boxes = true,
        Names = true,
        Health = true,
        Distance = true,
        Tracers = false,
        TeamCheck = true,
        MaxDistance = 1000
    },
    Misc = {
        NightMode = false,
        Fullbright = false,
        NoClip = false,
        WalkSpeed = 16,
        JumpPower = 50,
        FPSBoost = false,
        AutoClick = false,
        AntiAFK = true,
        Bypass = false
    }
}

--// Cores Tema TOPOGRÁFICO (Preto, Dourado e Tons Terrosos)
local GOLD_COLOR = Color3.fromRGB(212, 175, 55)        -- Dourado principal
local DARK_GOLD = Color3.fromRGB(180, 150, 50)         -- Dourado escuro
local LIGHT_GOLD = Color3.fromRGB(230, 200, 100)       -- Dourado claro
local BLACK_BG = Color3.fromRGB(10, 10, 10)            -- Preto profundo
local DARK_GRAY = Color3.fromRGB(30, 30, 30)           -- Cinza escuro
local TOPO_LINE = Color3.fromRGB(200, 170, 70)         -- Linhas topográficas
local TEXT_GOLD = Color3.fromRGB(240, 200, 80)         -- Texto dourado
local EARTH_BROWN = Color3.fromRGB(80, 60, 30)         -- Marrom terroso

--// Load Aimbot
local function LoadAimbot()
    local success, _ = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Raw%20Main.lua"))()
    end)
    
    if success and getgenv().Aimbot then
        local AB = getgenv().Aimbot
        AB.FOVSettings.Color = GOLD_COLOR          -- FOV dourado
        AB.FOVSettings.Visible = true
        AB.Enabled = Config.Aimbot.Enabled
        AB.FOV = Config.Aimbot.FOV
        AB.Smoothness = Config.Aimbot.Smoothness
        AB.TargetPart = Config.Aimbot.TargetPart
    end
end
LoadAimbot()

--// Bypass System
local function SetupBypass()
    if Config.Misc.Bypass then
        pcall(function()
            local mt = getrawmetatable(game)
            local oldNamecall = mt.__namecall
            
            setreadonly(mt, false)
            
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                local args = {...}
                
                if method == "Kick" or method == "kick" then
                    return nil
                end
                
                return oldNamecall(self, ...)
            end)
            
            setreadonly(mt, true)
        end)
    end
end

--// ESP
local ESP = {Drawings = {}}

-- Verificar se Drawing está disponível
local DrawingLib
if pcall(function() DrawingLib = Drawing or drawing end) and DrawingLib then
    function ESP:AddPlayer(player)
        if player == LocalPlayer then return end
        if not DrawingLib then return end
        
        self.Drawings[player] = {
            Box = DrawingLib.new("Square"),
            Name = DrawingLib.new("Text"),
            Health = DrawingLib.new("Text"),
            Distance = DrawingLib.new("Text")
        }
        
        -- Configurar propriedades iniciais
        for _, drawing in pairs(self.Drawings[player]) do
            drawing.Visible = false
            drawing.ZIndex = 1
        end
        
        self.Drawings[player].Name.Size = 14
        self.Drawings[player].Name.Outline = true
        self.Drawings[player].Name.Center = true
        
        self.Drawings[player].Health.Size = 14
        self.Drawings[player].Health.Outline = true
        self.Drawings[player].Health.Center = true
        
        self.Drawings[player].Distance.Size = 12
        self.Drawings[player].Distance.Outline = true
        self.Drawings[player].Distance.Center = true
    end

    function ESP:Update()
        if not Config.Visuals.Enabled then return end
        
        for player, drawings in pairs(self.Drawings) do
            if not player or not player.Parent or not player.Character then
                for _, d in pairs(drawings) do 
                    if d then d.Visible = false end
                end
                continue
            end
            
            local char = player.Character
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChild("Humanoid")
            
            if root and hum and hum.Health > 0 then
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                local dist = (Camera.CFrame.Position - root.Position).Magnitude
                
                if onScreen and dist <= Config.Visuals.MaxDistance then
                    local isTeam = Config.Visuals.TeamCheck and player.Team == LocalPlayer.Team
                    local color = isTeam and Color3.fromRGB(50, 200, 50) or GOLD_COLOR
                    
                    if Config.Visuals.Boxes and drawings.Box then
                        local size = Vector2.new(2000/dist * 2, 2000/dist * 3)
                        drawings.Box.Visible = true
                        drawings.Box.Size = size
                        drawings.Box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
                        drawings.Box.Color = color
                        drawings.Box.Thickness = 2
                        drawings.Box.Filled = false
                    elseif drawings.Box then
                        drawings.Box.Visible = false
                    end
                    
                    if Config.Visuals.Names and drawings.Name then
                        drawings.Name.Visible = true
                        drawings.Name.Text = player.Name
                        drawings.Name.Position = Vector2.new(pos.X, pos.Y - (2000/dist * 1.5) - 15)
                        drawings.Name.Color = TEXT_GOLD
                    elseif drawings.Name then
                        drawings.Name.Visible = false
                    end
                    
                    if Config.Visuals.Health and drawings.Health then
                        drawings.Health.Visible = true
                        drawings.Health.Text = math.floor(hum.Health) .. " HP"
                        drawings.Health.Position = Vector2.new(pos.X, pos.Y + (2000/dist * 1.5) + 5)
                        drawings.Health.Color = TEXT_GOLD
                    elseif drawings.Health then
                        drawings.Health.Visible = false
                    end
                    
                    if Config.Visuals.Distance and drawings.Distance then
                        drawings.Distance.Visible = true
                        drawings.Distance.Text = math.floor(dist) .. " studs"
                        drawings.Distance.Position = Vector2.new(pos.X, pos.Y + (2000/dist * 1.5) + 25)
                        drawings.Distance.Color = TEXT_GOLD
                    elseif drawings.Distance then
                        drawings.Distance.Visible = false
                    end
                else
                    for _, d in pairs(drawings) do 
                        if d then d.Visible = false end
                    end
                end
            else
                for _, d in pairs(drawings) do 
                    if d then d.Visible = false end
                end
            end
        end
    end

    RunService.RenderStepped:Connect(function() 
        pcall(function() 
            ESP:Update() 
        end) 
    end)
    
    for _, p in ipairs(Players:GetPlayers()) do 
        pcall(function() 
            ESP:AddPlayer(p) 
        end) 
    end
    
    Players.PlayerAdded:Connect(function(p)
        pcall(function() 
            ESP:AddPlayer(p) 
        end)
    end)
    
    Players.PlayerRemoving:Connect(function(p)
        pcall(function()
            if ESP.Drawings[p] then
                for _, d in pairs(ESP.Drawings[p]) do
                    if d then
                        d:Remove()
                    end
                end
                ESP.Drawings[p] = nil
            end
        end)
    end)
else
    warn("Drawing library not available. ESP features disabled.")
end

--// Funções Misc
local miscFunctions = {
    NightModeEnabled = false,
    FullbrightEnabled = false,
    NoClipEnabled = false,
    FPSBoostEnabled = false,
    AutoClickEnabled = false,
    AntiAFKEnabled = true
}

function miscFunctions:ToggleNightMode(state)
    if state then
        local cc = Lighting:FindFirstChild("NataMenu_NightMode")
        if not cc then
            cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "NataMenu_NightMode"
            cc.Parent = Lighting
        end
        cc.Brightness = -0.1
        cc.Contrast = 0.1
        cc.TintColor = Color3.fromRGB(150, 120, 50)
        cc.Saturation = -0.2
    else
        local cc = Lighting:FindFirstChild("NataMenu_NightMode")
        if cc then cc:Destroy() end
    end
end

function miscFunctions:ToggleFullbright(state)
    if state then
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(220, 200, 160)
        Lighting.Brightness = 1.5
        Lighting.ClockTime = 14
    else
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
    end
end

function miscFunctions:ToggleNoClip(state)
    Config.Misc.NoClip = state
end

function miscFunctions:SetWalkSpeed(speed)
    Config.Misc.WalkSpeed = speed
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
        end
    end
end

function miscFunctions:SetJumpPower(power)
    Config.Misc.JumpPower = power
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = power
        end
    end
end

function miscFunctions:ToggleFPSBoost(state)
    if state then
        settings().Rendering.QualityLevel = 1
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        if Workspace.Terrain then
            Workspace.Terrain.WaterReflection = false
            Workspace.Terrain.WaterWaveSize = 0
            Workspace.Terrain.WaterWaveSpeed = 0
        end
    else
        settings().Rendering.QualityLevel = 21
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
    end
end

function miscFunctions:ToggleAutoClick(state)
    Config.Misc.AutoClick = state
    if state then
        spawn(function()
            while Config.Misc.AutoClick do
                pcall(function()
                    mouse1click()
                end)
                wait(0.1)
            end
        end)
    end
end

function miscFunctions:ToggleAntiAFK(state)
    Config.Misc.AntiAFK = state
    if state then
        local VirtualUser = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            if Config.Misc.AntiAFK then
                VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
                wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            end
        end)
    end
end

function miscFunctions:ToggleBypass(state)
    Config.Misc.Bypass = state
    if state then
        SetupBypass()
    end
end

function miscFunctions:ShowCredits()
    local creditsGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    creditsGui.Name = "NataMenuCredits"
    
    local Main = Instance.new("Frame", creditsGui)
    Main.Size = UDim2.new(0, 300, 0, 200)
    Main.Position = UDim2.new(0.5, -150, 0.5, -100)
    Main.BackgroundColor3 = BLACK_BG
    Main.BorderSizePixel = 2
    Main.BorderColor3 = GOLD_COLOR
    
    -- Fundo topográfico nos créditos também
    local CreditsDecal = Instance.new("ImageLabel", Main)
    CreditsDecal.Size = UDim2.new(1, 0, 1, 0)
    CreditsDecal.Image = "rbxassetid://" .. TOPOGRAPHIC_DECAL_ID
    CreditsDecal.ImageTransparency = 0.7
    CreditsDecal.BackgroundTransparency = 1
    CreditsDecal.ScaleType = Enum.ScaleType.Tile
    CreditsDecal.TileSize = UDim2.new(0, 100, 0, 100)
    
    local Title = Instance.new("TextLabel", Main)
    Title.Text = "NATA.MENU - TOPOGRAPHIC"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.TextColor3 = TEXT_GOLD
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    Title.ZIndex = 2
    
    local Designer = Instance.new("TextLabel", Main)
    Designer.Text = "Designer: Farpa"
    Designer.Size = UDim2.new(1, 0, 0, 30)
    Designer.Position = UDim2.new(0, 0, 0, 60)
    Designer.TextColor3 = TEXT_GOLD
    Designer.Font = Enum.Font.SourceSans
    Designer.TextSize = 16
    Designer.BackgroundTransparency = 1
    Designer.ZIndex = 2
    
    local Programmer = Instance.new("TextLabel", Main)
    Programmer.Text = "Programmer: Toque"
    Programmer.Size = UDim2.new(1, 0, 0, 30)
    Programmer.Position = UDim2.new(0, 0, 0, 90)
    Programmer.TextColor3 = TEXT_GOLD
    Programmer.Font = Enum.Font.SourceSans
    Programmer.TextSize = 16
    Programmer.BackgroundTransparency = 1
    Programmer.ZIndex = 2
    
    local Version = Instance.new("TextLabel", Main)
    Version.Text = "Theme: Topographic Decal"
    Version.Size = UDim2.new(1, 0, 0, 30)
    Version.Position = UDim2.new(0, 0, 0, 120)
    Version.TextColor3 = TEXT_GOLD
    Version.Font = Enum.Font.SourceSans
    Version.TextSize = 14
    Version.BackgroundTransparency = 1
    Version.ZIndex = 2
    
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Text = "Close"
    CloseBtn.Size = UDim2.new(0, 80, 0, 30)
    CloseBtn.Position = UDim2.new(0.5, -40, 1, -40)
    CloseBtn.BackgroundColor3 = DARK_GOLD
    CloseBtn.TextColor3 = TEXT_GOLD
    CloseBtn.Font = Enum.Font.SourceSans
    CloseBtn.TextSize = 14
    CloseBtn.BorderSizePixel = 1
    CloseBtn.BorderColor3 = GOLD_COLOR
    CloseBtn.ZIndex = 2
    
    CloseBtn.MouseButton1Click:Connect(function()
        creditsGui:Destroy()
    end)
end

--// Menu UI
local Menu = {Tabs = {}}

function Menu:Init()
    local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    ScreenGui.Name = "NataMenu"
    ScreenGui.Enabled = true
    
    -- Frame principal
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 520, 0, 350)
    Main.Position = UDim2.new(0.5, -260, 0.5, -175)
    Main.BackgroundColor3 = BLACK_BG
    Main.BorderSizePixel = 2
    Main.BorderColor3 = GOLD_COLOR
    
    -- FUNDO TOPOGRÁFICO COM DECAL
    local TopographicBackground = Instance.new("ImageLabel", Main)
    TopographicBackground.Size = UDim2.new(1, 0, 1, 0)
    TopographicBackground.Image = "rbxassetid://" .. TOPOGRAPHIC_DECAL_ID
    TopographicBackground.BackgroundTransparency = 1
    TopographicBackground.ScaleType = Enum.ScaleType.Stretch  -- Ajusta ao tamanho do frame
    TopographicBackground.ImageTransparency = 0.1  -- Levemente transparente para não sobrecarregar
    
    -- Efeito de brilho suave no decal
    local BackgroundGradient = Instance.new("UIGradient", TopographicBackground)
    BackgroundGradient.Rotation = 90
    BackgroundGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(100, 100, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
    })
    BackgroundGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.5, 0.6),
        NumberSequenceKeypoint.new(1, 0.8)
    })
    
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Sidebar.BackgroundTransparency = 0.7
    Sidebar.BorderSizePixel = 1
    Sidebar.BorderColor3 = DARK_GOLD
    Sidebar.ZIndex = 2  -- Garantir que fique acima do fundo

    -- Logo com fundo escuro para melhor contraste
    local LogoFrame = Instance.new("Frame", Sidebar)
    LogoFrame.Size = UDim2.new(1, 0, 0, 100)
    LogoFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    LogoFrame.BackgroundTransparency = 0.3
    LogoFrame.BorderSizePixel = 1
    LogoFrame.BorderColor3 = GOLD_COLOR
    LogoFrame.ZIndex = 3
    
    local Logo = Instance.new("ImageLabel", LogoFrame)
    Logo.Size = UDim2.new(0.8, 0, 0.8, 0)
    Logo.Position = UDim2.new(0.1, 0, 0.1, 0)
    Logo.Image = "rbxassetid://89204033406625"
    Logo.BackgroundTransparency = 1
    Logo.ScaleType = Enum.ScaleType.Fit
    Logo.ZIndex = 3
    
    -- Efeito dourado no logo
    local LogoGlow = Instance.new("UIGradient", Logo)
    LogoGlow.Rotation = 90
    LogoGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 0))
    })
    LogoGlow.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.4),
        NumberSequenceKeypoint.new(0.5, 0.2),
        NumberSequenceKeypoint.new(1, 0.4)
    })

    local TabContainer = Instance.new("Frame", Sidebar)
    TabContainer.Position = UDim2.new(0, 0, 0, 110)
    TabContainer.Size = UDim2.new(1, 0, 1, -110)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ZIndex = 2
    
    local UIListLayout = Instance.new("UIListLayout", TabContainer)
    UIListLayout.Padding = UDim.new(0, 5)

    local ContentArea = Instance.new("ScrollingFrame", Main)
    ContentArea.Position = UDim2.new(0, 150, 0, 10)
    ContentArea.Size = UDim2.new(1, -160, 1, -20)
    ContentArea.BackgroundTransparency = 0.7
    ContentArea.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ContentArea.BorderSizePixel = 1
    ContentArea.BorderColor3 = DARK_GOLD
    ContentArea.ScrollBarThickness = 3
    ContentArea.ScrollBarImageColor3 = GOLD_COLOR
    ContentArea.ZIndex = 2
    
    local ContentLayout = Instance.new("UIListLayout", ContentArea)
    ContentLayout.Padding = UDim.new(0, 10)

    local function SyncAimbot()
        if getgenv().Aimbot then
            local AB = getgenv().Aimbot
            AB.Enabled = Config.Aimbot.Enabled
            AB.FOV = Config.Aimbot.FOV
            AB.Smoothness = Config.Aimbot.Smoothness
            AB.TargetPart = Config.Aimbot.TargetPart
        end
    end

    function Menu:CreateTab(name, icon)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        TabBtn.BackgroundTransparency = 0.3
        TabBtn.Text = icon .. " " .. name
        TabBtn.TextColor3 = TEXT_GOLD
        TabBtn.Font = Enum.Font.SourceSans
        TabBtn.TextSize = 13
        TabBtn.BorderSizePixel = 1
        TabBtn.BorderColor3 = DARK_GOLD
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.ZIndex = 3

        local Page = Instance.new("ScrollingFrame", ContentArea)
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.ScrollBarThickness = 0
        Page.BorderSizePixel = 0
        Page.ZIndex = 3
        
        local PageLayout = Instance.new("UIListLayout", Page)
        PageLayout.Padding = UDim.new(0, 10)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Menu.Tabs) do
                v.Page.Visible = false
                v.Btn.TextColor3 = TEXT_GOLD
                v.Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                v.Btn.BackgroundTransparency = 0.3
            end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.new(1, 1, 1)
            TabBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 30)
            TabBtn.BackgroundTransparency = 0.2
        end)

        Menu.Tabs[name] = {Page = Page, Btn = TabBtn}
        return Page
    end

    local function AddToggle(parent, text, default, callback)
        local Container = Instance.new("Frame", parent)
        Container.Size = UDim2.new(1, -10, 0, 35)
        Container.BackgroundTransparency = 1
        Container.BorderSizePixel = 0
        Container.ZIndex = 4
        
        local Btn = Instance.new("TextButton", Container)
        Btn.Size = UDim2.new(1, 0, 1, 0)
        Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Btn.BackgroundTransparency = 0.3
        Btn.Text = (default and "✓ " or "✗ ") .. text
        Btn.TextColor3 = default and TEXT_GOLD or Color3.fromRGB(150, 150, 130)
        Btn.Font = Enum.Font.SourceSans
        Btn.TextSize = 13
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.BorderSizePixel = 1
        Btn.BorderColor3 = DARK_GOLD
        Btn.ZIndex = 4

        Btn.MouseButton1Click:Connect(function()
            default = not default
            Btn.Text = (default and "✓ " or "✗ ") .. text
            Btn.TextColor3 = default and TEXT_GOLD or Color3.fromRGB(150, 150, 130)
            if callback then
                pcall(callback, default)
            end
        end)
        
        return Btn
    end

    local function AddSlider(parent, text, min, max, default, callback)
        local Container = Instance.new("Frame", parent)
        Container.Size = UDim2.new(1, -10, 0, 50)
        Container.BackgroundTransparency = 1
        Container.BorderSizePixel = 0
        Container.ZIndex = 4

        local Label = Instance.new("TextLabel", Container)
        Label.Text = "📏 " .. text .. ": " .. default
        Label.Size = UDim2.new(1, 0, 0, 20)
        Label.TextColor3 = TEXT_GOLD
        Label.BackgroundTransparency = 1
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Font = Enum.Font.SourceSans
        Label.TextSize = 13
        Label.BorderSizePixel = 0
        Label.ZIndex = 4

        local Bar = Instance.new("TextButton", Container)
        Bar.Position = UDim2.new(0, 0, 0, 25)
        Bar.Size = UDim2.new(1, 0, 0, 6)
        Bar.BackgroundColor3 = Color3.fromRGB(40, 40, 30)
        Bar.BackgroundTransparency = 0.3
        Bar.Text = ""
        Bar.BorderSizePixel = 1
        Bar.BorderColor3 = DARK_GOLD
        Bar.ZIndex = 4

        local Fill = Instance.new("Frame", Bar)
        Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        Fill.BackgroundColor3 = GOLD_COLOR
        Fill.BorderSizePixel = 0
        Fill.ZIndex = 4

        Bar.MouseButton1Down:Connect(function()
            local conn
            conn = RunService.RenderStepped:Connect(function()
                local mp = UserInputService:GetMouseLocation().X
                local per = math.clamp((mp - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X, 0, 1)
                local val = min + (max-min)*per
                if max <= 5 then 
                    val = tonumber(string.format("%.1f", val)) 
                else 
                    val = math.floor(val) 
                end
                Fill.Size = UDim2.new(per, 0, 1, 0)
                Label.Text = "📏 " .. text .. ": " .. val
                if callback then
                    pcall(callback, val)
                end
            end)
            
            local endedConn = UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    if conn then conn:Disconnect() end
                    endedConn:Disconnect()
                end
            end)
        end)
    end

    local function AddDropdown(parent, text, options, defaultIndex, callback)
        local Container = Instance.new("Frame", parent)
        Container.Size = UDim2.new(1, -10, 0, 35)
        Container.BackgroundTransparency = 1
        Container.BorderSizePixel = 0
        Container.ZIndex = 4

        local Btn = Instance.new("TextButton", Container)
        Btn.Size = UDim2.new(1, 0, 1, 0)
        Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Btn.BackgroundTransparency = 0.3
        Btn.Text = "▼ " .. text .. ": " .. options[defaultIndex or 1]
        Btn.TextColor3 = TEXT_GOLD
        Btn.Font = Enum.Font.SourceSans
        Btn.TextSize = 13
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.BorderSizePixel = 1
        Btn.BorderColor3 = DARK_GOLD
        Btn.ZIndex = 4

        local idx = defaultIndex or 1
        Btn.MouseButton1Click:Connect(function()
            idx = idx + 1
            if idx > #options then idx = 1 end
            Btn.Text = "▼ " .. text .. ": " .. options[idx]
            if callback then
                pcall(callback, options[idx])
            end
        end)
    end

    local function AddButton(parent, text, icon, callback)
        local Btn = Instance.new("TextButton", parent)
        Btn.Size = UDim2.new(1, -10, 0, 35)
        Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        Btn.BackgroundTransparency = 0.3
        Btn.Text = icon .. " " .. text
        Btn.TextColor3 = TEXT_GOLD
        Btn.Font = Enum.Font.SourceSans
        Btn.TextSize = 13
        Btn.BorderSizePixel = 1
        Btn.BorderColor3 = DARK_GOLD
        Btn.ZIndex = 4

        Btn.MouseButton1Click:Connect(function()
            if callback then
                pcall(callback)
            end
        end)
    end

    -- Abas
    local LegitPage = Menu:CreateTab("LegitBot", "🎯")
    AddToggle(LegitPage, "Aimbot", Config.Aimbot.Enabled, function(v) 
        Config.Aimbot.Enabled = v 
        SyncAimbot() 
    end)
    AddSlider(LegitPage, "Field of View", 10, 600, Config.Aimbot.FOV, function(v) 
        Config.Aimbot.FOV = v 
        SyncAimbot() 
    end)
    AddSlider(LegitPage, "Smoothness", 0, 5, Config.Aimbot.Smoothness, function(v) 
        Config.Aimbot.Smoothness = v 
        SyncAimbot() 
    end)
    AddDropdown(LegitPage, "Target Part", {"Head", "HumanoidRootPart", "Torso"}, 1, function(v) 
        Config.Aimbot.TargetPart = v 
        SyncAimbot() 
    end)
    AddToggle(LegitPage, "Team Check", Config.Aimbot.TeamCheck, function(v) 
        Config.Aimbot.TeamCheck = v 
        SyncAimbot() 
    end)

    local VisualPage = Menu:CreateTab("Visuals", "👁")
    AddToggle(VisualPage, "Enable ESP", Config.Visuals.Enabled, function(v) 
        Config.Visuals.Enabled = v 
    end)
    AddToggle(VisualPage, "Boxes", Config.Visuals.Boxes, function(v) 
        Config.Visuals.Boxes = v 
    end)
    AddToggle(VisualPage, "Names", Config.Visuals.Names, function(v) 
        Config.Visuals.Names = v 
    end)
    AddToggle(VisualPage, "Health", Config.Visuals.Health, function(v) 
        Config.Visuals.Health = v 
    end)
    AddToggle(VisualPage, "Team Check", Config.Visuals.TeamCheck, function(v) 
        Config.Visuals.TeamCheck = v 
    end)
    AddSlider(VisualPage, "Max Distance", 100, 5000, Config.Visuals.MaxDistance, function(v) 
        Config.Visuals.MaxDistance = v 
    end)

    -- Aba Misc
    local MiscPage = Menu:CreateTab("Misc", "⚙")

    local skyColors = {"Default", "Gold", "Amber", "Desert", "Sunset", "Topographic"}
    AddDropdown(MiscPage, "Sky Color", skyColors, 1, function(selected)
        pcall(function()
            local sky = Lighting:FindFirstChild("NataMenu_Sky")
            local cc = Lighting:FindFirstChild("NataMenu_SkyTint")
            
            if sky then sky:Destroy() end
            if cc then cc:Destroy() end

            if selected == "Default" then return end

            local colorMap = {
                Gold = Color3.fromRGB(212, 175, 55),
                Amber = Color3.fromRGB(255, 191, 0),
                Desert = Color3.fromRGB(194, 178, 128),
                Sunset = Color3.fromRGB(255, 140, 0),
                Topographic = Color3.fromRGB(150, 120, 60)
            }

            local targetColor = colorMap[selected]
            if targetColor then
                local newSky = Instance.new("Sky")
                newSky.Name = "NataMenu_Sky"
                newSky.Parent = Lighting
                newSky.CelestialBodiesShown = false

                local newCC = Instance.new("ColorCorrectionEffect")
                newCC.Name = "NataMenu_SkyTint"
                newCC.Parent = Lighting
                newCC.Enabled = true
                newCC.TintColor = targetColor
                newCC.Brightness = -0.05
            end
        end)
    end)

    -- Funções Misc
    AddToggle(MiscPage, "Night Mode", Config.Misc.NightMode, function(v)
        Config.Misc.NightMode = v
        miscFunctions:ToggleNightMode(v)
    end)

    AddToggle(MiscPage, "Fullbright", Config.Misc.Fullbright, function(v)
        Config.Misc.Fullbright = v
        miscFunctions:ToggleFullbright(v)
    end)

    AddToggle(MiscPage, "Noclip", Config.Misc.NoClip, function(v)
        Config.Misc.NoClip = v
        miscFunctions:ToggleNoClip(v)
    end)

    AddSlider(MiscPage, "Walk Speed", 16, 100, Config.Misc.WalkSpeed, function(v)
        Config.Misc.WalkSpeed = v
        miscFunctions:SetWalkSpeed(v)
    end)

    AddSlider(MiscPage, "Jump Power", 50, 200, Config.Misc.JumpPower, function(v)
        Config.Misc.JumpPower = v
        miscFunctions:SetJumpPower(v)
    end)

    AddToggle(MiscPage, "FPS Boost", Config.Misc.FPSBoost, function(v)
        Config.Misc.FPSBoost = v
        miscFunctions:ToggleFPSBoost(v)
    end)

    AddToggle(MiscPage, "Auto Click", Config.Misc.AutoClick, function(v)
        Config.Misc.AutoClick = v
        miscFunctions:ToggleAutoClick(v)
    end)

    AddToggle(MiscPage, "Anti-AFK", Config.Misc.AntiAFK, function(v)
        Config.Misc.AntiAFK = v
        miscFunctions:ToggleAntiAFK(v)
    end)

    AddToggle(MiscPage, "Bypass", Config.Misc.Bypass, function(v)
        Config.Misc.Bypass = v
        miscFunctions:ToggleBypass(v)
    end)

    -- Botões
    AddButton(MiscPage, "Refresh ESP", "🔄", function()
        if DrawingLib then
            for _, drawing in pairs(ESP.Drawings) do
                for _, d in pairs(drawing) do
                    if d then
                        d:Remove()
                    end
                end
            end
            ESP.Drawings = {}
            for _, p in ipairs(Players:GetPlayers()) do 
                pcall(function() 
                    ESP:AddPlayer(p) 
                end) 
            end
        end
    end)

    AddButton(MiscPage, "Copy Discord", "📋", function()
        pcall(function()
            setclipboard("discord.gg/natamenu")
        end)
    end)

    AddButton(MiscPage, "Hide Menu (F5)", "👁", function()
        ScreenGui.Enabled = not ScreenGui.Enabled
    end)

    AddButton(MiscPage, "Credits", "⭐", function()
        miscFunctions:ShowCredits()
    end)

    -- Abrir LegitBot por padrão
    Menu.Tabs["LegitBot"].Btn.TextColor3 = Color3.new(1, 1, 1)
    Menu.Tabs["LegitBot"].Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 30)
    Menu.Tabs["LegitBot"].Btn.BackgroundTransparency = 0.2
    Menu.Tabs["LegitBot"].Page.Visible = true

    -- Draggable
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Toggle F5
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F5 then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    -- Watermark com fundo topográfico
    local Watermark = Instance.new("ScreenGui", game:GetService("CoreGui"))
    Watermark.Name = "NataMenuWatermark"
    Watermark.Enabled = true
    
    local WatermarkFrame = Instance.new("Frame", Watermark)
    WatermarkFrame.Size = UDim2.new(0, 200, 0, 35)
    WatermarkFrame.Position = UDim2.new(1, -205, 0, 10)
    WatermarkFrame.BackgroundColor3 = BLACK_BG
    WatermarkFrame.BorderSizePixel = 2
    WatermarkFrame.BorderColor3 = GOLD_COLOR
    
    -- Fundo topográfico no watermark
    local WatermarkDecal = Instance.new("ImageLabel", WatermarkFrame)
    WatermarkDecal.Size = UDim2.new(1, 0, 1, 0)
    WatermarkDecal.Image = "rbxassetid://" .. TOPOGRAPHIC_DECAL_ID
    WatermarkDecal.ImageTransparency = 0.8
    WatermarkDecal.BackgroundTransparency = 1
    WatermarkDecal.ScaleType = Enum.ScaleType.Stretch
    
    local WatermarkLabel = Instance.new("TextLabel", WatermarkFrame)
    WatermarkLabel.Size = UDim2.new(1, 0, 1, 0)
    WatermarkLabel.Text = "🗺️ TOPOGRAPHIC v1.0"
    WatermarkLabel.TextColor3 = TEXT_GOLD
    WatermarkLabel.Font = Enum.Font.SourceSansBold
    WatermarkLabel.TextSize = 12
    WatermarkLabel.BackgroundTransparency = 1
    WatermarkLabel.ZIndex = 2

    -- Créditos
    local Credits = Instance.new("TextLabel", ScreenGui)
    Credits.Text = "Designer: Farpa | Programmer: Toque | Decal: " .. TOPOGRAPHIC_DECAL_ID
    Credits.Size = UDim2.new(0, 350, 0, 20)
    Credits.Position = UDim2.new(1, -360, 0, 50)
    Credits.BackgroundTransparency = 1
    Credits.TextColor3 = TEXT_GOLD
    Credits.Font = Enum.Font.SourceSans
    Credits.TextSize = 11
    Credits.BorderSizePixel = 0
    Credits.ZIndex = 2
end

-- Inicializar menu
pcall(function()
    Menu:Init()
end)

-- Conector NoClip
RunService.Stepped:Connect(function()
    if Config.Misc.NoClip and LocalPlayer.Character then
        local char = LocalPlayer.Character
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Atualizar WalkSpeed/JumpPower
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Config.Misc.WalkSpeed
            humanoid.JumpPower = Config.Misc.JumpPower
        end
    end
end)

-- Iniciar AntiAFK
miscFunctions:ToggleAntiAFK(true)

print("╔══════════════════════════════════════════════╗")
print("║          NATA.MENU TOPOGRAPHIC              ║")
print("║   🎯 LegitBot   👁 Visuals                 ║")
print("║   ⚙ Misc        🚀 Loaded!                 ║")
print("║   🗺️ Custom Topographic Decal             ║")
print("║   🔲 Decal ID: " .. TOPOGRAPHIC_DECAL_ID .. "          ║")
print("║   ⚫ BLACK BACKGROUND                       ║")
print("║   🟡 GOLDEN LINES                          ║")
print("╚══════════════════════════════════════════════╝")
print("F5 - Toggle Menu")
print("Designer: Farpa | Programmer: Toque")
print("Topographic Decal ID: " .. TOPOGRAPHIC_DECAL_ID)
