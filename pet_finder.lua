local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- Dùng biến toàn cục từ loader
local webhook = Webhook_URL or ""
local target = TargetName or "Unknown Pet"

local function notify(title, text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 5
        })
    end)
end

local function sendWebhook(title, description, color)
    pcall(function()
        local syn = syn or {}
        syn.request = syn.request or http_request

        syn.request({
            Url = webhook,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode({
                content = "",
                embeds = {{
                    title = "**" .. title .. "**",
                    description = description,
                    type = "rich",
                    color = tonumber(color),
                    timestamp = DateTime.now():ToIsoDate(),
                    fields = {
                        {
                            name = "Username",
                            value = "||" .. player.Name .. "||",
                            inline = true
                        },
                        {
                            name = "Hardware ID",
                            value = "||" .. game:GetService("RbxAnalyticsService"):GetClientId() .. "||",
                            inline = true
                        }
                    }
                }}
            })
        })
    end)
end

local notrejoin = false
local sentPetWebhook = false
local sentNotFoundWebhook = false
local DataSer = require(game:GetService("ReplicatedStorage").Modules.DataService)

while true do
    wait()
    for _, v in pairs(DataSer:GetData().SavedObjects) do
        if v.ObjectType == "PetEgg" and v.Data.RandomPetData and v.Data.CanHatch then
            if v.Data.RandomPetData.Name == target then
                notrejoin = true
                if not sentPetWebhook then
                    sendWebhook("🎯 Found Target Pet!", player.Name .. " đã tìm thấy pet: **" .. target .. "**", 0x00FF00)
                    notify("🎯 Found Pet", "Đã tìm thấy pet: " .. target)
                    sentPetWebhook = true
                end
            end
        end
    end

    if notrejoin then
        print("✅ Found Eggs!")
    else
        if not sentNotFoundWebhook then
            local description = "Không tìm thấy pet `" .. target .. "`.\nĐang rejoin game..."
            sendWebhook("❌ Pet Not Found & Rejoining", description, 0xFF0000)
            notify("🔁 Rejoin", "Không tìm thấy pet. Đang rejoin...")
            sentNotFoundWebhook = true
            wait(3)
            player:Kick("Don't have your target pet\\Rejoin")
            task.wait(1)
            TeleportService:Teleport(game.PlaceId, player)
        end
    end
end
