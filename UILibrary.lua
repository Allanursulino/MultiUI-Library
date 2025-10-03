--[[
   🎮 Anime Eternal MultiHub
   UI Moderna com design profissional
   Por Allanursulino
--]]

local MultiUI = {}
MultiUI.__index = MultiUI

-- Configurações
MultiUI.ToggleUIKey = Enum.KeyCode.RightControl

-- Tema Moderno - Baseado na sua referência
MultiUI.Theme = {
    -- Cores principais
    Background = Color3.fromRGB(15, 15, 25),      -- Fundo escuro azulado
    Header = Color3.fromRGB(25, 25, 40),          -- Header mais claro
    Section = Color3.fromRGB(30, 30, 45),         -- Seções
    Accent = Color3.fromRGB(180, 40, 70),         -- Vermelho/rosa anime
    AccentHover = Color3.fromRGB(200, 60, 90),    -- Hover mais claro
    
    -- Cores de texto
    TextPrimary = Color3.fromRGB(255, 255, 255),  -- Branco
    TextSecondary = Color3.fromRGB(200, 200, 220),-- Cinza claro
    TextAccent = Color3.fromRGB(255, 100, 130),   -- Texto acento
    
    -- Estados
    Success = Color3.fromRGB(80, 200, 120),       -- Verde
    Warning = Color3.fromRGB(255, 180, 60),       -- Laranja
    Error = Color3.fromRGB(220, 80, 80),          -- Vermelho
    
    -- Elementos UI
    Border = Color3.fromRGB(50, 50, 70),          -- Bordas
    TabActive = Color3.fromRGB(180, 40, 70),      -- Tab ativa
    TabInactive = Color3.fromRGB(40, 40, 60)      -- Tab inativa
}

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variáveis
local player = Players.LocalPlayer

-- Função auxiliar para criar elementos
function MultiUI:CreateElement(className, properties)
    local element = Instance.new(className)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

-- Criar UI principal
function MultiUI:CreateGUI()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end

    -- ScreenGui principal
    self.ScreenGui = self:CreateElement("ScreenGui", {
    Name = "MultiUILibrary",  -- NOME CORRIGIDO AQUI
    DisplayOrder = 999,
    ResetOnSpawn = false
})

    -- Container principal
    self.MainContainer = self:CreateElement("Frame", {
        Name = "MainContainer",
        Size = UDim2.new(0, 600, 0, 450), -- Tamanho maior para mais conteúdo
        Position = UDim2.new(0.5, -300, 0.5, -225),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.ScreenGui
    })

    -- Adicionar borda sutil
    self:CreateElement("UIStroke", {
        Color = self.Theme.Border,
        Thickness = 2,
        Parent = self.MainContainer
    })

    -- Header profissional
    self.Header = self:CreateElement("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = self.Theme.Header,
        BorderSizePixel = 0,
        Parent = self.MainContainer
    })

    -- Título do header
    self.Title = self:CreateElement("TextLabel", {
    Name = "Title",
    Size = UDim2.new(1, -100, 1, 0),
    Position = UDim2.new(0, 15, 0, 0),
    BackgroundTransparency = 1,
    Text = "MultiUI Library",  -- NOME CORRIGIDO AQUI
    TextColor3 = self.Theme.TextPrimary,
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    Parent = self.Header
})

    -- Botões de controle da janela
    self.ControlButtons = self:CreateElement("Frame", {
        Name = "ControlButtons",
        Size = UDim2.new(0, 80, 1, 0),
        Position = UDim2.new(1, -85, 0, 0),
        BackgroundTransparency = 1,
        Parent = self.Header
    })

    -- Botão minimizar (placeholder)
    self.MinimizeButton = self:CreateElement("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(0, 5, 0.5, -12.5),
        BackgroundColor3 = self.Theme.Warning,
        Text = "_",
        TextColor3 = self.Theme.TextPrimary,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Visible = false, -- Implementar depois
        Parent = self.ControlButtons
    })

    -- Botão fechar
    self.CloseButton = self:CreateElement("TextButton", {
        Name = "CloseButton",
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -30, 0.5, -12.5),
        BackgroundColor3 = self.Theme.Error,
        Text = "×",
        TextColor3 = self.Theme.TextPrimary,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        Parent = self.ControlButtons
    })

    -- Área de navegação (tabs)
    self.NavArea = self:CreateElement("Frame", {
        Name = "NavArea",
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundColor3 = self.Theme.Section,
        BorderSizePixel = 0,
        Parent = self.MainContainer
    })

    -- Container de tabs
    self.TabsContainer = self:CreateElement("Frame", {
        Name = "TabsContainer",
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Parent = self.NavArea
    })

    self.TabsLayout = self:CreateElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 5),
        Parent = self.TabsContainer
    })

    -- Área de conteúdo
    self.ContentArea = self:CreateElement("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, 0, 1, -90),
        Position = UDim2.new(0, 0, 0, 90),
        BackgroundTransparency = 1,
        Parent = self.MainContainer
    })

    -- Configurar eventos
    self:SetupEvents()
    
    -- Parentar ao PlayerGui
    self.ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    return self
end

-- Configurar eventos
function MultiUI:SetupEvents()
    -- Fechar UI
    self.CloseButton.MouseButton1Click:Connect(function()
        self.MainContainer.Visible = false
    end)

    -- Efeitos hover
    self.CloseButton.MouseEnter:Connect(function()
        self.CloseButton.BackgroundColor3 = Color3.fromRGB(240, 80, 80)
    end)

    self.CloseButton.MouseLeave:Connect(function()
        self.CloseButton.BackgroundColor3 = self.Theme.Error
    end)

    -- Toggle com tecla
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == self.ToggleUIKey then
            self.MainContainer.Visible = not self.MainContainer.Visible
        end
    end)

    -- Sistema de drag
    self:MakeDraggable(self.Header, self.MainContainer)
end

-- Sistema de drag
function MultiUI:MakeDraggable(dragPart, mainPart)
    local dragging = false
    local dragStart, startPos

    dragPart.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainPart.Position
        end
    end)

    dragPart.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainPart.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Sistema de Tabs moderno
function MultiUI:CreateTab(tabName)
    if not self.Tabs then
        self.Tabs = {}
        self.TabContents = {}
    end

    -- Criar botão da tab
    local tabButton = self:CreateElement("TextButton", {
        Name = tabName .. "Tab",
        Size = UDim2.new(0, 120, 1, 0),
        BackgroundColor3 = self.Theme.TabInactive,
        BorderSizePixel = 0,
        Text = tabName,
        TextColor3 = self.Theme.TextSecondary,
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        Parent = self.TabsContainer
    })

    -- Criar conteúdo da tab
    local tabContent = self:CreateElement("ScrollingFrame", {
        Name = tabName .. "Content",
        Size = UDim2.new(1, -20, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.ContentArea
    })

    -- Layout para organizar elementos
    local layout = self:CreateElement("UIListLayout", {
        Padding = UDim.new(0, 10),
        Parent = tabContent
    })

    -- Armazenar tab
    local tabData = {
        Name = tabName,
        Button = tabButton,
        Content = tabContent
    }

    table.insert(self.Tabs, tabData)
    self.TabContents[tabName] = tabContent

    -- Evento de clique na tab
    tabButton.MouseButton1Click:Connect(function()
        self:SwitchToTab(tabName)
    end)

    -- Efeitos hover na tab
    tabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= tabName then
            tabButton.BackgroundColor3 = self.Theme.AccentHover
            tabButton.TextColor3 = self.Theme.TextPrimary
        end
    end)

    tabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= tabName then
            tabButton.BackgroundColor3 = self.Theme.TabInactive
            tabButton.TextColor3 = self.Theme.TextSecondary
        end
    end)

    -- Se for a primeira tab, ativar
    if #self.Tabs == 1 then
        self:SwitchToTab(tabName)
    end

    return tabData
end

-- Mudar para tab
function MultiUI:SwitchToTab(tabName)
    -- Desativar todas as tabs
    for _, tab in pairs(self.Tabs) do
        tab.Content.Visible = false
        tab.Button.BackgroundColor3 = self.Theme.TabInactive
        tab.Button.TextColor3 = self.Theme.TextSecondary
    end

    -- Ativar tab selecionada
    local targetTab = self.TabContents[tabName]
    if targetTab then
        targetTab.Visible = true
        for _, tab in pairs(self.Tabs) do
            if tab.Name == tabName then
                tab.Button.BackgroundColor3 = self.Theme.TabActive
                tab.Button.TextColor3 = self.Theme.TextPrimary
            end
        end
        self.CurrentTab = tabName
    end
end

-- Criar seção organizada (como na sua referência)
function MultiUI:CreateSection(tab, sectionName)
    local section = self:CreateElement("Frame", {
        Name = sectionName .. "Section",
        Size = UDim2.new(1, 0, 0, 40), -- Altura automática depois
        BackgroundColor3 = self.Theme.Section,
        BorderSizePixel = 0,
        Parent = tab.Content
    })

    -- Título da seção
    local title = self:CreateElement("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 5),
        BackgroundTransparency = 1,
        Text = sectionName,
        TextColor3 = self.Theme.TextAccent,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = section
    })

    -- Container para elementos da seção
    local contentContainer = self:CreateElement("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -20, 1, -35),
        Position = UDim2.new(0, 10, 0, 30),
        BackgroundTransparency = 1,
        Parent = section
    })

    local contentLayout = self:CreateElement("UIListLayout", {
        Padding = UDim.new(0, 8),
        Parent = contentContainer
    })

    -- Atualizar altura automaticamente
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        section.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 40)
    end)

    return contentContainer
end

-- Componente Toggle moderno
function MultiUI:CreateToggle(section, options)
    options = options or {}
    
    local toggleFrame = self:CreateElement("Frame", {
        Name = "Toggle_" .. options.Name,
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Parent = section
    })

    local label = self:CreateElement("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = options.Name or "Toggle",
        TextColor3 = self.Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = toggleFrame
    })

    local toggleButton = self:CreateElement("TextButton", {
        Name = "ToggleButton",
        Size = UDim2.new(0, 45, 0, 20),
        Position = UDim2.new(1, -45, 0, 2),
        BackgroundColor3 = self.Theme.TabInactive,
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
            toggleIndicator:TweenPosition(UDim2.new(1, -18, 0, 2), "Out", "Quad", 0.2)
            toggleIndicator.BackgroundColor3 = self.Theme.Success
            toggleButton.BackgroundColor3 = self.Theme.Success
        else
            toggleIndicator:TweenPosition(UDim2.new(0, 2, 0, 2), "Out", "Quad", 0.2)
            toggleIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            toggleButton.BackgroundColor3 = self.Theme.TabInactive
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

-- Componente Button moderno
function MultiUI:CreateButton(section, options)
    options = options or {}
    
    local button = self:CreateElement("TextButton", {
        Name = "Button_" .. options.Name,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Text = options.Name or "Button",
        TextColor3 = self.Theme.TextPrimary,
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        AutoButtonColor = false,
        Parent = section
    })

    -- Efeitos hover
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = self.Theme.AccentHover
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = self.Theme.Accent
    end)

    button.MouseButton1Down:Connect(function()
        button.BackgroundColor3 = self.Theme.AccentHover:Lerp(Color3.new(0, 0, 0), 0.2)
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

-- Componente Slider moderno
function MultiUI:CreateSlider(section, options)
    options = options or {}
    
    local sliderFrame = self:CreateElement("Frame", {
        Name = "Slider_" .. options.Name,
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundTransparency = 1,
        Parent = section
    })

    local labelRow = self:CreateElement("Frame", {
        Name = "LabelRow",
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        Parent = sliderFrame
    })

    local label = self:CreateElement("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.7, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = options.Name or "Slider",
        TextColor3 = self.Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = labelRow
    })

    local valueLabel = self:CreateElement("TextLabel", {
        Name = "Value",
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(options.Default or options.Min or 0),
        TextColor3 = self.Theme.TextAccent,
        TextXAlignment = Enum.TextXAlignment.Right,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        Parent = labelRow
    })

    local sliderTrack = self:CreateElement("Frame", {
        Name = "Track",
        Size = UDim2.new(1, 0, 0, 15),
        Position = UDim2.new(0, 0, 0, 25),
        BackgroundColor3 = self.Theme.TabInactive,
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

    local dragging = false

    local function updateFromMouse()
        if not dragging then return end
        
        local mousePosition = UserInputService:GetMouseLocation()
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

    UserInputService.InputChanged:Connect(function(input)
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

-- Sistema de notificação
function MultiUI:Notify(message, type)
    type = type or "Info"
    
    local color = self.Theme.Accent
    if type == "Success" then color = self.Theme.Success
    elseif type == "Warning" then color = self.Theme.Warning
    elseif type == "Error" then color = self.Theme.Error end

    -- Implementar sistema de notificação depois
    print("🔔 Anime Eternal MultiHub:", message)
end

return MultiUI
