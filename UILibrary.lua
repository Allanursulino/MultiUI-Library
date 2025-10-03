--[[
   🎮 MultiUI Library - Gamer Edition
   UI Gamer com tema vermelho/preto
   Por Allanursulino
--]]

local MultiUI = {}
MultiUI.__index = MultiUI

-- Configurações globais - TEMA GAMER
MultiUI.ToggleUIKey = Enum.KeyCode.RightControl
MultiUI.Theme = {
    -- Cores principais
    Main = Color3.fromRGB(15, 15, 15),        -- Preto profundo
    Secondary = Color3.fromRGB(30, 30, 30),   -- Preto mais claro
    Accent = Color3.fromRGB(220, 20, 20),     -- Vermelho vibrante
    AccentHover = Color3.fromRGB(255, 40, 40),-- Vermelho mais claro
    Text = Color3.fromRGB(255, 255, 255),     -- Branco puro
    
    -- Cores de status
    Success = Color3.fromRGB(0, 255, 0),
    Warning = Color3.fromRGB(255, 165, 0),
    Error = Color3.fromRGB(255, 50, 50),
    
    -- Cores especiais
    Border = Color3.fromRGB(80, 0, 0),        -- Bordas vermelhas escuras
    Glow = Color3.fromRGB(255, 0, 0)          -- Efeito glow
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

-- Criar efeito de borda glow
function MultiUI:AddGlowEffect(frame)
    local glow = self:CreateElement("UIStroke", {
        Name = "GlowEffect",
        Color = self.Theme.Glow,
        Thickness = 2,
        Transparency = 0.7,
        Parent = frame
    })
    return glow
end

-- Criar a GUI principal GAMER
function MultiUI:CreateGUI()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end

    -- Criar GUI principal
    self.ScreenGui = self:CreateElement("ScreenGui", {
        Name = "MultiUIGamer",
        DisplayOrder = 999,
        ResetOnSpawn = false
    })

    -- Frame principal com estilo gamer
    self.MainFrame = self:CreateElement("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 500, 0, 400),
        Position = UDim2.new(0.5, -250, 0.5, -200),
        BackgroundColor3 = self.Theme.Main,
        BorderSizePixel = 0,
        Visible = false, -- Inicia invisível
        Parent = self.ScreenGui
    })

    -- Adicionar borda glow
    self:AddGlowEffect(self.MainFrame)

    -- Header gamer
    self.Header = self:CreateElement("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = self.MainFrame
    })

    -- Título com estilo gamer
    self.Title = self:CreateElement("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "🎮 MultiUI",
        TextColor3 = self.Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBlack,
        TextSize = 16,
        TextStrokeTransparency = 0.8,
        Parent = self.Header
    })

    -- Botão fechar gamer
    self.CloseButton = self:CreateElement("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -35, 0, 5),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Text = "✕",
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = self.Header
    })

    -- Container para tabs
    self.TabContainer = self:CreateElement("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        Parent = self.MainFrame
    })

    -- Configurar eventos
    self:SetupEvents()
    
    self.ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Criar logo inicial
    self:CreateLogo()
    
    return self
end

-- Criar logo inicial que abre a UI
function MultiUI:CreateLogo()
    -- Frame da logo
    self.LogoFrame = self:CreateElement("Frame", {
        Name = "LogoFrame",
        Size = UDim2.new(0, 200, 0, 80),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = self.Theme.Main,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })

    -- Adicionar glow na logo
    self:AddGlowEffect(self.LogoFrame)

    -- Texto da logo
    self.LogoText = self:CreateElement("TextLabel", {
        Name = "LogoText",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "🎮 MultiUI",
        TextColor3 = self.Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Center,
        Font = Enum.Font.GothamBlack,
        TextSize = 18,
        TextStrokeTransparency = 0.7,
        Parent = self.LogoFrame
    })

    -- Botão invisível sobre a logo para abrir a UI
    self.LogoButton = self:CreateElement("TextButton", {
        Name = "LogoButton",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "",
        Parent = self.LogoFrame
    })

    -- Efeitos hover na logo
    self.LogoButton.MouseEnter:Connect(function()
        self.LogoFrame.BackgroundColor3 = self.Theme.Secondary
        self.LogoText.TextColor3 = self.Theme.AccentHover
    end)

    self.LogoButton.MouseLeave:Connect(function()
        self.LogoFrame.BackgroundColor3 = self.Theme.Main
        self.LogoText.TextColor3 = self.Theme.Accent
    end)

    -- Clicar na logo abre a UI
    self.LogoButton.MouseButton1Click:Connect(function()
        self:ToggleUI()
    end)
end

-- Configurar eventos da UI
function MultiUI:SetupEvents()
    -- Fechar UI
    self.CloseButton.MouseButton1Click:Connect(function()
        self:ToggleUI()
    end)

    -- Efeitos hover no botão fechar
    self.CloseButton.MouseEnter:Connect(function()
        self.CloseButton.BackgroundColor3 = self.Theme.AccentHover
    end)

    self.CloseButton.MouseLeave:Connect(function()
        self.CloseButton.BackgroundColor3 = self.Theme.Accent
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
        -- Esconder logo quando UI abrir (opcional)
        if self.MainFrame.Visible then
            self.LogoFrame.Visible = false
        else
            self.LogoFrame.Visible = true
        end
    end
end

-- Mostrar notificação GAMER
function MultiUI:Notify(message, type)
    type = type or "Info"
    
    -- Criar notificação estilo gamer
    local notification = self:CreateElement("Frame", {
        Name = "Notification",
        Size = UDim2.new(0, 300, 0, 60),
        Position = UDim2.new(1, -320, 0, 20),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })

    -- Adicionar borda glow
    self:AddGlowEffect(notification)

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
        Text = "🎮 " .. message,
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

-- ============================================================================
-- SISTEMA DE TABS (Mantemos o mesmo da aula anterior, mas com estilo gamer)
-- ============================================================================

function MultiUI:CreateTab(tabName)
    if not self.Tabs then
        self.Tabs = {}
        self:CreateTabButtons()
    end
    
    local tab = {
        Name = tabName,
        Elements = {}
    }
    
    -- Container da tab
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
    
    local uiListLayout = self:CreateElement("UIListLayout", {
        Padding = UDim.new(0, 8),
        Parent = tab.Container
    })
    
    table.insert(self.Tabs, tab)
    
    if #self.Tabs == 1 then
        self:SwitchTab(tabName)
    end
    
    return tab
end

function MultiUI:CreateTabButtons()
    self.TabButtonsFrame = self:CreateElement("Frame", {
        Name = "TabButtons",
        Size = UDim2.new(1, -20, 0, 35),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundTransparency = 1,
        Parent = self.MainFrame
    })
    
    self.TabButtonsLayout = self:CreateElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 5),
        Parent = self.TabButtonsFrame
    })
end

function MultiUI:SwitchTab(tabName)
    if self.Tabs then
        for _, tab in pairs(self.Tabs) do
            tab.Container.Visible = false
        end
    end
    
    for _, tab in pairs(self.Tabs) do
        if tab.Name == tabName then
            tab.Container.Visible = true
        end
    end
    
    self:UpdateTabButtons(tabName)
end

function MultiUI:UpdateTabButtons(activeTab)
    if not self.TabButtonsFrame then return end
    
    for _, child in pairs(self.TabButtonsFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    if self.Tabs then
        for _, tab in pairs(self.Tabs) do
            local isActive = tab.Name == activeTab
            local tabButton = self:CreateElement("TextButton", {
                Name = tab.Name .. "Button",
                Size = UDim2.new(0, 70, 1, 0),  -- Largura reduzida
                BackgroundColor3 = isActive and self.Theme.Accent or self.Theme.Secondary,
                BorderSizePixel = 0,
                Text = tab.Name,
                TextColor3 = self.Theme.Text,
                Font = Enum.Font.GothamBold,
                TextSize = 11,  -- Texto menor
                Parent = self.TabButtonsFrame
            })
            
            -- Efeitos hover nos botões de tab
            tabButton.MouseEnter:Connect(function()
                if not isActive then
                    tabButton.BackgroundColor3 = self.Theme.AccentHover
                end
            end)
            
            tabButton.MouseLeave:Connect(function()
                if not isActive then
                    tabButton.BackgroundColor3 = self.Theme.Secondary
                end
            end)
            
            tabButton.MouseButton1Click:Connect(function()
                self:SwitchTab(tab.Name)
            end)
        end
    end
end

-- ============================================================================
-- COMPONENTES GAMER (Toggle, Slider, Button com novo estilo)
-- ============================================================================

function MultiUI:CreateToggle(tab, options)
    options = options or {}
    
    local toggleFrame = self:CreateElement("Frame", {
        Name = "Toggle_" .. options.Name,
        Size = UDim2.new(1, -20, 0, 30),
        BackgroundTransparency = 1,
        Parent = tab.Container
    })
    
    local label = self:CreateElement("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "⚡ " .. (options.Name or "Toggle"),
        TextColor3 = self.Theme.Text,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = toggleFrame
    })
    
    local toggleButton = self:CreateElement("TextButton", {
        Name = "ToggleButton",
        Size = UDim2.new(0, 45, 0, 22),
        Position = UDim2.new(1, -45, 0, 4),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = toggleFrame
    })
    
    -- Adicionar borda ao toggle
    self:AddGlowEffect(toggleButton)
    
    local toggleIndicator = self:CreateElement("Frame", {
        Name = "Indicator",
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, 2, 0, 2),
        BackgroundColor3 = Color3.fromRGB(100, 100, 100),
        BorderSizePixel = 0,
        Parent = toggleButton
    })
    
    local state = options.Default or false
    
    local function updateToggle()
        if state then
            -- Ligado - Vermelho
            toggleIndicator:TweenPosition(UDim2.new(1, -20, 0, 2), "Out", "Quad", 0.2)
            toggleIndicator.BackgroundColor3 = self.Theme.Accent
            toggleButton.BackgroundColor3 = self.Theme.Accent
        else
            -- Desligado - Cinza
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

function MultiUI:CreateSlider(tab, options)
    options = options or {}
    
    local sliderFrame = self:CreateElement("Frame", {
        Name = "Slider_" .. options.Name,
        Size = UDim2.new(1, -20, 0, 55),
        BackgroundTransparency = 1,
        Parent = tab.Container
    })
    
    local label = self:CreateElement("TextLabel", {
        Name = "Label",
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        Text = "🎯 " .. (options.Name or "Slider"),
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
        TextColor3 = self.Theme.Accent,
        TextXAlignment = Enum.TextXAlignment.Right,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        Parent = sliderFrame
    })
    
    local sliderTrack = self:CreateElement("Frame", {
        Name = "Track",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = self.Theme.Secondary,
        BorderSizePixel = 0,
        Parent = sliderFrame
    })
    
    -- Adicionar borda ao track
    self:AddGlowEffect(sliderTrack)
    
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

function MultiUI:CreateButton(tab, options)
    options = options or {}
    
    local button = self:CreateElement("TextButton", {
        Name = "Button_" .. options.Name,
        Size = UDim2.new(1, -20, 0, 40),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Text = "🎮 " .. (options.Name or "Button"),
        TextColor3 = self.Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        AutoButtonColor = false,
        Parent = tab.Container
    })
    
    -- Adicionar borda glow ao botão
    self:AddGlowEffect(button)
    
    -- Efeitos hover gamer
    local originalColor = button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = self.Theme.AccentHover
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = originalColor
    end)
    
    button.MouseButton1Down:Connect(function()
        button.BackgroundColor3 = self.Theme.Accent:Lerp(Color3.new(0, 0, 0), 0.3)
    end)
    
    button.MouseButton1Up:Connect(function()
        button.BackgroundColor3 = self.Theme.AccentHover
    end)
    
    -- Callback
    if options.Callback then
        button.MouseButton1Click:Connect(options.Callback)
    end
    
    return button
end

return MultiUI
