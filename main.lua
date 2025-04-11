local Topik = loadstring(game:HttpGet("https://raw.githubusercontent.com/eeeerrrrf3/TopikHub_GUI/main/main1.lua"))()

-- Create interface
local UI = Topik.CreateLib("My Interface", "Dark")

-- Add tab
local MainTab = UI:NewTab("Main")

-- Add section
local SettingsSection = MainTab:NewSection("Settings")

-- Add button
SettingsSection:NewButton("Save", function()
    print("Settings saved!")
end)

-- Add text box
SettingsSection:NewTextBox("Player Name", "Enter name", function(text)
    print("Entered name:", text)
end)

-- Add toggle
local Toggle = SettingsSection:NewToggle("Enable Sound", true, function(state)
    print("Sound state:", state)
end)
