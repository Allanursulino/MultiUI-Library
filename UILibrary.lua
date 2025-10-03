--[[
   Delta UI Library v1.0
   Otimizada para executors
   Por [Seu Nome]
--]]

local DeltaUI = {}
DeltaUI.__index = DeltaUI

-- Configurações globais
DeltaUI.ToggleUIKey = Enum.KeyCode.RightControl
DeltaUI.Theme = {
    Main = Color3.fromRGB(25, 25, 25),
    Secondary = Color3.fromRGB(40, 40, 40),
    Accent = Color3.fromRGB(0, 120, 215),
    Text = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(0, 255, 0),
    Warning = Color3.fromRGB(255, 165, 0),
    Error = Color3.fromRGB(255, 0, 0)
}

-- Serviços do Roblox
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variáveis globais
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Função para criar elementos UI rapidamente
function DeltaUI:CreateElement(className, properties)
    local element = Instance.new(className)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

-- Criar a GUI principal
function DeltaUI:CreateGUI()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end

    self.ScreenGui = self:CreateElement("ScreenGui", {
        Name = "DeltaUIMain",
        DisplayOrder = 999,
        ResetOnSpawn = false
    })

    self.MainFrame = self:CreateElement("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = self.Theme.Main,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })

    -- Header
    self.Header = self:CreateElement("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })

    self.Title = self:CreateElement("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -60, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "Delta UI Library",
        TextColor3 = self.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = self.Header
    })

    -- Botão fechar
    self.CloseButton = self:CreateElement("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -30, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 60, 60),
        BorderSizePixel = 0,
        Text = "X",
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = self.Header
    })

    -- Container para tabs
    self.TabContainer = self:CreateElement("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(1, -20, 1, -50),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundTransparency = 1,
        Parent = self.MainFrame
    })

    -- Configurar eventos
    self:SetupEvents()
    
    self.ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    return self
end

-- Configurar eventos da UI
function DeltaUI:SetupEvents()
    -- Fechar UI
    self.CloseButton.MouseButton1Click:Connect(function()
        self:ToggleUI()
    end)

    -- Toggle com tecla
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == self.ToggleUIKey then
            self:ToggleUI()
        end
    end)

    -- Sistema de drag
    self:MakeDraggable(self.Header, self.MainFrame)
end

-- Função para arrastar a janela
function DeltaUI:MakeDraggable(dragPart, mainPart)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        mainPart.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X,
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end

    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainPart.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragPart.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Toggle mostrar/esconder UI
function DeltaUI:ToggleUI()
    if self.MainFrame then
        self.MainFrame.Visible = not self.MainFrame.Visible
    end
end

-- Mostrar notificação
function DeltaUI:Notify(message, type)
    type = type or "Info"
    
    -- Criar notificação
    local notification = self:CreateElement("Frame", {
        Name = "Notification",
        Size = UDim2.new(0, 300, 0, 60),
        Position = UDim2.new(1, -320, 0, 20),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })

    local color = self.Theme.Accent
    if type == "Success" then color = self.Theme.Success
    elseif type == "Warning" then color = self.Theme.Warning
    elseif type == "Error" then color = self.Theme.Error end

    local accent = self:CreateElement("Frame", {
        Name = "Accent",
        Size = UDim2.new(0, 5, 1, 0),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Parent = notification
    })

    local messageLabel = self:CreateElement("TextLabel", {
        Name = "Message",
        Size = UDim2.new(1, -15, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = self.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = notification
    })

    -- Animação de entrada
    notification.Position = UDim2.new(1, 300, 0, 20)
    local tweenIn = TweenService:Create(notification, TweenInfo.new(0.3), {
        Position = UDim2.new(1, -320, 0, 20)
    })
    tweenIn:Play()

    -- Auto-remover após 5 segundos
    task.wait(5)
    
    local tweenOut = TweenService:Create(notification, TweenInfo.new(0.3), {
        Position = UDim2.new(1, 300, 0, 20)
    })
    tweenOut:Play()
    
    tweenOut.Completed:Connect(function()
        notification:Destroy()
    end)
end

return DeltaUI
