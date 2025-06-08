local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

local webhook = Webhook_URL or ""
local target = TargetName or _G.TargetName or "Unknown Pet"
local DataSer = require(game:GetService("ReplicatedStorage").Modules.DataService)

local notrejoin = false
local sentPetWebhook = false
local sentNotFoundWebhook = false

local function notify(title, msg)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = msg,
            Duration = 5
        })
    end)
end

local function sendWebhook(title, description, color, mentionEveryone)
    if not webhook or webhook == "" then return end

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
            Url = webhook,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(payload)
        })
    end)
end


while true do wait()
    for _, v in pairs(DataSer:GetData().SavedObjects) do
        if v.ObjectType == "PetEgg" and v.Data.RandomPetData and v.Data.CanHatch then
            if v.Data.RandomPetData.Name == target then
                notrejoin = true
                if not sentPetWebhook then
                    sendWebhook("🎯 Found Target Pet!", "@everyone\n" .. player.Name .. " đã tìm thấy pet: **" .. target .. "**", 0x00FF00)
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
            local desc = "Không tìm thấy pet `" .. target .. "`.\nĐang rejoin game..."
            sendWebhook("❌ Pet Not Found & Rejoining", desc, 0xFF0000)
            notify("🔁 Rejoining", "Không tìm thấy pet. Đang rejoin...")
            sentNotFoundWebhook = true
            wait(3)
            player:Kick("Don't have your target pet\\Rejoin")
            task.wait(1)
            TeleportService:Teleport(game.PlaceId, player)
        end
    end
end
