local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local DataSer = require(game:GetService("ReplicatedStorage").Modules.DataService)

local req = (syn and syn.request) or (http and http.request) or (request)
local webhookSent = false
local notrejoin = false
local userAllowed = nil

function createPrompt()
    local screenGui = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
    screenGui.Name = "EggPrompt"

    local frame = Instance.new("Frame", screenGui)
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    frame.BorderSizePixel = 0

    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, 0, 0.5, 0)
    textLabel.Position = UDim2.new(0, 0, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold

    local continueBtn = Instance.new("TextButton", frame)
    continueBtn.Size = UDim2.new(0.5, -5, 0.3, 0)
    continueBtn.Position = UDim2.new(0, 5, 0.6, 0)
    continueBtn.Text = "Continue"
    continueBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 100)
    continueBtn.TextColor3 = Color3.new(1, 1, 1)
    continueBtn.Font = Enum.Font.SourceSans
    continueBtn.TextScaled = true

    local stopBtn = Instance.new("TextButton", frame)
    stopBtn.Size = UDim2.new(0.5, -5, 0.3, 0)
    stopBtn.Position = UDim2.new(0.5, 5, 0.6, 0)
    stopBtn.Text = "Stop"
    stopBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    stopBtn.TextColor3 = Color3.new(1, 1, 1)
    stopBtn.Font = Enum.Font.SourceSans
    stopBtn.TextScaled = true

    local decisionMade = false
    local countdown = 5

    continueBtn.MouseButton1Click:Connect(function()
        if decisionMade then return end
        decisionMade = true
        userAllowed = true
        screenGui:Destroy()
    end)

    stopBtn.MouseButton1Click:Connect(function()
        if decisionMade then return end
        decisionMade = true
        userAllowed = false
        screenGui:Destroy()
    end)

        task.spawn(function()
        while countdown > 0 and not decisionMade do
            textLabel.Text = "Start egg scan and webhook?\nAuto-continue in " .. countdown .. "s..."
            countdown -= 1
            task.wait(1)
        end
        if not decisionMade then
            decisionMade = true
            userAllowed = true
            screenGui:Destroy()
        end
    end)
end


function sendWebhook(matchedPets)
    if webhookSent or not _G.Webhook or _G.Webhook == "" then
        print("⚠️ Webhook is empty or disabled. Skipping webhook.")
        webhookSent = true
        notrejoin = true
        return
    end

    local petList = "`" .. table.concat(matchedPets, "`, `") .. "`"
    local targetList = "`" .. table.concat(_G.TargetNames, "`, `") .. "`"

    local data = {
        content = "@everyone :egg: **Found Target Pet Egg(s)!**",
        embeds = {{
            title = ":tada: Target Pet Egg(s) Found!",
            description = "**Target Pets:** " .. targetList
                .. "\n**Pet(s) Found:** " .. petList
                .. "\n**Player Username:** ||" .. Player.Name .. "||",
            color = tonumber(0x00ff00),
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    if req then
        local success, err = pcall(function()
            req({
                Url = _G.Webhook,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode(data)
            })
        end)

        if success then
            webhookSent = true
            notrejoin = true
            print("✅ Webhook sent!")
        else
            warn("❌ Webhook failed:", err)
        end
    else
        warn("❌ No HTTP request method available.")
    end
end

createPrompt()
while userAllowed == nil do task.wait(0.1) end

if not userAllowed then
    warn("🛑 Script stopped by user.")
    return
end

print("✅ Starting egg scan...")

while not webhookSent do
    task.wait(1)
    local matchedPets = {}
    local data = DataSer:GetData()

    for _, v in pairs(data.SavedObjects) do
        if v.ObjectType == "PetEgg" and v.Data.RandomPetData and v.Data.CanHatch then
            local petName = v.Data.RandomPetData.Name
            for _, target in ipairs(_G.TargetNames) do
                if string.lower(petName) == string.lower(target) then
                    if not table.find(matchedPets, petName) then
                        table.insert(matchedPets, petName)
                        print("🎯 Match found:", petName)
                    end
                end
            end
        end
    end

    if #matchedPets > 0 then
        sendWebhook(matchedPets)
    else
        task.wait(3)
        Player:Kick("Don't have your target pet\nRejoin")
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, Player)
    end
end
