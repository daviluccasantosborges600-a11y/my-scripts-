-- ⚡️ DARK STAR GERAL HUB (VERSÃO PC & MOBILE) ⚡️

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local cam = workspace.CurrentCamera

-- GUI PRINCIPAL
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "DarkStarGUI"
gui.ResetOnSpawn = false

-- BOTÃO FLUTUANTE ⚡️
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.fromOffset(60,60)
openBtn.Position = UDim2.fromOffset(100,100)
openBtn.Text = ""
openBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
openBtn.Draggable = true
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0)
local stroke = Instance.new("UIStroke", openBtn)
stroke.Color = Color3.fromRGB(255,255,0)
stroke.Thickness = 3

local logo = Instance.new("ImageLabel", openBtn)
logo.Size = UDim2.fromScale(1, 1)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://128955227084673"
logo.ScaleType = Enum.ScaleType.Fit

-- JANELA ADM
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(400, 400)
frame.Position = UDim2.fromScale(0.5,0.5)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = false
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.fromOffset(10, 0)
title.Text = "⭐ DARK STAR GERAL HUB ⭐"
title.TextColor3 = Color3.fromRGB(255,255,0)
title.BackgroundTransparency = 1
title.TextScaled = true
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.fromOffset(30, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", closeBtn)
closeBtn.MouseButton1Click:Connect(function() frame.Visible = false end)

openBtn.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible end)

-- SCROLL GERAL (ÚNICA ABA)
local scrollGeral = Instance.new("ScrollingFrame", frame)
scrollGeral.Size = UDim2.new(1, -10, 1, -55)
scrollGeral.Position = UDim2.fromOffset(5, 50)
scrollGeral.BackgroundTransparency = 1
scrollGeral.CanvasSize = UDim2.new(0, 0, 0, 1100)
scrollGeral.Visible = true

local function newButton(text, y, parent)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(1,-20,0,35)
	b.Position = UDim2.fromOffset(5,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	return b
end

local function newBox(placeholder, y, parent)
	local box = Instance.new("TextBox", parent)
	box.Size = UDim2.new(1,-20,0,35)
	box.Position = UDim2.fromOffset(5,y)
	box.PlaceholderText = placeholder
	box.BackgroundColor3 = Color3.fromRGB(30,30,30)
	box.TextColor3 = Color3.new(1,1,1)
    box.Text = ""
	Instance.new("UICorner", box)
	return box
end

-------------------------------------------------
-- 🚀 LOGICA DE VOO E VARIAVEIS (PC & MOBILE)
-------------------------------------------------
local flying, flySpeed, moveDir = false, 70, Vector3.zero
local phantomActive, phantomPart, antiSit, floating, floatPart = false, nil, false, false, nil

-- Controle por Teclado (PC) para o Voo
local keysPressed = {W = false, S = false, A = false, D = false, Space = false, Shift = false}

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.Up then keysPressed.W = true end
    if input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.Down then keysPressed.S = true end
    if input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.Left then keysPressed.A = true end
    if input.KeyCode == Enum.KeyCode.D or input.KeyCode == Enum.KeyCode.Right then keysPressed.D = true end
    if input.KeyCode == Enum.KeyCode.Space then keysPressed.Space = true end
    if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then keysPressed.Shift = true end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.Up then keysPressed.W = false end
    if input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.Down then keysPressed.S = false end
    if input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.Left then keysPressed.A = false end
    if input.KeyCode == Enum.KeyCode.D or input.KeyCode == Enum.KeyCode.Right then keysPressed.D = false end
    if input.KeyCode == Enum.KeyCode.Space then keysPressed.Space = false end
    if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then keysPressed.Shift = false end
end)

local flyFrame = Instance.new("Frame", gui)
flyFrame.Size = UDim2.fromOffset(180, 150)
flyFrame.Position = UDim2.new(1, -220, 0.5, -75)
flyFrame.BackgroundTransparency = 1
flyFrame.Visible = false

local function createFlyBtn(txt, pos)
    local b = Instance.new("TextButton", flyFrame); b.Size = UDim2.fromOffset(50, 50); b.Position = pos; b.Text = txt
    b.BackgroundColor3 = Color3.fromRGB(30,30,30); b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b); Instance.new("UIStroke", b).Color = Color3.fromRGB(255,255,0)
    return b
end

local btnFwd, btnBwd, btnLeft, btnRight = createFlyBtn("▲", UDim2.fromOffset(65, 0)), createFlyBtn("▼", UDim2.fromOffset(65, 100)), createFlyBtn("◀", UDim2.fromOffset(5, 50)), createFlyBtn("▶", UDim2.fromOffset(125, 50))

RunService.RenderStepped:Connect(function()
    if flying then
        local target = (phantomActive and phantomPart) or (player.Character and player.Character:FindFirstChild("HumanoidRootPart"))
        if target then
            local bv = target:FindFirstChild("FlyBV") or Instance.new("BodyVelocity", target); bv.Name = "FlyBV"; bv.MaxForce = Vector3.new(1e9,1e9,1e9)
            local bg = target:FindFirstChild("FlyBG") or Instance.new("BodyGyro", target); bg.Name = "FlyBG"; bg.MaxTorque = Vector3.new(1e9,1e9,1e9); bg.CFrame = cam.CFrame
            
            local finalVel = Vector3.zero
            local currentMoveZ = moveDir.Z
            local currentMoveX = moveDir.X
            
            if keysPressed.W then currentMoveZ = 1 elseif keysPressed.S then currentMoveZ = -1 end
            if keysPressed.D then currentMoveX = 1 elseif keysPressed.A then currentMoveX = -1 end
            
            if currentMoveZ ~= 0 then finalVel += cam.CFrame.LookVector * currentMoveZ end
            if currentMoveX ~= 0 then finalVel += cam.CFrame.RightVector * currentMoveX end
            if keysPressed.Space then finalVel += Vector3.new(0, 1, 0) end
            if keysPressed.Shift then finalVel += Vector3.new(0, -1, 0) end
            
            bv.Velocity = finalVel * flySpeed
        end
    end
end)

local function setupBtn(btn, vec)
    btn.MouseButton1Down:Connect(function() moveDir = vec end)
    btn.MouseButton1Up:Connect(function() moveDir = Vector3.zero end)
end
setupBtn(btnFwd, Vector3.new(0,0,1)); setupBtn(btnBwd, Vector3.new(0,0,-1)); setupBtn(btnLeft, Vector3.new(-1,0,0)); setupBtn(btnRight, Vector3.new(1,0,0))

-------------------------------------------------
-- 🛡️ UTILITÁRIOS (GERAL)
-------------------------------------------------

local sitBtn = newButton("ANTI-SIT (UNSIT) [OFF]", 10, scrollGeral)
sitBtn.MouseButton1Click:Connect(function()
    antiSit = not antiSit; sitBtn.Text = antiSit and "ANTI-SIT: ON" or "ANTI-SIT: OFF"
    task.spawn(function() while antiSit do if player.Character and player.Character.Humanoid.Sit then player.Character.Humanoid.Sit = false end task.wait(0.1) end end)
end)

newButton("FLOAT (ANDAR NO AR) [ON/OFF]", 50, scrollGeral).MouseButton1Click:Connect(function()
    floating = not floating
    if floating then
        floatPart = Instance.new("Part", workspace); floatPart.Size = Vector3.new(6, 1, 6); floatPart.Transparency = 1; floatPart.Anchored = true
        RunService.RenderStepped:Connect(function() if floating and player.Character and floatPart then floatPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0) end end)
    elseif floatPart then floatPart:Destroy() end
end)

newButton("MODO FANTASMA [ON/OFF (PC & MOBILE)]", 90, scrollGeral).MouseButton1Click:Connect(function()
    phantomActive = not phantomActive
    local hrp = player.Character.HumanoidRootPart
    if phantomActive then
        phantomPart = Instance.new("Part", workspace); phantomPart.Size = Vector3.new(2,2,2); phantomPart.Transparency = 0.5; phantomPart.Color = Color3.new(1,1,0); phantomPart.CanCollide = false
        phantomPart.Position = hrp.Position; hrp.CFrame = hrp.CFrame * CFrame.new(0, 5000, 0)
        local anchor = Instance.new("Part", workspace); anchor.Name = "PhantAnchor"; anchor.Size = Vector3.new(10,1,10); anchor.Anchored = true; anchor.CFrame = hrp.CFrame * CFrame.new(0,-3.5,0)
        flying = true; flyFrame.Visible = true; cam.CameraSubject = phantomPart
    else
        if phantomPart then hrp.CFrame = phantomPart.CFrame; phantomPart:Destroy() end
        if workspace:FindFirstChild("PhantAnchor") then workspace.PhantAnchor:Destroy() end
        cam.CameraSubject = player.Character.Humanoid; flying = false; flyFrame.Visible = false
    end
end)

newButton("VOAR [ON/OFF (PC & MOBILE)]", 130, scrollGeral).MouseButton1Click:Connect(function()
	flying = not flying; flyFrame.Visible = flying
    if not flying and player.Character then
        local hrp = player.Character.HumanoidRootPart
        if hrp:FindFirstChild("FlyBV") then hrp.FlyBV:Destroy() end
        if hrp:FindFirstChild("FlyBG") then hrp.FlyBG:Destroy() end
        player.Character.Humanoid.PlatformStand = false
    else player.Character.Humanoid.PlatformStand = true end
end)

newButton("+10 FLY SPEED", 170, scrollGeral).MouseButton1Click:Connect(function() flySpeed += 10 end)
newButton("RESET FLY SPEED", 210, scrollGeral).MouseButton1Click:Connect(function() flySpeed = 70 end)

local noclip = false
local noclipBtn = newButton("NOCLIP (PAREDES) [OFF]", 250, scrollGeral)
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip; noclipBtn.Text = noclip and "NOCLIP: ON" or "NOCLIP: OFF"
	RunService.Stepped:Connect(function() if noclip and player.Character then for _,p in ipairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end)
end)

newButton("CLICK TELEPORT (ATIVE E CLIQUE)", 290, scrollGeral).MouseButton1Click:Connect(function()
	mouse.Button1Down:Wait(); if player.Character then player.Character:MoveTo(mouse.Hit.p) end
end)

local tpBox = newBox("Nome do Alvo (TP)", 330, scrollGeral)
newButton("TELEPORTAR PARA PLAYER", 370, scrollGeral).MouseButton1Click:Connect(function()
	for _,plr in ipairs(Players:GetPlayers()) do if string.find(plr.Name:lower(), tpBox.Text:lower()) or string.find(plr.DisplayName:lower(), tpBox.Text:lower()) then player.Character:MoveTo(plr.Character.HumanoidRootPart.Position) end end
end)

local viewBox = newBox("Nome do Alvo (VIEW)", 410, scrollGeral)
newButton("VER TELA (VIEW)", 450, scrollGeral).MouseButton1Click:Connect(function()
	for _,plr in ipairs(Players:GetPlayers()) do if string.find(plr.Name:lower(), viewBox.Text:lower()) then cam.CameraSubject = plr.Character.Humanoid end end
end)

newButton("PARAR VIEW (VOLTAR)", 490, scrollGeral).MouseButton1Click:Connect(function() cam.CameraSubject = player.Character.Humanoid end)

local espEnabled = false
newButton("ESP PLAYERS [ON/OFF]", 530, scrollGeral).MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do if plr ~= player and plr.Character then local hl = Instance.new("Highlight", plr.Character); hl.Name = "ESPHighlight"; hl.FillColor = Color3.new(1,1,0) end end
    else
        for _, plr in ipairs(Players:GetPlayers()) do if plr.Character and plr.Character:FindFirstChild("ESPHighlight") then plr.Character.ESPHighlight:Destroy() end end
    end
end)

newButton("+100 WALK SPEED", 570, scrollGeral).MouseButton1Click:Connect(function() player.Character.Humanoid.WalkSpeed += 100 end)
newButton("+30 JUMP POWER", 610, scrollGeral).MouseButton1Click:Connect(function() player.Character.Humanoid.JumpPower += 30 end)
newButton("RESETAR TUDO (SPEED/JUMP)", 650, scrollGeral).MouseButton1Click:Connect(function() player.Character.Humanoid.WalkSpeed = 16; player.Character.Humanoid.JumpPower = 50 end)

-------------------------------------------------
-- ⚡ SISTEMA DE TAGS
-------------------------------------------------
local TAGS = {["dkleiie"] = "ADM 3", ["renang_88"] = "ADM 2", ["davibloxfruitr"] = "CRIADOR"}
local function markExecutor(character) if character:FindFirstChild("DarkStarExecutor") then return end local tag = Instance.new("BoolValue"); tag.Name = "DarkStarExecutor"; tag.Parent = character end
local function createTag(character, plr)
	local head = character:WaitForChild("Head", 5)
	if not head or head:FindFirstChild("DarkStarTag") then return end
	local billboard = Instance.new("BillboardGui", head); billboard.Name = "DarkStarTag"; billboard.Adornee = head; billboard.Size = UDim2.new(0, 160, 0, 35); billboard.StudsOffset = Vector3.new(0, 1.8, 0); billboard.AlwaysOnTop = true
	local txt = Instance.new("TextLabel", billboard); txt.Size = UDim2.fromScale(1,1); txt.BackgroundTransparency = 1; txt.TextScaled = true; txt.Font = Enum.Font.GothamBold; txt.TextColor3 = Color3.fromRGB(255,255,0); txt.TextStrokeTransparency = 0; txt.TextStrokeColor3 = Color3.new(0,0,0)
	txt.Text = TAGS[plr.Name:lower()] or "USER"
end

if player.Character then markExecutor(player.Character) end
player.CharacterAdded:Connect(function(char) task.wait(0.5); markExecutor(char) end)
local function watchPlayer(plr)
	plr.CharacterAdded:Connect(function(char) char:WaitForChild("DarkStarExecutor", 10); if char:FindFirstChild("DarkStarExecutor") then createTag(char, plr) end end)
	if plr.Character and plr.Character:FindFirstChild("DarkStarExecutor") then createTag(plr.Character, plr) end
end
for _, plr in ipairs(Players:GetPlayers()) do watchPlayer(plr) end
Players.PlayerAdded:Connect(watchPlayer)