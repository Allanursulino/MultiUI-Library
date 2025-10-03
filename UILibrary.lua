--[[
   🎮 MultiUI Library - Final Edition
   Exatamente como você pediu: vermelho/preto, bordas redondas, efeito digitação
   Por Allanursulino
--]]

local MultiUI = {}
MultiUI.__index = MultiUI

-- Configurações
MultiUI.ToggleUIKey = Enum.KeyCode.RightControl

-- Tema VERMELHO/PRETO como você pediu
MultiUI.Theme = {
    Background = Color3.fromRGB(15, 15, 15),      -- Preto fundo
    Surface = Color3.fromRGB(25, 25, 25),         -- Preto superfície
    SurfaceLight = Color3.fromRGB(35, 35, 35),    -- Preto mais claro
    Primary = Color3.fromRGB(220, 20, 60),        -- Vermelho vibrante
    PrimaryHover = Color3.fromRGB(240, 40, 80),   -- Vermelho hover
    TextPrimary = Color3.fromRGB(255, 255, 255),  -- Branco
    TextSecondary = Color3.fromRGB(200, 200, 200),-- Cinza claro
    Border = Color3.fromRGB(80, 0, 0),            -- Bordas vermelhas escuras
    Success = Color3.fromRGB(0, 255, 0),          -- Verde
    Warning = Color3.fromRGB(255, 165, 0),        -- Laranja
    Error = Color3.fromRGB(255, 50, 50)           -- Vermelho erro
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

-- Criar cantos arredondados
function MultiUI:AddRoundCorners(frame, cornerRadius)
    local corners = self:CreateElement("UICorner", {
        CornerRadius = UDim.new(0, cornerRadius or 8),
        Parent = frame
    })
    return corners
end

-- Efeito de digitação CORRETO (letra por letra)
function MultiUI:TypewriterEffect(label, text, speed, callback)
    label.Text = ""
    local currentText = ""
    
    for i = 1, #text do
        currentText = currentText .. string.sub(text, i, i)
        label.Text = currentText
        wait(speed or 0.08) -- Velocidade da digitação
    end
    
    -- Manter por 2 segundos como você pediu
    wait(2)
    
    if callback then
        callback()
    end
end

-- Intro com efeito de digitação CORRETO
function MultiUI:ShowIntroAnimation(callback)
    -- Tela de intro transparente
    local introFrame = self:CreateElement("Frame", {
        Name = "IntroFrame",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.2, -- Fundo semi-transparente
        BorderSizePixel = 0,
        Parent = self.ScreenGui
    })

    -- Texto da intro centralizado
    local introText = self:CreateElement("TextLabel", {
        Name = "IntroText",
        Size = UDim2.new(0, 300, 0, 80),
        Position = UDim2.new(0.5, -150, 0.5, -40),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Color3.fromRGB(220, 20, 60), -- Vermelho
        TextScaled = true,
        Font = Enum.Font.GothamBlack,
        TextSize = 48,
        TextStrokeTransparency = 0.7,
        Parent = introFrame
    })

    -- Efeito de digitação CORRETO
    self:TypewriterEffect(introText, "MultiUI", 0.1, function()
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
        Name = "MultiUIFinal",
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

-- Criar interface principal MODERNA
function MultiUI:CreateMainInterface()
    -- Container principal com BORDAS ARREDONDADAS
    self.MainContainer = self:CreateElement("Frame", {
        Name = "MainContainer",
        Size = UDim2.new(0, 600, 0, 450),
        Position = UDim2.new(0.5, -300, 0.5, -225),
        BackgroundColor3 = self.Theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = self.ScreenGui
    })

    -- BORDAS ARREDONDADAS no container
    self:AddRoundCorners(self.MainContainer, 12)

    -- Header com SUA LOGO E NOME no canto esquerdo
    self.Header = self:CreateElement("Frame", {
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = self.Theme.Surface,
        BorderSizePixel = 0,
        Parent = self.MainContainer
    })

    -- BORDAS ARREDONDADAS só na parte de cima do header
    local headerCorners = self:CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 12),
        Parent = self.Header
    })
    headerCorners.CornerRadius = UDim.new(0, 12)

    -- SUA LOGO E NOME no canto superior esquerdo
    self.Logo = self:CreateElement("TextLabel", {
        Name = "Logo",
        Size = UDim2.new(0, 150, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = "MultiUI Library", -- SEU NOME AQUI
        TextColor3 = self.Theme.Primary, -- Vermelho
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBlack,
        TextSize = 16,
        TextStrokeTransparency = 0.7,
        Parent = self.Header
    })

    -- Área de navegação (tabs)
    self.NavArea = self:CreateElement("Frame", {
        Name = "NavArea",
        Size = UDim2.new(1, -30, 0, 40),
        Position = UDim2.new(0, 15, 0, 60),
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
        Padding = UDim.new(0, 10),
        Parent = self.TabsContainer
    })

    -- Área de conteúdo
    self.ContentArea = self:CreateElement("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -30, 1, -110),
        Position = UDim2.new(0, 15, 0, 110),
        BackgroundTransparency = 1,
        Parent = self.MainContainer
    })

    -- Configurar eventos
    self:SetupEvents()
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

-- Sistema de Tabs MODERNO com bordas arredondadas
function MultiUI:CreateTab(tabName)
    if not self.Tabs then
        self.Tabs = {}
        self.TabContents = {}
    end

    -- Botão da tab COM BORDAS ARREDONDADAS
    local tabButton = self:CreateElement("TextButton", {
        Name = tabName .. "Tab",
        Size = UDim2.new(0, 100, 1, 0),
        BackgroundColor3 = self.Theme.Surface,
        BorderSizePixel = 0,
        Text = tabName,
        TextColor3 = self.Theme.TextSecondary,
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        AutoButtonColor = false,
        Parent = self.TabsContainer
    })

    -- BORDAS ARREDONDADAS na tab
    self:AddRoundCorners(tabButton, 6)

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
        Padding = UDim.new(0, 15),
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
            tabButton.TextColor3 = self.Theme.TextPrimary
        end
    end)

    tabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= tabName then
            tabButton.BackgroundColor3 = self.Theme.Surface
            tabButton.TextColor3 = self.Theme.TextSecondary
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
    end

    -- Ativar selecionada
    local targetTab = self.TabContents[tabName]
    if targetTab then
        targetTab.Visible = true
        for _, tab in pairs(self.Tabs) do
            if tab.Name == tabName then
                tab.Button.BackgroundColor3 = self.Theme.Primary -- Vermelho
                tab.Button.TextColor3 = self.Theme.TextPrimary
            end
        end
        self.CurrentTab = tabName
    end
end

-- Criar seção MODERNA com bordas arredondadas
function MultiUI:CreateSection(tab, sectionName)
    local section = self:CreateElement("Frame", {
        Name = sectionName .. "Section",
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = self.Theme.Surface,
        BorderSizePixel = 0,
        Parent = tab.Content
    })

    -- BORDAS ARREDONDADAS na seção
    self:AddRoundCorners(section, 8)

    -- Título da seção
    local title = self:CreateElement("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -20, 0, 25),
        Position = UDim2.new(0, 10, 0, 8),
        BackgroundTransparency = 1,
        Text = sectionName,
        TextColor3 = self.Theme.Primary, -- Vermelho
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
        Padding = UDim.new(0, 10),
        Parent = contentContainer
    })

    -- Altura automática
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        section.Size = UDim2.new(1, 0, 0, contentLayout.AbsoluteContentSize.Y + 45)
    end)

    return contentContainer
end

-- Componente Toggle MODERNO com bordas arredondadas
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

    -- Toggle button COM BORDAS ARREDONDADAS
    local toggleButton = self:CreateElement("TextButton", {
        Name = "ToggleButton",
        Size = UDim2.new(0, 50, 0, 25),
        Position = UDim2.new(1, -50, 0, 2),
        BackgroundColor3 = self.Theme.SurfaceLight,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = toggleFrame
    })

    -- BORDAS ARREDONDADAS no toggle
    self:AddRoundCorners(toggleButton, 12)

    -- Indicador do toggle COM BORDAS ARREDONDADAS
    local toggleIndicator = self:CreateElement("Frame", {
        Name = "Indicator",
        Size = UDim2.new(0, 21, 0, 21),
        Position = UDim2.new(0, 2, 0, 2),
        BackgroundColor3 = self.Theme.TextSecondary,
        BorderSizePixel = 0,
        Parent = toggleButton
    })

    -- BORDAS ARREDONDADAS no indicador
    self:AddRoundCorners(toggleIndicator, 10)

    local state = options.Default or false

    local function updateToggle()
        if state then
            toggleIndicator:TweenPosition(UDim2.new(1, -23, 0, 2), "Out", "Quad", 0.2)
            toggleIndicator.BackgroundColor3 = self.Theme.Success
            toggleButton.BackgroundColor3 = self.Theme.Success
        else
            toggleIndicator:TweenPosition(UDim2.new(0, 2, 0, 2), "Out", "Quad", 0.2)
            toggleIndicator.BackgroundColor3 = self.Theme.TextSecondary
            toggleButton.BackgroundColor3 = self.Theme.SurfaceLight
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

-- Componente Button MODERNO com RELEVO e bordas arredondadas
function MultiUI:CreateButton(section, options)
    options = options or {}
    
    -- Button COM BORDAS ARREDONDADAS
    local button = self:CreateElement("TextButton", {
        Name = "Button_" .. options.Name,
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = self.Theme.SurfaceLight,
        BorderSizePixel = 0,
        Text = options.Name or "Button",
        TextColor3 = self.Theme.TextPrimary,
        Font = Enum.Font.GothamSemibold,
        TextSize = 13,
        AutoButtonColor = false,
        Parent = section
    })

    -- BORDAS ARREDONDADAS no botão
    self:AddRoundCorners(button, 8)

    -- Efeito de RELEVO (sombra interna)
    local innerShadow = self:CreateElement("UIStroke", {
        Color = Color3.new(0, 0, 0),
        Thickness = 1,
        Transparency = 0.8,
        Parent = button
    })

    -- Efeitos hover com RELEVO
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = self.Theme.Primary -- Vermelho
        innerShadow.Transparency = 0.9
    end)

    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = self.Theme.SurfaceLight
        innerShadow.Transparency = 0.8
    end)

    button.MouseButton1Down:Connect(function()
        button.BackgroundColor3 = self.Theme.PrimaryHover
        innerShadow.Transparency = 0.7
    end)

    button.MouseButton1Up:Connect(function()
        button.BackgroundColor3 = self.Theme.Primary
        innerShadow.Transparency = 0.9
    end)

    -- Callback
    if options.Callback then
        button.MouseButton1Click:Connect(options.Callback)
    end

    return button
end

-- Componente Slider MODERNO com bordas arredondadas
function MultiUI:CreateSlider(section, options)
    options = options or {}
    
    local sliderFrame = self:CreateElement("Frame", {
        Name = "Slider_" .. options.Name,
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundTransparency = 1,
        Parent = section
    })

    local labelRow = self:CreateElement("Frame", {
        Name = "LabelRow",
        Size = UDim2.new(1, 0, 0, 25),
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
        TextColor3 = self.Theme.Primary, -- Vermelho
        TextXAlignment = Enum.TextXAlignment.Right,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        Parent = labelRow
    })

    -- Slider track COM BORDAS ARREDONDADAS
    local sliderTrack = self:CreateElement("Frame", {
        Name = "Track",
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 30),
        BackgroundColor3 = self.Theme.SurfaceLight,
        BorderSizePixel = 0,
        Parent = sliderFrame
    })

    -- BORDAS ARREDONDADAS no track
    self:AddRoundCorners(sliderTrack, 10)

    -- Slider fill COM BORDAS ARREDONDADAS
    local sliderFill = self:CreateElement("Frame", {
        Name = "Fill",
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundColor3 = self.Theme.Primary, -- Vermelho
        BorderSizePixel = 0,
        Parent = sliderTrack
    })

    -- BORDAS ARREDONDADAS no fill
    self:AddRoundCorners(sliderFill, 10)

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
