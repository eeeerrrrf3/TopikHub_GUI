local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/eeeerrrrf3/TopikHub_GUI/main/main1.lua"))()

local Window = Library.CreateLib("Topikhub (Owner Topik)", "RJTheme3")

local Tab = Window:NewTab("Hub Topik")	

local Section = Tab:NewSection("Top scripts")

Section:NewButton("INF Money", "ButtonInfo", function()

end)

Section:NewButton("Get 1M ", "ButtonInfo", function()

end)

Section:NewButton("Fly", "ButtonInfo", function()

end)

Section:NewButton("click tp", "Left CTRL + Click", function()
    local Player = game.Players.LocalPlayer 
local Mouse = Player:GetMouse() 
local UserInputService = game:GetService('UserInputService') 
 
local HoldingControl = false 
 
Mouse.Button1Down:connect(function() 
if HoldingControl then 
Player.Character:MoveTo(Mouse.Hit.p) 
end 
end) 
 
UserInputService.InputBegan:connect(function(Input, Processed) 
if Input.UserInputType == Enum.UserInputType.Keyboard then 
if Input.KeyCode == Enum.KeyCode.LeftControl then 
HoldingControl = true 
elseif Input.KeyCode == Enum.KeyCode.RightControl then 
HoldingControl = true 
end 
end 
end) 
 
UserInputService.InputEnded:connect(function(Input, Processed) 
if Input.UserInputType == Enum.UserInputType.Keyboard then 
if Input.KeyCode == Enum.KeyCode.LeftControl then 
HoldingControl = false 
elseif Input.KeyCode == Enum.KeyCode.RightControl then 
HoldingControl = false
end 
end
end)
end)
       

Section:NewButton("Fly", "ButtonInfo", function()
   loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
end)

local main = Window:NewTab("Player")
local mainSection = main:NewSection("Power chits")

mainSection:NewSlider("Walkspeed", "Changes the walkspeed", 200, 16, function(v)
     game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)

mainSection:NewSlider("Jumppower", "Changes the jumppower", 200, 50, function(v)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
end)

local Tab = Window:NewTab("Teleport")

local Section = Tab:NewSection("Teleports")

Section:NewButton("Restorant", "ButtonInfo", function()
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-22.22128677368164, 86.33869171142578, -316.3186950683594) 
end)

Section:NewButton("LAB", "ButtonInfo", function()
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-23.721460342407227, 67.44866180419922, -844.1381225585938) 
end)

Section:NewButton("Staff Only", "ButtonInfo", function()
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(125.23602294921875, 83.0999755859375, -122.82544708251953) 
end)

Section:NewButton("Cat", "ButtonInfo", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Cats.Cat.TailSegment1.CFrame    
end)

Section:NewButton("Boat", "ButtonInfo", function()
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Gameplay.Boat.MainPart.CFrame    
end)

Section:NewButton("Amogus", "ButtonInfo", function()
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new() 
end)

Section:NewButton("VR", "ButtonInfo", function()
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(308.9193420410156, 112.44802856445312, -52.947410583496094) 
end)

Section:NewButton("lol", "ButtonInfo", function()
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(155.27578735351562, 84.33868408203125, -439.7681579589844) 
end)

Section:NewButton("Secret zone", "ButtonInfo", function()
   game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(298.4009094238281, 94.58877563476562, -188.79432678222656) 
end)

local Settings = Window:NewTab("Settings")
local SettingsSection = Settings:NewSection("Settings")

SettingsSection:NewKeybind("ToggleGui", "Set you toggle gui key", Enum.KeyCode.F, function()	Library:ToggleUI()end)

SettingsSection:NewButton("FPS BOSTS", "ButtonInfo", function()
    local decalsyeeted = true -- Leaving this on makes games look shitty but the fps goes up by at least 20.
local g = game
local w = g.Workspace
local l = g.Lighting
local t = w.Terrain
t.WaterWaveSize = 0
t.WaterWaveSpeed = 0
t.WaterReflectance = 0
t.WaterTransparency = 0
l.GlobalShadows = false
l.FogEnd = 9e9
l.Brightness = 0
settings().Rendering.QualityLevel = "Level01"
for i,v in pairs(g:GetDescendants()) do
 if v:IsA("Part") or v:IsA("Union") or v:IsA("MeshPart") then
 v.Material = "Plastic"
v.Reflectance = 0
elseif v:IsA("Decal") and decalsyeeted then 
v.Transparency = 1
elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then 
v.Lifetime = NumberRange.new(0)
 end
end
end)

local CreditsTab = Window:NewTab("Credits")
local CreditsSection = CreditsTab:NewSection("Credits")
CreditsSection:NewLabel("Made by Toipik#4001")

CreditsSection:NewButton("Join Discord", "Joins the discord server.", function()
    local http = game:GetService('HttpService') 
    local req = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
	if req then
		req({
			Url = 'http://127.0.0.1:6463/rpc?v=1',
			Method = 'POST',
			Headers = {
				['Content-Type'] = 'application/json',
				Origin = 'https://discord.com'
			},
			Body = http:JSONEncode({
				cmd = 'INVITE_BROWSER',
				nonce = http:GenerateGUID(false),
				args = {code = 'mfAjWaz2j9'}
			})
		})
	end
end)
