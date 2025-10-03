-- Exemplo completo usando MultiUI Library
local MultiUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Allanursulino/MultiUI-Library/main/UILibrary.lua"))()

-- Inicializar UI
local UI = MultiUI:CreateGUI()
UI:Notify("MultiUI Library Carregada!", "Success")

-- Tab Aimbot
local AimbotTab = UI:CreateTab("Aimbot")

UI:CreateToggle(AimbotTab, {
    Name = "Ativar Aimbot",
    Default = false,
    Callback = function(state)
        UI:Notify("Aimbot: " .. (state and "ATIVADO" or "DESATIVADO"), state and "Success" or "Warning")
    end
})

UI:CreateSlider(AimbotTab, {
    Name = "Field of View",
    Min = 1,
    Max = 360,
    Default = 90,
    Callback = function(value)
        print("FOV alterado para:", value)
    end
})

UI:CreateButton(AimbotTab, {
    Name = "Testar Aimbot",
    Callback = function()
        UI:Notify("Aimbot testado com sucesso!", "Success")
    end
})

-- Tab Visuals
local VisualsTab = UI:CreateTab("Visuals")

UI:CreateToggle(VisualsTab, {
    Name = "ESP Players",
    Default = true,
    Callback = function(state)
        UI:Notify("ESP: " .. (state and "ATIVADO" or "DESATIVADO"), state and "Success" or "Warning")
    end
})

UI:CreateSlider(VisualsTab, {
    Name = "Brillho ESP",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(value)
        print("Brillho ESP:", value)
    end
})

-- Tab Misc
local MiscTab = UI:CreateTab("Misc")

UI:CreateButton(MiscTab, {
    Name = "Teleport para Base",
    Callback = function()
        UI:Notify("Teleportado para base!", "Info")
    end
})

UI:CreateToggle(MiscTab, {
    Name = "Auto Farm",
    Default = false,
    Callback = function(state)
        UI:Notify("Auto Farm: " .. (state and "ATIVADO" or "DESATIVADO"), state and "Success" or "Warning")
    end
})

print("✅ MultiUI Example carregado!")
