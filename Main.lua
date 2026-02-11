-- Obfuscated Script - NATA.MENU v4.0
-- Designer: Farpa | Programmer: Toque

local _G = getfenv()
local _0x1 = game
local _0x2 = _0x1:GetService("RunService")
local _0x3 = _0x1:GetService("UserInputService")
local _0x4 = _0x1:GetService("Players")
local _0x5 = _0x1:GetService("Workspace")
local _0x6 = _0x1:GetService("Lighting")
local _0x7 = _0x4.LocalPlayer
local _0x8 = _0x5.CurrentCamera
local _0x9 = _0x7:GetMouse()

loadstring(_0x1:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V3/main/src/Aimbot.lua"))()

if getgenv().NataMenu then return end
getgenv().NataMenu = true

local _0xa = "74558347340509"
local _0xb = "72274485277843"

local _0xc = {
    Active = false,
    SavedConfig = nil
}

local _0xd = {
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
        Mode = "Internal",
        Boxes = true,
        Names = true,
        Health = true,
        Distance = true,
        Tracers = false,
        Highlight = true,
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

local _0xe = Color3.fromRGB(212, 175, 55)
local _0xf = Color3.fromRGB(180, 150, 50)
local _0x10 = Color3.fromRGB(230, 200, 100)
local _0x11 = Color3.fromRGB(0, 0, 0)
local _0x12 = Color3.fromRGB(15, 15, 15)
local _0x13 = Color3.fromRGB(80, 60, 30)
local _0x14 = Color3.fromRGB(240, 200, 80)
local _0x15 = Color3.fromRGB(255, 50, 50)

local function _0x16()
    local success, _ = pcall(function()
        loadstring(_0x1:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Raw%20Main.lua"))()
    end)
    
    if success and getgenv().Aimbot then
        local AB = getgenv().Aimbot
        AB.FOVSettings.Color = _0xe
        AB.FOVSettings.Visible = true
        AB.Enabled = _0xd.Aimbot.Enabled
        AB.FOV = _0xd.Aimbot.FOV
        AB.Smoothness = _0xd.Aimbot.Smoothness
        AB.TargetPart = _0xd.Aimbot.TargetPart
    end
end
_0x16()

local function _0x17()
    if _0xd.Misc.Bypass then
        pcall(function()
            local mt = getrawmetatable(_0x1)
            local oldNamecall = mt.__namecall
            
            setreadonly(mt, false)
            
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                
                if method == "Kick" or method == "kick" then
                    return nil
                end
                
                return oldNamecall(self, ...)
            end)
            
            setreadonly(mt, true)
        end)
    end
end

local _0x18 = Drawing or drawing
local _0x19 = {
    Drawings = {},
    Enabled = false
}

if _0x18 then
    function _0x19:AddPlayer(player)
        if player == _0x7 then return end
        if self.Drawings[player] then return end
        
        self.Drawings[player] = {
            Box = _0x18.new("Square"),
            Name = _0x18.new("Text"),
            Health = _0x18.new("Text"),
            Distance = _0x18.new("Text"),
            Tracer = _0x18.new("Line")
        }
        
        for _, drawing in pairs(self.Drawings[player]) do
            drawing.Visible = false
            drawing.ZIndex = 1
        end
        
        self.Drawings[player].Box.Thickness = 2
        self.Drawings[player].Box.Filled = false
        
        self.Drawings[player].Name.Size = 14
        self.Drawings[player].Name.Outline = true
        self.Drawings[player].Name.Center = true
        
        self.Drawings[player].Health.Size = 14
        self.Drawings[player].Health.Outline = true
        self.Drawings[player].Health.Center = true
        
        self.Drawings[player].Distance.Size = 12
        self.Drawings[player].Distance.Outline = true
        self.Drawings[player].Distance.Center = true
        
        self.Drawings[player].Tracer.Thickness = 1
    end

    function _0x19:Update()
        if not _0xd.Visuals.Enabled or _0xc.Active then
            for _, drawings in pairs(self.Drawings) do
                for _, d in pairs(drawings) do 
                    if d then d.Visible = false end
                end
            end
            return
        end
        
        if _0xd.Visuals.Mode ~= "Drawing" and _0xd.Visuals.Mode ~= "Hybrid" then
            for _, drawings in pairs(self.Drawings) do
                for _, d in pairs(drawings) do 
                    if d then d.Visible = false end
                end
            end
            return
        end
        
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
                local pos, onScreen = _0x8:WorldToViewportPoint(root.Position)
                local dist = (_0x8.CFrame.Position - root.Position).Magnitude
                
                if onScreen and dist <= _0xd.Visuals.MaxDistance then
                    local isTeam = _0xd.Visuals.TeamCheck and player.Team == _0x7.Team
                    local color = isTeam and Color3.fromRGB(50, 200, 50) or _0xe
                    
                    if _0xd.Visuals.Boxes and drawings.Box then
                        local size = Vector2.new(2000/dist * 2, 2000/dist * 3)
                        drawings.Box.Visible = true
                        drawings.Box.Size = size
                        drawings.Box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
                        drawings.Box.Color = color
                    elseif drawings.Box then
                        drawings.Box.Visible = false
                    end
                    
                    if _0xd.Visuals.Names and drawings.Name then
                        drawings.Name.Visible = true
                        drawings.Name.Text = player.Name
                        drawings.Name.Position = Vector2.new(pos.X, pos.Y - (2000/dist * 1.5) - 15)
                        drawings.Name.Color = _0x14
                    elseif drawings.Name then
                        drawings.Name.Visible = false
                    end
                    
                    if _0xd.Visuals.Health and drawings.Health then
                        local healthPercent = hum.Health / hum.MaxHealth
                        drawings.Health.Visible = true
                        drawings.Health.Text = math.floor(hum.Health) .. " HP"
                        drawings.Health.Position = Vector2.new(pos.X, pos.Y + (2000/dist * 1.5) + 5)
                        drawings.Health.Color = Color3.fromRGB(
                            255 * (1 - healthPercent),
                            255 * healthPercent,
                            0
                        )
                    elseif drawings.Health then
                        drawings.Health.Visible = false
                    end
                    
                    if _0xd.Visuals.Distance and drawings.Distance then
                        drawings.Distance.Visible = true
                        drawings.Distance.Text = math.floor(dist) .. " studs"
                        drawings.Distance.Position = Vector2.new(pos.X, pos.Y + (2000/dist * 1.5) + 25)
                        drawings.Distance.Color = _0x14
                    elseif drawings.Distance then
                        drawings.Distance.Visible = false
                    end
                    
                    if _0xd.Visuals.Tracers and drawings.Tracer then
                        drawings.Tracer.Visible = true
                        drawings.Tracer.From = Vector2.new(_0x8.ViewportSize.X/2, _0x8.ViewportSize.Y)
                        drawings.Tracer.To = Vector2.new(pos.X, pos.Y)
                        drawings.Tracer.Color = color
                    elseif drawings.Tracer then
                        drawings.Tracer.Visible = false
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

    function _0x19:RemovePlayer(player)
        if self.Drawings[player] then
            for _, d in pairs(self.Drawings[player]) do
                if d then d:Remove() end
            end
            self.Drawings[player] = nil
        end
    end

    function _0x19:ClearAll()
        for player, _ in pairs(self.Drawings) do
            self:RemovePlayer(player)
        end
    end
end

local _0x1a = {
    Objects = {},
    Folder = nil
}

function _0x1a:Init()
    self.Folder = Instance.new("Folder")
    self.Folder.Name = "ESPStorage_" .. _0x1:GetService("HttpService"):GenerateGUID(false)
    self.Folder.Parent = _0x1:GetService("CoreGui")
end

function _0x1a:AddPlayer(player)
    if player == _0x7 then return end
    if self.Objects[player] then return end
    
    self.Objects[player] = {}
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. player.Name
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 100)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = self.Folder
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0.3, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.TextColor3 = _0x14
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextSize = 16
    nameLabel.Text = player.Name
    nameLabel.Parent = billboard
    
    local healthLabel = Instance.new("TextLabel")
    healthLabel.Size = UDim2.new(1, 0, 0.3, 0)
    healthLabel.Position = UDim2.new(0, 0, 0.3, 0)
    healthLabel.BackgroundTransparency = 1
    healthLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    healthLabel.TextStrokeTransparency = 0.5
    healthLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    healthLabel.Font = Enum.Font.SourceSans
    healthLabel.TextSize = 14
    healthLabel.Parent = billboard
    
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0.3, 0)
    distLabel.Position = UDim2.new(0, 0, 0.6, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.TextColor3 = _0x14
    distLabel.TextStrokeTransparency = 0.5
    distLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    distLabel.Font = Enum.Font.SourceSans
    distLabel.TextSize = 12
    distLabel.Parent = billboard
    
    self.Objects[player].Billboard = billboard
    self.Objects[player].NameLabel = nameLabel
    self.Objects[player].HealthLabel = healthLabel
    self.Objects[player].DistLabel = distLabel
    
    local box = Instance.new("SelectionBox")
    box.LineThickness = 0.03
    box.Color3 = _0xe
    box.SurfaceTransparency = 0.9
    box.Parent = self.Folder
    
    self.Objects[player].Box = box
    
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0.3
    highlight.FillColor = _0xe
    highlight.OutlineColor = _0x10
    highlight.Parent = self.Folder
    
    self.Objects[player].Highlight = highlight
end

function _0x1a:Update()
    if not _0xd.Visuals.Enabled or _0xc.Active then
        for _, obj in pairs(self.Objects) do
            if obj.Billboard then obj.Billboard.Enabled = false end
            if obj.Box then obj.Box.Visible = false end
            if obj.Highlight then obj.Highlight.Enabled = false end
        end
        return
    end
    
    if _0xd.Visuals.Mode ~= "Internal" and _0xd.Visuals.Mode ~= "Hybrid" then
        for _, obj in pairs(self.Objects) do
            if obj.Billboard then obj.Billboard.Enabled = false end
            if obj.Box then obj.Box.Visible = false end
            if obj.Highlight then obj.Highlight.Enabled = false end
        end
        return
    end
    
    for player, obj in pairs(self.Objects) do
        if not player or not player.Parent or not player.Character then
            if obj.Billboard then obj.Billboard.Enabled = false end
            if obj.Box then obj.Box.Visible = false end
            if obj.Highlight then obj.Highlight.Enabled = false end
            continue
        end
        
        local char = player.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        
        if root and hum and hum.Health > 0 then
            local dist = (_0x8.CFrame.Position - root.Position).Magnitude
            local isTeam = _0xd.Visuals.TeamCheck and player.Team == _0x7.Team
            
            if dist <= _0xd.Visuals.MaxDistance then
                local color = isTeam and Color3.fromRGB(50, 200, 50) or _0xe
                
                if _0xd.Visuals.Names or _0xd.Visuals.Health or _0xd.Visuals.Distance then
                    obj.Billboard.Enabled = true
                    obj.Billboard.Adornee = root
                    
                    obj.NameLabel.Visible = _0xd.Visuals.Names
                    obj.HealthLabel.Visible = _0xd.Visuals.Health
                    obj.DistLabel.Visible = _0xd.Visuals.Distance
                    
                    if _0xd.Visuals.Health then
                        local healthPercent = hum.Health / hum.MaxHealth
                        obj.HealthLabel.Text = math.floor(hum.Health) .. " HP"
                        obj.HealthLabel.TextColor3 = Color3.fromRGB(
                            255 * (1 - healthPercent),
                            255 * healthPercent,
                            0
                        )
                    end
                    
                    if _0xd.Visuals.Distance then
                        obj.DistLabel.Text = math.floor(dist) .. " studs"
                    end
                else
                    obj.Billboard.Enabled = false
                end
                
                if _0xd.Visuals.Boxes and obj.Box then
                    obj.Box.Visible = true
                    obj.Box.Adornee = char
                    obj.Box.Color3 = color
                else
                    obj.Box.Visible = false
                end
                
                if _0xd.Visuals.Highlight and obj.Highlight then
                    obj.Highlight.Enabled = true
                    obj.Highlight.Adornee = char
                    obj.Highlight.FillColor = color
                    obj.Highlight.OutlineColor = isTeam and Color3.fromRGB(100, 255, 100) or _0x10
                else
                    obj.Highlight.Enabled = false
                end
            else
                obj.Billboard.Enabled = false
                if obj.Box then obj.Box.Visible = false end
                if obj.Highlight then obj.Highlight.Enabled = false end
            end
        else
            obj.Billboard.Enabled = false
            if obj.Box then obj.Box.Visible = false end
            if obj.Highlight then obj.Highlight.Enabled = false end
        end
    end
end

function _0x1a:RemovePlayer(player)
    if self.Objects[player] then
        if self.Objects[player].Billboard then self.Objects[player].Billboard:Destroy() end
        if self.Objects[player].Box then self.Objects[player].Box:Destroy() end
        if self.Objects[player].Highlight then self.Objects[player].Highlight:Destroy() end
        self.Objects[player] = nil
    end
end

function _0x1a:ClearAll()
    for player, _ in pairs(self.Objects) do
        self:RemovePlayer(player)
    end
end

_0x1a:Init()

_0x2.RenderStepped:Connect(function()
    pcall(function()
        _0x1a:Update()
        if _0x18 then
            _0x19:Update()
        end
    end)
end)

for _, p in ipairs(_0x4:GetPlayers()) do
    pcall(function()
        _0x1a:AddPlayer(p)
        if _0x18 then
            _0x19:AddPlayer(p)
        end
    end)
end

_0x4.PlayerAdded:Connect(function(p)
    pcall(function()
        _0x1a:AddPlayer(p)
        if _0x18 then
            _0x19:AddPlayer(p)
        end
    end)
end)

_0x4.PlayerRemoving:Connect(function(p)
    pcall(function()
        _0x1a:RemovePlayer(p)
        if _0x18 then
            _0x19:RemovePlayer(p)
        end
    end)
end)

function _0xc:Activate()
    if self.Active then return end
    
    print("🚨 PANIC MODE ATIVADO! Desativando tudo...")
    
    self.Active = true
    
    self.SavedConfig = {
        Aimbot = {
            Enabled = _0xd.Aimbot.Enabled,
            FOV = _0xd.Aimbot.FOV,
            Smoothness = _0xd.Aimbot.Smoothness,
        },
        Visuals = {
            Enabled = _0xd.Visuals.Enabled,
            Mode = _0xd.Visuals.Mode,
            Boxes = _0xd.Visuals.Boxes,
            Names = _0xd.Visuals.Names,
            Health = _0xd.Visuals.Health,
            Highlight = _0xd.Visuals.Highlight,
        },
        Misc = {
            NightMode = _0xd.Misc.NightMode,
            Fullbright = _0xd.Misc.Fullbright,
            NoClip = _0xd.Misc.NoClip,
            WalkSpeed = _0xd.Misc.WalkSpeed,
            JumpPower = _0xd.Misc.JumpPower,
            FPSBoost = _0xd.Misc.FPSBoost,
            AutoClick = _0xd.Misc.AutoClick,
        }
    }
    
    _0xd.Aimbot.Enabled = false
    if getgenv().Aimbot then
        getgenv().Aimbot.Enabled = false
        getgenv().Aimbot.FOVSettings.Visible = false
    end
    
    _0xd.Visuals.Enabled = false
    _0xd.Visuals.Boxes = false
    _0xd.Visuals.Names = false
    _0xd.Visuals.Health = false
    _0xd.Visuals.Highlight = false
    
    _0xd.Misc.NoClip = false
    _0xd.Misc.AutoClick = false
    
    if _0x7.Character then
        local humanoid = _0x7.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
    
    pcall(function()
        local cc = _0x6:FindFirstChild("NataMenu_NightMode")
        if cc then cc:Destroy() end
        
        local sky = _0x6:FindFirstChild("NataMenu_Sky")
        if sky then sky:Destroy() end
        
        local skyTint = _0x6:FindFirstChild("NataMenu_SkyTint")
        if skyTint then skyTint:Destroy() end
    end)
    
    _0x6.GlobalShadows = true
    _0x6.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    _0x6.Brightness = 1
    
    pcall(function()
        local screenGui = _0x1:GetService("CoreGui"):FindFirstChild("NataMenu")
        if screenGui then screenGui.Enabled = false end
        
        local watermark = _0x1:GetService("CoreGui"):FindFirstChild("NataMenuWatermark")
        if watermark then watermark.Enabled = false end
    end)
    
    print("✅ PANIC MODE: Tudo desativado! Você está clean!")
end

function _0xc:Deactivate()
    if not self.Active then return end
    
    print("🔄 PANIC MODE DESATIVADO! Restaurando configurações...")
    
    self.Active = false
    
    if self.SavedConfig then
        _0xd.Aimbot.Enabled = self.SavedConfig.Aimbot.Enabled
        _0xd.Aimbot.FOV = self.SavedConfig.Aimbot.FOV
        _0xd.Aimbot.Smoothness = self.SavedConfig.Aimbot.Smoothness
        
        _0xd.Visuals.Enabled = self.SavedConfig.Visuals.Enabled
        _0xd.Visuals.Mode = self.SavedConfig.Visuals.Mode
        _0xd.Visuals.Boxes = self.SavedConfig.Visuals.Boxes
        _0xd.Visuals.Names = self.SavedConfig.Visuals.Names
        _0xd.Visuals.Health = self.SavedConfig.Visuals.Health
        _0xd.Visuals.Highlight = self.SavedConfig.Visuals.Highlight
        
        _0xd.Misc.NightMode = self.SavedConfig.Misc.NightMode
        _0xd.Misc.Fullbright = self.SavedConfig.Misc.Fullbright
        _0xd.Misc.NoClip = self.SavedConfig.Misc.NoClip
        _0xd.Misc.WalkSpeed = self.SavedConfig.Misc.WalkSpeed
        _0xd.Misc.JumpPower = self.SavedConfig.Misc.JumpPower
        _0xd.Misc.FPSBoost = self.SavedConfig.Misc.FPSBoost
        _0xd.Misc.AutoClick = self.SavedConfig.Misc.AutoClick
        
        if getgenv().Aimbot then
            getgenv().Aimbot.Enabled = _0xd.Aimbot.Enabled
            getgenv().Aimbot.FOV = _0xd.Aimbot.FOV
            getgenv().Aimbot.Smoothness = _0xd.Aimbot.Smoothness
            getgenv().Aimbot.FOVSettings.Visible = _0xd.Aimbot.Enabled
        end
        
        if _0x7.Character then
            local humanoid = _0x7.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = _0xd.Misc.WalkSpeed
                humanoid.JumpPower = _0xd.Misc.JumpPower
            end
        end
    end
    
    pcall(function()
        local screenGui = _0x1:GetService("CoreGui"):FindFirstChild("NataMenu")
        if screenGui then screenGui.Enabled = true end
        
        local watermark = _0x1:GetService("CoreGui"):FindFirstChild("NataMenuWatermark")
        if watermark then watermark.Enabled = true end
    end)
    
    print("✅ Configurações restauradas!")
end

function _0xc:Toggle()
    if self.Active then
        self:Deactivate()
    else
        self:Activate()
    end
end

local _0x1b = {}

function _0x1b:ToggleNightMode(state)
    if state then
        local cc = _0x6:FindFirstChild("NataMenu_NightMode")
        if not cc then
            cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "NataMenu_NightMode"
            cc.Parent = _0x6
        end
        cc.Brightness = -0.1
        cc.Contrast = 0.1
        cc.TintColor = Color3.fromRGB(150, 120, 50)
        cc.Saturation = -0.2
    else
        local cc = _0x6:FindFirstChild("NataMenu_NightMode")
        if cc then cc:Destroy() end
    end
end

function _0x1b:ToggleFullbright(state)
    if state then
        _0x6.GlobalShadows = false
        _0x6.OutdoorAmbient = Color3.fromRGB(220, 200, 160)
        _0x6.Brightness = 1.5
        _0x6.ClockTime = 14
    else
        _0x6.GlobalShadows = true
        _0x6.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        _0x6.Brightness = 1
        _0x6.ClockTime = 14
    end
end

function _0x1b:ToggleNoClip(state)
    _0xd.Misc.NoClip = state
end

function _0x1b:SetWalkSpeed(speed)
    _0xd.Misc.WalkSpeed = speed
    local character = _0x7.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = speed
        end
    end
end

function _0x1b:SetJumpPower(power)
    _0xd.Misc.JumpPower = power
    local character = _0x7.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = power
        end
    end
end

function _0x1b:ToggleFPSBoost(state)
    if state then
        settings().Rendering.QualityLevel = 1
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
        if _0x5.Terrain then
            _0x5.Terrain.WaterReflection = false
            _0x5.Terrain.WaterWaveSize = 0
            _0x5.Terrain.WaterWaveSpeed = 0
        end
    else
        settings().Rendering.QualityLevel = 21
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
    end
end

function _0x1b:ToggleAutoClick(state)
    _0xd.Misc.AutoClick = state
    if state then
        spawn(function()
            while _0xd.Misc.AutoClick do
                pcall(function()
                    mouse1click()
                end)
                wait(0.1)
            end
        end)
    end
end

function _0x1b:ToggleAntiAFK(state)
    _0xd.Misc.AntiAFK = state
    if state then
        local VirtualUser = _0x1:GetService("VirtualUser")
        _0x7.Idled:Connect(function()
            if _0xd.Misc.AntiAFK then
                VirtualUser:Button2Down(Vector2.new(0,0), _0x5.CurrentCamera.CFrame)
                wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), _0x5.CurrentCamera.CFrame)
            end
        end)
    end
end

function _0x1b:ToggleBypass(state)
    _0xd.Misc.Bypass = state
    if state then
        _0x17()
    end
end

function _0x1b:ShowCredits()
    local creditsGui = Instance.new("ScreenGui", _0x1:GetService("CoreGui"))
    creditsGui.Name = "NataMenuCredits"
    
    local Main = Instance.new("Frame", creditsGui)
    Main.Size = UDim2.new(0, 320, 0, 250)
    Main.Position = UDim2.new(0.5, -160, 0.5, -125)
    Main.BackgroundColor3 = _0x11
    Main.BorderSizePixel = 2
    Main.BorderColor3 = _0xe
    
    local CreditsDecal = Instance.new("ImageLabel", Main)
    CreditsDecal.Size = UDim2.new(1, 0, 1, 0)
    CreditsDecal.Image = "rbxassetid://" .. _0xb
    CreditsDecal.ImageTransparency = 0.7
    CreditsDecal.BackgroundTransparency = 1
    CreditsDecal.ScaleType = Enum.ScaleType.Tile
    CreditsDecal.TileSize = UDim2.new(0, 100, 0, 100)
    
    local Title = Instance.new("TextLabel", Main)
    Title.Text = "NATA.MENU - HYBRID ESP"
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.TextColor3 = _0x14
    Title.Font = Enum.Font.SourceSansBold
    Title.TextSize = 18
    Title.BackgroundTransparency = 1
    Title.ZIndex = 2
    
    local Designer = Instance.new("TextLabel", Main)
    Designer.Text = "Designer: Farpa"
    Designer.Size = UDim2.new(1, 0, 0, 30)
    Designer.Position = UDim2.new(0, 0, 0, 55)
    Designer.TextColor3 = _0x14
    Designer.Font = Enum.Font.SourceSans
    Designer.TextSize = 16
    Designer.BackgroundTransparency = 1
    Designer.ZIndex = 2
    
    local Programmer = Instance.new("TextLabel", Main)
    Programmer.Text = "Programmer: Toque"
    Programmer.Size = UDim2.new(1, 0, 0, 30)
    Programmer.Position = UDim2.new(0, 0, 0, 85)
    Programmer.TextColor3 = _0x14
    Programmer.Font = Enum.Font.SourceSans
    Programmer.TextSize = 16
    Programmer.BackgroundTransparency = 1
    Programmer.ZIndex = 2
    
    local ESPInfo = Instance.new("TextLabel", Main)
    ESPInfo.Text = "✨ Internal + Drawing ESP"
    ESPInfo.Size = UDim2.new(1, 0, 0, 30)
    ESPInfo.Position = UDim2.new(0, 0, 0, 115)
    ESPInfo.TextColor3 = _0x14
    ESPInfo.Font = Enum.Font.SourceSans
    ESPInfo.TextSize = 14
    ESPInfo.BackgroundTransparency = 1
    ESPInfo.ZIndex = 2
    
    local ModeInfo = Instance.new("TextLabel", Main)
    ModeInfo.Text = "🎯 3 Modos: Internal/Drawing/Hybrid"
    ModeInfo.Size = UDim2.new(1, 0, 0, 30)
    ModeInfo.Position = UDim2.new(0, 0, 0, 145)
    ModeInfo.TextColor3 = _0x10
    ModeInfo.Font = Enum.Font.SourceSans
    ModeInfo.TextSize = 13
    ModeInfo.BackgroundTransparency = 1
    ModeInfo.ZIndex = 2
    
    local PanicInfo = Instance.new("TextLabel", Main)
    PanicInfo.Text = "🚨 PANIC MODE: F6"
    PanicInfo.Size = UDim2.new(1, 0, 0, 30)
    PanicInfo.Position = UDim2.new(0, 0, 0, 175)
    PanicInfo.TextColor3 = _0x15
    PanicInfo.Font = Enum.Font.SourceSansBold
    PanicInfo.TextSize = 14
    PanicInfo.BackgroundTransparency = 1
    PanicInfo.ZIndex = 2
    
    local CloseBtn = Instance.new("TextButton", Main)
    CloseBtn.Text = "Close"
    CloseBtn.Size = UDim2.new(0, 80, 0, 30)
    CloseBtn.Position = UDim2.new(0.5, -40, 1, -40)
    CloseBtn.BackgroundColor3 = _0xf
    CloseBtn.TextColor3 = _0x14
    CloseBtn.Font = Enum.Font.SourceSans
    CloseBtn.TextSize = 14
    CloseBtn.BorderSizePixel = 1
    CloseBtn.BorderColor3 = _0xe
    CloseBtn.ZIndex = 2
    
    CloseBtn.MouseButton1Click:Connect(function()
        creditsGui:Destroy()
    end)
end

local _0x1c = {Tabs = {}}

function _0x1c:Init()
    local ScreenGui = Instance.new("ScreenGui", _0x1:GetService("CoreGui"))
    ScreenGui.Name = "NataMenu"
    ScreenGui.Enabled = true
    
    local Main = Instance.new("Frame", ScreenGui)
    Main.Size = UDim2.new(0, 520, 0, 350)
    Main.Position = UDim2.new(0.5, -260, 0.5, -175)
    Main.BackgroundColor3 = _0x11
    Main.BorderSizePixel = 2
    Main.BorderColor3 = _0xe
    
    local BackgroundImage = Instance.new("ImageLabel", Main)
    BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
    BackgroundImage.Image = "rbxassetid://" .. _0xb
    BackgroundImage.BackgroundTransparency = 1
    BackgroundImage.ScaleType = Enum.ScaleType.Stretch
    BackgroundImage.ImageTransparency = 0.15
    
    local DarkOverlay = Instance.new("Frame", Main)
    DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
    DarkOverlay.BackgroundColor3 = _0x11
    DarkOverlay.BackgroundTransparency = 0.3
    
    local BackgroundGradient = Instance.new("UIGradient", DarkOverlay)
    BackgroundGradient.Rotation = 90
    BackgroundGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 20, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    })
    BackgroundGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(0.5, 0.5),
        NumberSequenceKeypoint.new(1, 0.7)
    })
    
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    Sidebar.BackgroundTransparency = 0.8
    Sidebar.BorderSizePixel = 1
    Sidebar.BorderColor3 = _0xf
    Sidebar.ZIndex = 2

    local LogoFrame = Instance.new("Frame", Sidebar)
    LogoFrame.Size = UDim2.new(1, 0, 0, 100)
    LogoFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LogoFrame.BackgroundTransparency = 0.4
    LogoFrame.BorderSizePixel = 1
    LogoFrame.BorderColor3 = _0xe
    LogoFrame.ZIndex = 3
    
    local LogoContainer = Instance.new("Frame", LogoFrame)
    LogoContainer.Size = UDim2.new(0.8, 0, 0.8, 0)
    LogoContainer.Position = UDim2.new(0.1, 0, 0.1, 0)
    LogoContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.ClipsDescendants = true
    
    local Corner = Instance.new("UICorner", LogoContainer)
    Corner.CornerRadius = UDim.new(0, 12)
    
    local Logo = Instance.new("ImageLabel", LogoContainer)
    Logo.Size = UDim2.new(1, 0, 1, 0)
    Logo.Image = "rbxassetid://" .. _0xa
    Logo.BackgroundTransparency = 1
    Logo.ScaleType = Enum.ScaleType.Fit
    Logo.ZIndex = 3
    
    local LogoFrameCorner = Instance.new("UICorner", LogoFrame)
    LogoFrameCorner.CornerRadius = UDim.new(0, 8)

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
    ContentArea.BackgroundTransparency = 0.8
    ContentArea.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    ContentArea.BorderSizePixel = 1
    ContentArea.BorderColor3 = _0xf
    ContentArea.ScrollBarThickness = 3
    ContentArea.ScrollBarImageColor3 = _0xe
    ContentArea.ZIndex = 2
    
    local ContentLayout = Instance.new("UIListLayout", ContentArea)
    ContentLayout.Padding = UDim.new(0, 10)

    local function SyncAimbot()
        if getgenv().Aimbot then
            local AB = getgenv().Aimbot
            AB.Enabled = _0xd.Aimbot.Enabled
            AB.FOV = _0xd.Aimbot.FOV
            AB.Smoothness = _0xd.Aimbot.Smoothness
            AB.TargetPart = _0xd.Aimbot.TargetPart
        end
    end

    function _0x1c:CreateTab(name, icon)
        local TabBtn = Instance.new("TextButton", TabContainer)
        TabBtn.Size = UDim2.new(1, 0, 0, 35)
        TabBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        TabBtn.BackgroundTransparency = 0.4
        TabBtn.Text = icon .. " " .. name
        TabBtn.TextColor3 = _0x14
        TabBtn.Font = Enum.Font.SourceSans
        TabBtn.TextSize = 13
        TabBtn.BorderSizePixel = 1
        TabBtn.BorderColor3 = _0xf
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        TabBtn.ZIndex = 3
        
        local TabCorner = Instance.new("UICorner", TabBtn)
        TabCorner.CornerRadius = UDim.new(0, 6)

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
            for _, v in pairs(_0x1c.Tabs) do
                v.Page.Visible = false
                v.Btn.TextColor3 = _0x14
                v.Btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
                v.Btn.BackgroundTransparency = 0.4
            end
            Page.Visible = true
            TabBtn.TextColor3 = Color3.new(1, 1, 1)
            TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 20)
            TabBtn.BackgroundTransparency = 0.3
        end)

        _0x1c.Tabs[name] = {Page = Page, Btn = TabBtn}
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
        Btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        Btn.BackgroundTransparency = 0.4
        Btn.Text = (default and "✓ " or "✗ ") .. text
        Btn.TextColor3 = default and _0x14 or Color3.fromRGB(150, 150, 130)
        Btn.Font = Enum.Font.SourceSans
        Btn.TextSize = 13
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.BorderSizePixel = 1
        Btn.BorderColor3 = _0xf
        Btn.ZIndex = 4
        
        local ToggleCorner = Instance.new("UICorner", Btn)
        ToggleCorner.CornerRadius = UDim.new(0, 6)

        Btn.MouseButton1Click:Connect(function()
            default = not default
            Btn.Text = (default and "✓ " or "✗ ") .. text
            Btn.TextColor3 = default and _0x14 or Color3.fromRGB(150, 150, 130)
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
        Label.TextColor3 = _0x14
        Label.BackgroundTransparency = 1
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Font = Enum.Font.SourceSans
        Label.TextSize = 13
        Label.BorderSizePixel = 0
        Label.ZIndex = 4

        local Bar = Instance.new("TextButton", Container)
        Bar.Position = UDim2.new(0, 0, 0, 25)
        Bar.Size = UDim2.new(1, 0, 0, 6)
        Bar.BackgroundColor3 = Color3.fromRGB(30, 30, 20)
        Bar.BackgroundTransparency = 0.3
        Bar.Text = ""
        Bar.BorderSizePixel = 1
        Bar.BorderColor3 = _0xf
        Bar.ZIndex = 4
        
        local BarCorner = Instance.new("UICorner", Bar)
        BarCorner.CornerRadius = UDim.new(0, 3)

        local Fill = Instance.new("Frame", Bar)
        Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        Fill.BackgroundColor3 = _0xe
        Fill.BorderSizePixel = 0
        Fill.ZIndex = 4
        
        local FillCorner = Instance.new("UICorner", Fill)
        FillCorner.CornerRadius = UDim.new(0, 3)

        Bar.MouseButton1Down:Connect(function()
            local conn
            conn = _0x2.RenderStepped:Connect(function()
                local mp = _0x3:GetMouseLocation().X
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
            
            local endedConn = _0x3.InputEnded:Connect(function(i)
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
        Btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        Btn.BackgroundTransparency = 0.4
        Btn.Text = "▼ " .. text .. ": " .. options[defaultIndex or 1]
        Btn.TextColor3 = _0x14
        Btn.Font = Enum.Font.SourceSans
        Btn.TextSize = 13
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.BorderSizePixel = 1
        Btn.BorderColor3 = _0xf
        Btn.ZIndex = 4
        
        local DropdownCorner = Instance.new("UICorner", Btn)
        DropdownCorner.CornerRadius = UDim.new(0, 6)

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
        Btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        Btn.BackgroundTransparency = 0.4
        Btn.Text = icon .. " " .. text
        Btn.TextColor3 = _0x14
        Btn.Font = Enum.Font.SourceSans
        Btn.TextSize = 13
        Btn.BorderSizePixel = 1
        Btn.BorderColor3 = _0xf
        Btn.ZIndex = 4
        
        local ButtonCorner = Instance.new("UICorner", Btn)
        ButtonCorner.CornerRadius = UDim.new(0, 6)

        Btn.MouseButton1Click:Connect(function()
            if callback then
                pcall(callback)
            end
        end)
    end

    local LegitPage = _0x1c:CreateTab("LegitBot", "🎯")
    AddToggle(LegitPage, "Aimbot", _0xd.Aimbot.Enabled, function(v) 
        _0xd.Aimbot.Enabled = v 
        SyncAimbot() 
    end)
    AddSlider(LegitPage, "Field of View", 10, 600, _0xd.Aimbot.FOV, function(v) 
        _0xd.Aimbot.FOV = v 
        SyncAimbot() 
    end)
    AddSlider(LegitPage, "Smoothness", 0, 5, _0xd.Aimbot.Smoothness, function(v) 
        _0xd.Aimbot.Smoothness = v 
        SyncAimbot() 
    end)
    AddDropdown(LegitPage, "Target Part", {"Head", "HumanoidRootPart", "Torso"}, 1, function(v) 
        _0xd.Aimbot.TargetPart = v 
        SyncAimbot() 
    end)
    AddToggle(LegitPage, "Team Check", _0xd.Aimbot.TeamCheck, function(v) 
        _0xd.Aimbot.TeamCheck = v 
        SyncAimbot() 
    end)

    local VisualPage = _0x1c:CreateTab("Visuals", "👁")
    
    AddDropdown(VisualPage, "ESP Mode", {"Internal", "Drawing", "Hybrid"}, 1, function(v)
        _0xd.Visuals.Mode = v
        print("🎯 ESP Mode alterado para: " .. v)
    end)
    
    AddToggle(VisualPage, "Enable ESP", _0xd.Visuals.Enabled, function(v) 
        _0xd.Visuals.Enabled = v 
    end)
    AddToggle(VisualPage, "Boxes", _0xd.Visuals.Boxes, function(v) 
        _0xd.Visuals.Boxes = v 
    end)
    AddToggle(VisualPage, "Names", _0xd.Visuals.Names, function(v) 
        _0xd.Visuals.Names = v 
    end)
    AddToggle(VisualPage, "Health", _0xd.Visuals.Health, function(v) 
        _0xd.Visuals.Health = v 
    end)
    AddToggle(VisualPage, "Highlight (Internal Only)", _0xd.Visuals.Highlight, function(v) 
        _0xd.Visuals.Highlight = v 
    end)
    AddToggle(VisualPage, "Tracers (Drawing Only)", _0xd.Visuals.Tracers, function(v) 
        _0xd.Visuals.Tracers = v 
    end)
    AddToggle(VisualPage, "Team Check", _0xd.Visuals.TeamCheck, function(v) 
        _0xd.Visuals.TeamCheck = v 
    end)
    AddSlider(VisualPage, "Max Distance", 100, 5000, _0xd.Visuals.MaxDistance, function(v) 
        _0xd.Visuals.MaxDistance = v 
    end)

    local MiscPage = _0x1c:CreateTab("Misc", "⚙")

    local skyColors = {"Default", "Gold", "Amber", "Desert", "Sunset", "Topographic"}
    AddDropdown(MiscPage, "Sky Color", skyColors, 1, function(selected)
        pcall(function()
            local sky = _0x6:FindFirstChild("NataMenu_Sky")
            local cc = _0x6:FindFirstChild("NataMenu_SkyTint")
            
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
                newSky.Parent = _0x6
                newSky.CelestialBodiesShown = false

                local newCC = Instance.new("ColorCorrectionEffect")
                newCC.Name = "NataMenu_SkyTint"
                newCC.Parent = _0x6
                newCC.Enabled = true
                newCC.TintColor = targetColor
                newCC.Brightness = -0.05
            end
        end)
    end)

    AddToggle(MiscPage, "Night Mode", _0xd.Misc.NightMode, function(v)
        _0xd.Misc.NightMode = v
        _0x1b:ToggleNightMode(v)
    end)

    AddToggle(MiscPage, "Fullbright", _0xd.Misc.Fullbright, function(v)
        _0xd.Misc.Fullbright = v
        _0x1b:ToggleFullbright(v)
    end)

    AddToggle(MiscPage, "Noclip", _0xd.Misc.NoClip, function(v)
        _0xd.Misc.NoClip = v
        _0x1b:ToggleNoClip(v)
    end)

    AddSlider(MiscPage, "Walk Speed", 16, 100, _0xd.Misc.WalkSpeed, function(v)
        _0xd.Misc.WalkSpeed = v
        _0x1b:SetWalkSpeed(v)
    end)

    AddSlider(MiscPage, "Jump Power", 50, 200, _0xd.Misc.JumpPower, function(v)
        _0xd.Misc.JumpPower = v
        _0x1b:SetJumpPower(v)
    end)

    AddToggle(MiscPage, "FPS Boost", _0xd.Misc.FPSBoost, function(v)
        _0xd.Misc.FPSBoost = v
        _0x1b:ToggleFPSBoost(v)
    end)

    AddToggle(MiscPage, "Auto Click", _0xd.Misc.AutoClick, function(v)
        _0xd.Misc.AutoClick = v
        _0x1b:ToggleAutoClick(v)
    end)

    AddToggle(MiscPage, "Anti-AFK", _0xd.Misc.AntiAFK, function(v)
        _0xd.Misc.AntiAFK = v
        _0x1b:ToggleAntiAFK(v)
    end)

    AddToggle(MiscPage, "Bypass", _0xd.Misc.Bypass, function(v)
        _0xd.Misc.Bypass = v
        _0x1b:ToggleBypass(v)
    end)

    AddButton(MiscPage, "🚨 PANIC MODE (F6)", "⚠️", function()
        _0xc:Toggle()
    end)

    AddButton(MiscPage, "Refresh ESP", "🔄", function()
        _0x1a:ClearAll()
        if _0x18 then
            _0x19:ClearAll()
        end
        for _, p in ipairs(_0x4:GetPlayers()) do 
            pcall(function() 
                _0x1a:AddPlayer(p)
                if _0x18 then
                    _0x19:AddPlayer(p)
                end
            end) 
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
        _0x1b:ShowCredits()
    end)

    _0x1c.Tabs["LegitBot"].Btn.TextColor3 = Color3.new(1, 1, 1)
    _0x1c.Tabs["LegitBot"].Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 20)
    _0x1c.Tabs["LegitBot"].Btn.BackgroundTransparency = 0.3
    _0x1c.Tabs["LegitBot"].Page.Visible = true

    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
        end
    end)

    _0x3.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    _0x3.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    _0x3.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.F5 then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    local Watermark = Instance.new("ScreenGui", _0x1:GetService("CoreGui"))
    Watermark.Name = "NataMenuWatermark"
    Watermark.Enabled = true
    
    local WatermarkFrame = Instance.new("Frame", Watermark)
    WatermarkFrame.Size = UDim2.new(0, 260, 0, 35)
    WatermarkFrame.Position = UDim2.new(1, -265, 0, 10)
    WatermarkFrame.BackgroundColor3 = _0x11
    WatermarkFrame.BorderSizePixel = 2
    WatermarkFrame.BorderColor3 = _0xe
    
    local WatermarkCorner = Instance.new("UICorner", WatermarkFrame)
    WatermarkCorner.CornerRadius = UDim.new(0, 8)
    
    local WatermarkDecal = Instance.new("ImageLabel", WatermarkFrame)
    WatermarkDecal.Size = UDim2.new(1, 0, 1, 0)
    WatermarkDecal.Image = "rbxassetid://" .. _0xb
    WatermarkDecal.ImageTransparency = 0.8
    WatermarkDecal.BackgroundTransparency = 1
    WatermarkDecal.ScaleType = Enum.ScaleType.Stretch
    
    local WatermarkLabel = Instance.new("TextLabel", WatermarkFrame)
    WatermarkLabel.Size = UDim2.new(1, 0, 1, 0)
    WatermarkLabel.Text = "NATA.MENU"
    WatermarkLabel.TextColor3 = _0x14
    WatermarkLabel.Font = Enum.Font.SourceSansBold
    WatermarkLabel.TextSize = 12
    WatermarkLabel.BackgroundTransparency = 1
    WatermarkLabel.ZIndex = 2

    local Credits = Instance.new("TextLabel", ScreenGui)
    Credits.Text = "Designer: Farpa | Programmer: Toque | 🎯 HYBRID ESP"
    Credits.Size = UDim2.new(0, 390, 0, 20)
    Credits.Position = UDim2.new(1, -400, 0, 50)
    Credits.BackgroundTransparency = 1
    Credits.TextColor3 = _0x14
    Credits.Font = Enum.Font.SourceSans
    Credits.TextSize = 11
    Credits.BorderSizePixel = 0
    Credits.ZIndex = 2
    
    local MainCorner = Instance.new("UICorner", Main)
    MainCorner.CornerRadius = UDim.new(0, 10)
    
    local SidebarCorner = Instance.new("UICorner", Sidebar)
    SidebarCorner.CornerRadius = UDim.new(0, 8)
    
    local ContentAreaCorner = Instance.new("UICorner", ContentArea)
    ContentAreaCorner.CornerRadius = UDim.new(0, 8)
end

pcall(function()
    _0x1c:Init()
end)

_0x3.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F6 then
        _0xc:Toggle()
        
        local notification = Instance.new("ScreenGui", _0x1:GetService("CoreGui"))
        notification.Name = "PanicNotification"
        
        local frame = Instance.new("Frame", notification)
        frame.Size = UDim2.new(0, 300, 0, 60)
        frame.Position = UDim2.new(0.5, -150, 0.1, 0)
        frame.BackgroundColor3 = _0xc.Active and _0x15 or Color3.fromRGB(50, 200, 50)
        frame.BorderSizePixel = 2
        frame.BorderColor3 = Color3.new(1, 1, 1)
        
        local corner = Instance.new("UICorner", frame)
        corner.CornerRadius = UDim.new(0, 10)
        
        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = _0xc.Active and "🚨 PANIC MODE ATIVO!" or "✅ PANIC MODE DESATIVADO!"
        label.TextColor3 = Color3.new(1, 1, 1)
        label.Font = Enum.Font.SourceSansBold
        label.TextSize = 18
        label.BackgroundTransparency = 1
        
        wait(2)
        notification:Destroy()
    end
end)

_0x2.Stepped:Connect(function()
    if _0xd.Misc.NoClip and _0x7.Character and not _0xc.Active then
        local char = _0x7.Character
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

_0x7.CharacterAdded:Connect(function(character)
    wait(1)
    if character and not _0xc.Active then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = _0xd.Misc.WalkSpeed
            humanoid.JumpPower = _0xd.Misc.JumpPower
        end
    end
end)

_0x1b:ToggleAntiAFK(true)

print("╔══════════════════════════════════════════════╗")
print("║       NATA.MENU HYBRID ESP v4.0             ║")
print("║   🎯 LegitBot   ✨ Hybrid ESP              ║")
print("║   🚨 PANIC MODE: F6 (Emergency)            ║")
print("║                                              ║")
print("║   3 ESP MODES:                              ║")
print("║   1️⃣ Internal (Seguro anti-cheat)         ║")
print("║   2️⃣ Drawing (Invisível F12)              ║")
print("║   3️⃣ Hybrid (AMBOS ATIVOS!)               ║")
print("║                                              ║")
print("║   F5 - Toggle Menu                          ║")
print("║   F6 - PANIC MODE (Desativa TUDO)          ║")
print("╚══════════════════════════════════════════════╝")
print("Designer: Farpa | Programmer: Toque")
print("✨ HYBRID ESP = Melhor de dois mundos!")
