--[[
   MultiUI Library v1.0
   UI Library universal para executors
   Por [Seu Nome]
--]]

local MultiUI = {}
MultiUI.__index = MultiUI

-- Configurações globais
MultiUI.ToggleUIKey = Enum.KeyCode.RightControl
MultiUI.Theme = {
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
function MultiUI:CreateElement(className, properties)
    local element = Instance.new(className)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

-- Criar a GUI principal
function MultiUI:CreateGUI()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end

    self.ScreenGui = self:CreateElement("ScreenGui", {
        Name = "MultiUIMain",
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
        Text = "MultiUI Library",
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
function MultiUI:SetupEvents()
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
function MultiUI:MakeDraggable(dragPart, mainPart)
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
function MultiUI:ToggleUI()
    if self.MainFrame then
        self.MainFrame.Visible = not self.MainFrame.Visible
    end
end

-- Mostrar notificação
function MultiUI:Notify(message, type)
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

-- Função para criar botão (vamos expandir depois)
-- Componente Button melhorado
function MultiUI:CreateButton(tab, options)
    options = options or {}
    
    local button = self:CreateElement("TextButton", {
        Name = "Button_" .. options.Name,
        Size = UDim2.new(1, -20, 0, 35),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Text = options.Name or "Button",
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        AutoButtonColor = false,
        Parent = tab.Container
    })
    
    -- Efeitos hover
    local originalColor = button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = originalColor:Lerp(Color3.new(1, 1, 1), 0.2)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = originalColor
    end)
    
    button.MouseButton1Down:Connect(function()
        button.BackgroundColor3 = originalColor:Lerp(Color3.new(0, 0, 0), 0.2)
    end)
    
    button.MouseButton1Up:Connect(function()
        button.BackgroundColor3 = originalColor:Lerp(Color3.new(1, 1, 1), 0.2)
    end)
    
    -- Callback
    if options.Callback then
        button.MouseButton1Click:Connect(options.Callback)
    end
    
    return button
end
-- Sistema de Tabs
function MultiUI:CreateTab(tabName)
    if not self.Tabs then
        self.Tabs = {}
        self:CreateTabButtons()
    end
    
    local tab = {
        Name = tabName,
        Elements = {}
    }
    
    -- Container da tab (inicialmente invisível)
    tab.Container = self:CreateElement("ScrollingFrame", {
        Name = tabName .. "Container",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.TabContainer
    })
    
    -- UIListLayout para organizar elementos
    local uiListLayout = self:CreateElement("UIListLayout", {
        Padding = UDim.new(0, 5),
        Parent = tab.Container
    })
    
    table.insert(self.Tabs, tab)
    
    -- Se for a primeira tab, mostrar ela
    if #self.Tabs == 1 then
        self:SwitchTab(tabName)
    end
    
    return tab
end

-- Criar botões das tabs
function MultiUI:CreateTabButtons()
    self.TabButtonsFrame = self:CreateElement("Frame", {
        Name = "TabButtons",
        Size = UDim2.new(1, -20, 0, 30),
        Position = UDim2.new(0, 10, 0, 40),
        BackgroundTransparency = 1,
        Parent = self.MainFrame
    })
    
    self.TabButtonsLayout = self:CreateElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 5),
        Parent = self.TabButtonsFrame
    })
end

-- Mudar entre tabs
function MultiUI:SwitchTab(tabName)
    -- Esconder todas as tabs
    if self.Tabs then
        for _, tab in pairs(self.Tabs) do
            tab.Container.Visible = false
        end
    end
    
    -- Mostrar tab selecionada
    for _, tab in pairs(self.Tabs) do
        if tab.Name == tabName then
            tab.Container.Visible = true
        end
    end
    
    -- Atualizar botões ativos
    self:UpdateTabButtons(tabName)
end

-- Atualizar aparência dos botões de tab
function MultiUI:UpdateTabButtons(activeTab)
    if not self.TabButtonsFrame then return end
    
    -- Limpar botões existentes
    for _, child in pairs(self.TabButtonsFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Criar novos botões
    if self.Tabs then
        for _, tab in pairs(self.Tabs) do
            local tabButton = self:CreateElement("TextButton", {
                Name = tab.Name .. "Button",
                Size = UDim2.new(0, 80, 1, 0),
                BackgroundColor3 = tab.Name == activeTab and self.Theme.Accent or self.Theme.Secondary,
                BorderSizePixel = 0,
                Text = tab.Name,
                TextColor3 = self.Theme.Text,
                Font = Enum.Font.Gotham,
                TextSize = 12,
                Parent = self.TabButtonsFrame
            })
            
            tabButton.MouseButton1Click:Connect(function()
                self:SwitchTab(tab.Name)
            end)
        end
    end
end
-- Componente Toggle
function MultiUI:CreateToggle(tab, options)
    options = options or {}
    
    local toggleFrame = self:CreateElement("Frame", {
        Name = "Toggle_" .. options.Name,
        Size = UDim2.new(1, -20, 0, 25),
        BackgroundTransparency = 1,
        Parent = tab.Container
    })
    
    local label = self:CreateElement("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = options.Name or "Toggle",
        TextColor3 = self.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = toggleFrame
    })
    
    local toggleButton = self:CreateElement("TextButton", {
        Name = "ToggleButton",
        Size = UDim2.new(0, 40, 0, 20),
        Position = UDim2.new(1, -40, 0, 2),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = toggleFrame
    })
    
    local toggleIndicator = self:CreateElement("Frame", {
        Name = "Indicator",
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 2, 0, 2),
        BackgroundColor3 = Color3.fromRGB(100, 100, 100),
        BorderSizePixel = 0,
        Parent = toggleButton
    })
    
    local state = options.Default or false
    
    local function updateToggle()
        if state then
            -- Ligado
            toggleIndicator:TweenPosition(UDim2.new(1, -18, 0, 2), "Out", "Quad", 0.2)
            toggleIndicator.BackgroundColor3 = self.Theme.Success
            toggleButton.BackgroundColor3 = self.Theme.Success
        else
            -- Desligado
            toggleIndicator:TweenPosition(UDim2.new(0, 2, 0, 2), "Out", "Quad", 0.2)
            toggleIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            toggleButton.BackgroundColor3 = self.Theme.Secondary
        end
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
        if options.Callback then
            options.Callback(state)
        end
    end)
    
    updateToggle()
    
    -- Retornar funções para controlar o toggle
    return {
        Set = function(value)
            state = value
            updateToggle()
        end,
        Get = function()
            return state
        end
    }
end
-- Componente Slider
function MultiUI:CreateSlider(tab, options)
    options = options or {}
    
    local sliderFrame = self:CreateElement("Frame", {
        Name = "Slider_" .. options.Name,
        Size = UDim2.new(1, -20, 0, 50),
        BackgroundTransparency = 1,
        Parent = tab.Container
    })
    
    local label = self:CreateElement("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        Text = options.Name or "Slider",
        TextColor3 = self.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = sliderFrame
    })
    
    local valueLabel = self:CreateElement("TextLabel", {
        Name = "Value",
        Size = UDim2.new(0, 40, 0, 15),
        Position = UDim2.new(1, -40, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(options.Default or options.Min or 0),
        TextColor3 = self.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Right,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = sliderFrame
    })
    
    local sliderTrack = self:CreateElement("Frame", {
        Name = "Track",
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = sliderFrame
    })
    
    local sliderFill = self:CreateElement("Frame", {
        Name = "Fill",
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Parent = sliderTrack
    })
    
    local min = options.Min or 0
    local max = options.Max or 100
    local default = options.Default or min
    local currentValue = default
    
    local function updateSlider(value)
        currentValue = math.clamp(value, min, max)
        local percentage = (currentValue - min) / (max - min)
        
        sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
        valueLabel.Text = tostring(math.floor(currentValue))
        
        if options.Callback then
            options.Callback(currentValue)
        end
    end
    
    -- Interação com o slider
    local dragging = false
    
    local function updateFromMouse()
        if not dragging then return end
        
        local mousePosition = game:GetService("UserInputService"):GetMouseLocation()
        local trackAbsolutePosition = sliderTrack.AbsolutePosition
        local trackAbsoluteSize = sliderTrack.AbsoluteSize
        
        local relativeX = (mousePosition.X - trackAbsolutePosition.X) / trackAbsoluteSize.X
        relativeX = math.clamp(relativeX, 0, 1)
        
        local value = min + (relativeX * (max - min))
        if options.Precise then
            value = math.floor(value)
        end
        
        updateSlider(value)
    end
    
    sliderTrack.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateFromMouse()
        end
    end)
    
    sliderTrack.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            updateFromMouse()
        end
    end)
    
    updateSlider(default)
    
    return {
        Set = function(value)
            updateSlider(value)
        end,
        Get = function()
            return currentValue
        end
    }
end

return MultiUI
