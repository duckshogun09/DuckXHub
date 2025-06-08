-- PetFinder (LocalScript chạy sau PetConfig)

-- 🔃 CHỜ CẤU HÌNH CÓ GIÁ TRỊ
repeat wait() until _G.TargetName and _G.Webhook_URL

-- 📦 DỊCH VỤ
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local DataSer = require(game:GetService("ReplicatedStorage").Modules.DataService)

-- 🔁 BIẾN
local notrejoin = false
local sentPetWebhook = false
local sentNotFoundWebhook = false

-- 🔔 Gửi thông báo trong game
local function notify(title, msg)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = msg,
            Duration = 5
        })
    end)
end

-- 🌐 Gửi Webhook Discord
local function sendWebhook(title, description, color, mentionEveryone)
    if not _G.Webhook_URL or _G.Webhook_URL == "" then return end

    pcall(function()
        local syn = syn or {}
        syn.request = syn.request or http_request

        local payload = {
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
        }

        if mentionEveryone then
            payload.content = "@everyone"
        end

        syn.request({
            Url = _G.Webhook_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(payload)
        })
    end)
end

-- 🔄 VÒNG LẶP KIỂM TRA PET
while true do wait()
    for _, v in pairs(DataSer:GetData().SavedObjects) do
        if v.ObjectType == "PetEgg" then
            if v.Data.RandomPetData and v.Data.CanHatch then
                if v.Data.RandomPetData.Name == _G.TargetName then
                    notrejoin = true
                    if not sentPetWebhook then
                        sendWebhook("🎯 Found Target Pet!", "@everyone\nĐã tìm thấy pet: **" .. _G.TargetName .. "**", 0x00FF00, true)
                        notify("🎉 Found Pet", _G.TargetName)
                        sentPetWebhook = true
                    end
                end
            end
        end
    end

    if notrejoin then
        print("✅ Found Eggs!")
    else
        if not sentNotFoundWebhook then
            sendWebhook("❌ Pet Not Found", "Không tìm thấy pet `" .. _G.TargetName .. "`. Đang rejoin...", 0xFF0000)
            notify("🔁 Rejoining", "Không tìm thấy pet. Đang rejoin...")
            sentNotFoundWebhook = true

            wait(3)
            player:Kick("Don't have your target pet\\Rejoin")
            task.wait(1)
            TeleportService:Teleport(game.PlaceId, player)
        end
    end
end
