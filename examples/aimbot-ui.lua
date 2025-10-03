-- Exemplo: UI para Aimbot usando Delta UI Library
local DeltaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Allanursulino/DeltaUILibrary/main/UILibrary.lua"))()

-- Inicializar UI
local UI = DeltaUI:CreateGUI()

-- Criar tab para Aimbot
UI:Notify("Delta UI Carregada!", "Success")

-- Função para criar botão de aimbot
local AimbotTab = UI:CreateTab("Aimbot")

AimbotTab:AddToggle({
    Name = "Ativar Aimbot",
    Default = false,
    Callback = function(value)
        if value then
            UI:Notify("Aimbot Ativado", "Success")
            -- Aqui iria o código do aimbot
        else
            UI:Notify("Aimbot Desativado", "Warning")
        end
    end
})

AimbotTab:AddSlider({
    Name = "Field of View",
    Min = 1,
    Max = 360,
    Default = 90,
    Callback = function(value)
        print("FOV alterado para:", value)
    end
})

AimbotTab:AddButton({
    Name = "Testar Aimbot",
    Callback = function()
        UI:Notify("Aimbot testado!", "Info")
    end
})
