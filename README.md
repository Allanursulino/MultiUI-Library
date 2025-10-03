# 🎮 MultiUI Library

Uma UI Library universal e moderna para scripts Roblox, otimizada para executors.

## ✨ Características

- 🚀 **Leve e Rápida**
- 🎨 **Interface Moderna**  
- ⌨️ **Toggle com Tecla** (RightControl)
- 🔔 **Sistema de Notificações**
- 👆 **Arrastável**
- 🛡️ **Otimizada para Executors**

## 🚀 Como Usar

```lua
-- Carregar a library
local MultiUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Allanursulino/MultiUI-Library/main/UILibrary.lua"))()

-- Inicializar
local UI = MultiUI:CreateGUI()

-- Criar elementos
UI:CreateButton("Meu Botão", function()
    UI:Notify("Botão clicado!", "Success")
end)
