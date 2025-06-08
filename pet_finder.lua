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

local function sendWebhook(title, description, color)
    if not webhook or webhook == "" then return end
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

local function serverHop()
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)

    if success and result and result.data then
        for _, v in ipairs(result.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, Players.LocalPlayer)
                return
            end
        end
    end

    -- fallback nếu không tìm được server khác
    TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
end

while true do wait()
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
            sendWebhook("❌ Pet Not Found & Rejoining", "Không tìm thấy pet `" .. target .. "`.\nĐang rejoin game...", 0xFF0000)
            notify("🔁 Rejoining", "Không tìm thấy pet. Đang rejoin...")
            sentNotFoundWebhook = true

            task.wait(3)
            player:Kick("Don't have your target pet\\Rejoin")
            task.wait(3)
            serverHop()
        end
    end
end
