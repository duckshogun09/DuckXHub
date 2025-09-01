-- BlackScreen.lua
local TweenService = game:GetService("TweenService")
local function BlackScreenEffect(PlayerGui)
    local introGui = Instance.new("ScreenGui")
    introGui.Name = "DuckXHubIntroGui"
    introGui.IgnoreGuiInset = true
    introGui.ResetOnSpawn = false
    introGui.DisplayOrder = 999999
    introGui.Parent = PlayerGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3 = Color3.new(0, 0, 0)
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel = 0
    bg.Parent = introGui

    local title = Instance.new("TextLabel")
    title.Text = "DuckXHub"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 64
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextTransparency = 1
    title.BackgroundTransparency = 1
    title.Position = UDim2.new(0.5, -180, 0.4, 0)
    title.Size = UDim2.new(0, 360, 0, 80)
    title.Parent = introGui

    local madeBy = Instance.new("TextLabel")
    madeBy.Text = "Made by duckfankurumi"
    madeBy.Font = Enum.Font.Gotham
    madeBy.TextSize = 22
    madeBy.TextColor3 = Color3.fromRGB(200, 200, 200)
    madeBy.TextTransparency = 1
    madeBy.BackgroundTransparency = 1
    madeBy.Position = UDim2.new(0.5, -120, 0.49, 0)
    madeBy.Size = UDim2.new(0, 240, 0, 35)
    madeBy.Parent = introGui

    -- Fade-in
    TweenService:Create(bg, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.2}):Play()
    for _, lbl in ipairs({title, madeBy}) do
        TweenService:Create(lbl, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
    end

    wait(1.5)

    -- Fade-out
    local fadeTween = TweenService:Create(bg, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
    fadeTween:Play()
    for _, lbl in ipairs({title, madeBy}) do
        TweenService:Create(lbl, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
    end
    fadeTween.Completed:Wait()
    introGui:Destroy()
end

-- Black Screen Toggle GUI
local BlackScreenGui = nil
local function SetBlackScreen(PlayerGui, state)
    if state then
        if not BlackScreenGui then
            BlackScreenGui = Instance.new("ScreenGui")
            BlackScreenGui.Name = "BlackScreen"
            BlackScreenGui.IgnoreGuiInset = true
            BlackScreenGui.ResetOnSpawn = false
            BlackScreenGui.DisplayOrder = 0
            BlackScreenGui.Parent = PlayerGui

            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(1, 0, 1, 0)
            bg.BackgroundColor3 = Color3.new(0, 0, 0)
            bg.BorderSizePixel = 0
            bg.BackgroundTransparency = 0.05
            bg.Parent = BlackScreenGui

            local title = Instance.new("TextLabel")
            title.Text = "DuckXHub"
            title.Font = Enum.Font.GothamBlack
            title.TextSize = 60
            title.TextColor3 = Color3.fromRGB(255, 255, 255)
            title.BackgroundTransparency = 1
            title.AnchorPoint = Vector2.new(0.5, 0.5)
            title.Position = UDim2.new(0.5, 0, 0.45, 0)
            title.Size = UDim2.new(0, 600, 0, 80)
            title.TextStrokeTransparency = 0.7
            title.TextStrokeColor3 = Color3.fromRGB(60, 60, 60)
            title.TextWrapped = true
            title.Parent = BlackScreenGui

            local subtitle = Instance.new("TextLabel")
            subtitle.Text = "Grow A Garden"
            subtitle.Font = Enum.Font.GothamSemibold
            subtitle.TextSize = 40
            subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
            subtitle.BackgroundTransparency = 1
            subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
            subtitle.Position = UDim2.new(0.5, 0, 0.55, 0)
            subtitle.Size = UDim2.new(0, 520, 0, 50)
            subtitle.TextStrokeTransparency = 0.8
            subtitle.TextStrokeColor3 = Color3.fromRGB(30, 30, 30)
            subtitle.TextWrapped = true
            subtitle.Parent = BlackScreenGui

            local discordLink = Instance.new("TextLabel")
            discordLink.Text = "discord.gg/ekxRybWgmh"
            discordLink.Font = Enum.Font.GothamBold
            discordLink.TextSize = 28
            discordLink.TextColor3 = Color3.fromRGB(100, 200, 255)
            discordLink.BackgroundTransparency = 1
            discordLink.AnchorPoint = Vector2.new(0.5, 0.5)
            discordLink.Position = UDim2.new(0.5, 0, 0.62, 0)
            discordLink.Size = UDim2.new(0, 400, 0, 35)
            discordLink.TextStrokeTransparency = 0.85
            discordLink.TextStrokeColor3 = Color3.fromRGB(30, 60, 80)
            discordLink.TextWrapped = true
            discordLink.Parent = BlackScreenGui
        end
    else
        if BlackScreenGui then
            BlackScreenGui:Destroy()
            BlackScreenGui = nil
        end
    end
end

return { BlackScreenEffect = BlackScreenEffect, SetBlackScreen = SetBlackScreen }
