--[[
   🎮 MultiUI Library - Professional Edition
   Intro com efeito de digitação + Interface limpa
   Por Allanursulino
--]]

local MultiUI = {}
MultiUI.__index = MultiUI

-- Configurações
MultiUI.ToggleUIKey = Enum.KeyCode.RightControl

-- Tema Profissional
MultiUI.Theme = {
    Background = Color3.fromRGB(13, 17, 23),      -- Fundo escuro azulado
    Surface = Color3.fromRGB(22, 27, 34),         -- Superfície
    SurfaceLight = Color3.fromRGB(33, 38, 45),    -- Superfície clara
    Primary = Color3.fromRGB(88, 166, 255),       -- Azul profissional
    PrimaryHover = Color3.fromRGB(108, 182, 255), -- Azul hover
    TextPrimary = Color3.fromRGB(248, 250, 252),  -- Branco suave
    TextSecondary = Color3.fromRGB(139, 148, 158),-- Cinza texto
    Border = Color3.fromRGB(48, 54, 61),          -- Bordas
    Success = Color3.fromRGB(87, 171, 90),        -- Verde
    Warning = Color3.fromRGB(215, 158, 0),        -- Amarelo
    Error = Color3.fromRGB(248, 81, 73)           -- Vermelho
}

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Variáveis
local player = Players.LocalPlayer

-- Função auxiliar
function MultiUI:CreateElement(className, properties)
    local element = Instance.new(className)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

-- Efeito de digitação (letra por letra)
function MultiUI:TypewriterEffect(label, text, speed, callback)
    label.Text = ""
    local currentText = ""
    
    for i = 1, #text do
        currentText = currentText .. string.sub(text, i, i)
        label.Text = currentText
        wait(speed or 0.05)
    end
    
    if callback then
        callback()
    end
end

-- Intro com efeito de digitação
function MultiUI:ShowIntroAnimation(callback)
    -- Tela de intro transparente
    local introFrame = self:CreateElement("Frame", {
        Name = "IntroFrame",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.3, -- Fundo semi-transparente
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })

    -- Texto da intro
    local introText = self:CreateElement("TextLabel", {
        Name = "IntroText",
        Size = UDim2.new(0, 400, 0, 100),
        Position = UDim2.new(0.5, -200, 0.5, -50),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextScaled = true,
        Font = Enum.Font.GothamBlack,
        TextSize = 48,
        TextStrokeTransparency = 0.5,
        Parent = introFrame
    })

    -- Efeito de digitação
    self:TypewriterEffect(introText, "MultiUI", 0.1, function()
        wait(1) -- Manter texto por 1 segundo
        
        -- Fade out suave
        local fadeOut = TweenService:Create(introFrame, TweenInfo.new(0.8), {
            BackgroundTransparency = 1
        })
        fadeOut:Play()
        
        fadeOut.Completed:Connect(function()
            introFrame:Destroy()
            if callback then callback() end
        end)
    end)
end

-- Criar UI principal
function MultiUI:CreateGUI()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end

    -- ScreenGui principal
    self.ScreenGui = self:CreateElement("ScreenGui", {
        Name = "MultiUIProfessional",
        DisplayOrder = 999,
        ResetOnSpawn = false
    })

    -- Mostrar intro primeiro
    self:ShowIntroAnimation(function()
        self:CreateMainInterface()
    end)
    
    self.ScreenGui.Parent = player:WaitForChild("PlayerGui")
    
    return self
end

-- Criar interface principal (estilo da 3ª imagem)
function MultiUI:CreateMainInterface()
    -- Container principal (estilo profissional)
    self.MainContainer = self:CreateElement("Frame", {
        Name = "MainContainer",
        Size = UDim2.new(0, 700, 0, 550), -- Tamanho maior para mais conteúdo
        Position = UDim2.new(0.5, -350, 0.5, -275),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 1,
        BorderColor3 = self.Theme.Border,
        ClipsDescendants = true,
        Visible = false, -- Inicia invisível
        Parent = self.ScreenGui
    })

    -- Header limpo (sem título)
    self.Header = self:CreateElement("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 5), -- Header mínimo
        BackgroundColor3 = self.Theme.Primary,
        BorderSizePixel = 0,
        Parent = self.MainContainer
    })

    -- Área de navegação (tabs estilo profissional)
    self.NavArea = self:CreateElement("Frame", {
        Name = "NavArea",
        Size = UDim2.new(1, -30, 0, 40),
        Position = UDim2.new(0, 15, 0, 15),
        BackgroundTransparency = 1,
        Parent = self.MainContainer
    })

    self.TabsContainer = self:CreateElement("Frame", {
        Name = "TabsContainer",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Parent = self.NavArea
    })

    self.TabsLayout = self:CreateElement("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 8),
        Parent = self.TabsContainer
    })

    -- Área de conteúdo principal
    self.ContentArea = self:CreateElement("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -30, 1, -70),
        Position = UDim2.new(0, 15, 0, 65),
        BackgroundTransparency = 1,
        Parent = self.MainContainer
    })

    -- Configurar eventos
    self:SetupEvents()
    
    -- Mostrar UI após criar
    self.MainContainer.Visible = true
end

-- Configurar eventos
function MultiUI:SetupEvents()
    -- Toggle com tecla
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == self.ToggleUIKey then
            self.MainContainer.Visible = not self.MainContainer.Visible
        end
    end)

    -- Sistema de drag pelo header
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

-- Sistema de Tabs profissional
function MultiUI:CreateTab(tabName)
    if not self.Tabs then
        self.Tabs = {}
        self.TabContents = {}
    end

    -- Botão da tab (estilo profissional)
    local tabButton = self:CreateElement("TextButton", {
        Name = tabName .. "Tab",
        Size = UDim2.new(0, 120, 1, 0),
        BackgroundColor3 = self.Theme.Surface,
        BorderColor3 = self.Theme.Border,
        BorderSizePixel = 1,
        Text = tabName,
        TextColor3 = self.Theme.TextSecondary,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        AutoButtonColor = false,
        Parent = self.TabsContainer
    })

    -- Conteúdo da tab
    local tabContent = self:CreateElement("ScrollingFrame", {
        Name = tabName .. "Content",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = self.ContentArea
    })

    -- Layout organizado
    local layout = self:CreateElement("UIListLayout", {
        Padding = UDim.new(0, 12),
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

    -- Eventos da tab
    tabButton.MouseButton1Click:Connect(function()
        self:SwitchToTab(tabName)
    end)

    -- Efeitos hover
    tabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= tabName then
            tabButton.BackgroundColor3 = self.Theme.SurfaceLight
        end
    end)

    tabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= tabName then
            tabButton.BackgroundColor3 = self.Theme.Surface
        end
    end)

    -- Primeira tab ativa
    if #self.Tabs == 1 then
        self:SwitchToTab(tabName)
    end

    return tabData
end

-- Mudar para tab
function MultiUI:SwitchToTab(tabName)
    -- Desativar todas
    for _, tab in pairs(self.Tabs) do
        tab.Content.Visible = false
        tab.Button.BackgroundColor3 = self.Theme.Surface
        tab.Button.TextColor3 = self.Theme.TextSecondary
        tab.Button.BorderSizePixel = 1
    end

    -- Ativar selecionada
    local targetTab = self.TabContents[tabName]
    if targetTab then
        targetTab.Visible = true
        for _, tab in pairs(self.Tabs) do
            if tab.Name == tabName then
                tab.Button.BackgroundColor3 = self.Theme.Primary
                tab.Button.TextColor3 = self.Theme.TextPrimary
                tab.Button.BorderSizePixel = 0
            end
        end
        self.CurrentTab = tabName
    end
end

-- Criar seção (estilo da 3ª imagem)
function MultiUI:CreateSection(tab, sectionName)
    local section = self:CreateElement("Frame", {
        Name = sectionName .. "Section",
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = self.Theme.Surface,
        BorderColor3 = self.Theme.Border,
        BorderSizePixel = 1,
        Parent = tab.Content
    })

    -- Título da seção
    local title = self:CreateElement("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Text = sectionName,
        TextColor3 = self.Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        Parent = section
    })

    -- Container de conteúdo
    local contentContainer = self:CreateElement("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -20, 1, -40),
        Position = UDim2.new(0, 10, 0, 35),
        BackgroundTransparency = 1,
        Parent = section
    })

    local contentLayout = self:CreateElement("UIListLayout", {
        Padding = UDim.new(0, 8),
        Parent = contentContainer
    })

    -- Altura automática
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        section.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 45)
    end)

    return contentContainer
end

-- Criar linha de informação (como "Total All Pets: 4131")
function MultiUI:CreateInfoRow(tab, label, value)
    local row = self:CreateElement("Frame", {
        Name = "InfoRow",
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Parent = tab.Content
    })

    local labelText = self:CreateElement("TextLabel", {
        Name = "Label",
        Size = UDim2.new(0.6, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = self.Theme.TextSecondary,
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.Gotham,
        TextSize = 12,
        Parent = row
    })

    local valueText = self:CreateElement("TextLabel", {
        Name = "Value",
        Size = UDim2.new(0.4, 0, 1, 0),
        Position = UDim2.new(0.6, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(value),
        TextColor3 = self.Theme.TextPrimary,
        TextXAlignment = Enum.TextXAlignment.Right,
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        Parent = row
    })

    return {
        Update = function(newValue)
            valueText.Text = tostring(newValue)
        end
    }
end

-- Componente Toggle profissional
function MultiUI:CreateToggle(section, options)
    options = options or {}
    
    local toggleFrame = self:CreateElement("Frame", {
        Name = "Toggle_" .. options.Name,
        Size = UDim2.new(1, 0, 0, 30),
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
        TextSize = 13,
        Parent = toggleFrame
    })

    local toggleButton = self:CreateElement("TextButton", {
        Name = "ToggleButton",
        Size = UDim2.new(0, 45, 0, 22),
        Position = UDim2.new(1, -45, 0, 4),
        BackgroundColor3 = self.Theme.SurfaceLight,
        BorderColor3 = self.Theme.Border,
        BorderSizePixel = 1,
        Text = "",
        AutoButtonColor = false,
        Parent = toggleFrame
    })

    local toggleIndicator = self:CreateElement("Frame", {
        Name = "Indicator",
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0, 2, 0, 2),
        BackgroundColor3 = self.Theme.TextSecondary,
        BorderSizePixel = 0,
        Parent = toggleButton
    })

    local state = options.Default or false

    local function updateToggle()
        if state then
            toggleIndicator:TweenPosition(UDim2.new(1, -20, 0, 2), "Out", "Quad", 0.15)
            toggleIndicator.BackgroundColor3 = self.Theme.Success
            toggleButton.BackgroundColor3 = self.Theme.Success
            toggleButton.BorderSizePixel = 0
        else
            toggleIndicator:TweenPosition(UDim2.new(0, 2, 0, 2), "Out", "Quad", 0.15)
            toggleIndicator.BackgroundColor3 = self.Theme.TextSecondary
            toggleButton.BackgroundColor3 = self.Theme.SurfaceLight
            toggleButton.BorderSizePixel = 1
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

-- Componente Button profissional
function MultiUI:CreateButton(section, options)
    options = options or {}
    
    local button = self:CreateElement("TextButton", {
        Name = "Button_" .. options.Name,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = self.Theme.SurfaceLight,
        BorderColor3 = self.Theme.Border,
        BorderSizePixel = 1,
        Text = options.Name or "Button",
        TextColor3 = self.Theme.TextPrimary,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        AutoButtonColor = false,
        Parent = section
    })

    -- Efeitos hover
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = self.Theme.Primary
        button.BorderSizePixel = 0
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = self.Theme.SurfaceLight
        button.BorderSizePixel = 1
    end)

    button.MouseButton1Down:Connect(function()
        button.BackgroundColor3 = self.Theme.PrimaryHover
    end)

    button.MouseButton1Up:Connect(function()
        button.BackgroundColor3 = self.Theme.Primary
    end)

    -- Callback
    if options.Callback then
        button.MouseButton1Click:Connect(options.Callback)
    end

    return button
end

-- Componente Slider profissional
function MultiUI:CreateSlider(section, options)
    options = options or {}
    
    local sliderFrame = self:CreateElement("Frame", {
        Name = "Slider_" .. options.Name,
        Size = UDim2.new(1, 0, 0, 55),
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
        TextSize = 13,
        Parent = labelRow
    })

    local valueLabel = self:CreateElement("TextLabel", {
        Name = "Value",
        Size = UDim2.new(0.3, 0, 1, 0),
        Position = UDim2.new(0.7, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(options.Default or options.Min or 0),
        TextColor3 = self.Theme.Primary,
        TextXAlignment = Enum.TextXAlignment.Right,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        Parent = labelRow
    })

    local sliderTrack = self:CreateElement("Frame", {
        Name = "Track",
        Size = UDim2.new(1, 0, 0, 18),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = self.Theme.SurfaceLight,
        BorderColor3 = self.Theme.Border,
        BorderSizePixel = 1,
        Parent = sliderFrame
    })

    local sliderFill = self:CreateElement("Frame", {
        Name = "Fill",
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundColor3 = self.Theme.Primary,
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
    print("🔔 MultiUI:", message)
end

return MultiUI
