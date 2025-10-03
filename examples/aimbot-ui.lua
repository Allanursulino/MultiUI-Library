-- Exemplo: UI para Aimbot usando MultiUI Library
local MultiUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Allanursulino/MultiUI-Library/main/UILibrary.lua"))()

-- Inicializar UI
local UI = MultiUI:CreateGUI()

-- Usar a UI
UI:Notify("MultiUI Library Carregada!", "Success")

-- Criar botões de exemplo
UI:CreateButton("Ativar Aimbot", function()
    UI:Notify("Aimbot Ativado", "Success")
end)

UI:CreateButton("Teleport para Base", function()
    UI:Notify("Teleportado!", "Info")
end)
