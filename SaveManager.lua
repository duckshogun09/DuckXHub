local httpService = game:GetService("HttpService")

local DEFAULT_ORIG_CONFIG_PATH = "DuckXHub/settings/original_config_gag.json"
local DEFAULT_ORIG_CONFIG = [[{"objects":[{"idx":"SelectPetsMulti","type":"Dropdown","mutli":true,"value":[]},{"idx":"AutoCollectPollinatedPlants","type":"Toggle","value":false},{"idx":"SeedShopMultiSelect","type":"Dropdown","mutli":true,"value":[]},{"idx":"MerchantItemsMultiSelect","type":"Dropdown","mutli":true,"value":[]},{"idx":"AutoPlantToggle","type":"Toggle","value":false},{"idx":"InterfaceTheme","type":"Dropdown","value":"Darker"},{"idx":"AutoPlaceEggToggle","type":"Toggle","value":false},{"idx":"GearShopMultiSelect","type":"Dropdown","mutli":true,"value":[]},{"idx":"AutoHarvestSelected","type":"Toggle","value":false},{"idx":"MinKGInput","type":"Input","text":""},{"idx":"BoostFPS","type":"Toggle","value":false},{"idx":"AutoBuyGearShop","type":"Toggle","value":false},{"idx":"EggMultiSelect","type":"Dropdown","mutli":true,"value":[]},{"idx":"BlackScreen","type":"Toggle","value":false},{"idx":"SelectMutation","type":"Dropdown","mutli":true,"value":[]},{"idx":"WebhookWhitelistPets","type":"Dropdown","mutli":true,"value":[]},{"idx":"AutoSubmitPollinatedPlants","type":"Toggle","value":false},{"idx":"SelectCropsMulti","type":"Dropdown","mutli":true,"value":[]},{"idx":"TargetVersionInput","type":"Input","text":""},{"idx":"AutoBuySelectedEggs","type":"Toggle","value":false},{"idx":"PetNameMultiSelect2","type":"Dropdown","mutli":true,"value":[]},{"idx":"AutoHopVersionToggle","type":"Toggle","value":false},{"idx":"AutoPetMutation","type":"Toggle","value":false},{"idx":"MinAgeInput","type":"Input","text":""},{"idx":"JobIdInput","type":"Input","text":""},{"idx":"SelectHarvestPlants","type":"Dropdown","mutli":true,"value":[]},{"idx":"WebhookURLInput","type":"Input","text":""},{"idx":"AutoHatchEggToggle","type":"Toggle","value":false},{"idx":"AutoAntiAFK","type":"Toggle","value":true},{"idx":"AutoSellLowerKGPet","type":"Toggle","value":false},{"idx":"AutoBuyMerchant","type":"Toggle","value":false},{"idx":"PetWebhookToggle","type":"Toggle","value":false},{"idx":"SelectEggsMulti","type":"Dropdown","mutli":true,"value":[]},{"idx":"AutoBuySeedShop","type":"Toggle","value":false},{"idx":"PlantPositionMode","type":"Dropdown","value":"Random"}]}]]

local SaveManager = {} do
	SaveManager.Folder = "DuckXHub"
	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object) return { type = "Toggle", idx = idx, value = object.Value } end,
			Load = function(idx, data)
				if SaveManager.Options and SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Slider = {
			Save = function(idx, object) return { type = "Slider", idx = idx, value = tostring(object.Value) } end,
			Load = function(idx, data)
				if SaveManager.Options and SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Dropdown = {
			Save = function(idx, object) return { type = "Dropdown", idx = idx, value = object.Value, mutli = object.Multi } end,
			Load = function(idx, data)
				if SaveManager.Options and SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Colorpicker = {
			Save = function(idx, object) return { type = "Colorpicker", idx = idx, value = object.Value:ToHex(), transparency = object.Transparency } end,
			Load = function(idx, data)
				if SaveManager.Options and SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
				end
			end,
		},
		Keybind = {
			Save = function(idx, object) return { type = "Keybind", idx = idx, mode = object.Mode, key = object.Value } end,
			Load = function(idx, data)
				if SaveManager.Options and SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValue(data.key, data.mode)
				end
			end,
		},
		Input = {
			Save = function(idx, object) return { type = "Input", idx = idx, text = object.Value } end,
			Load = function(idx, data)
				if SaveManager.Options and SaveManager.Options[idx] and type(data.text) == "string" then
					SaveManager.Options[idx]:SetValue(data.text)
				end
			end,
		},
	}

	SaveManager._originalConfigs = {}

	function SaveManager:SetLibrary(library)
		self.Library = library
		self.Options = library.Options
	end

	function SaveManager:BuildFolderTree()
		local paths = {
			self.Folder,
			self.Folder .. "/settings"
		}
		for _, str in ipairs(paths) do
			if not isfolder(str) then makefolder(str) end
		end
		if not isfile(DEFAULT_ORIG_CONFIG_PATH) then
			writefile(DEFAULT_ORIG_CONFIG_PATH, DEFAULT_ORIG_CONFIG)
		end
	end

	function SaveManager:Save(name, isInitial)
		if not name then return false, "no config file is selected" end
		if not self.Options then return false, "Options not available" end
		local fullPath = self.Folder .. "/settings/" .. name .. ".json"
		local data = { objects = {} }
		for idx, option in next, self.Options or {} do
			if not self.Parser[option.Type] then continue end
			table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
		end
		local success, encoded = pcall(httpService.JSONEncode, httpService, data)
		if not success then return false, "failed to encode data" end
		writefile(fullPath, encoded)
		if isInitial then
			self._originalConfigs[name] = encoded
		end
		return true
	end

	function SaveManager:Load(name)
		if not name then return false, "no config file is selected" end
		if not self.Options then return false, "Options not available" end
		local file = self.Folder .. "/settings/" .. name .. ".json"
		if not isfile(file) then return false, "invalid file" end
		local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
		if not success then return false, "decode error" end
		for _, option in next, (decoded and decoded.objects) or {} do
			if self.Parser[option.type] then
				self.Parser[option.type].Load(option.idx, option)
				task.wait(0.01)
			end
		end
		return true
	end

	function SaveManager:AutoInitPlayerConfig(playerId)
		if not self.Library or not self.Options or not playerId then
			warn("[SaveManager] Not ready to auto init player config.")
			return
		end
		local configName = tostring(playerId) .. "-GAG"
		local file = self.Folder .. "/settings/" .. configName .. ".json"
		if not isfile(file) then
			local ok, err = self:Save(configName, true)
			if ok then
				self.Library:Notify({
					Title = "Config",
					Content = string.format("Created new config file for ID: %s", configName),
					Duration = 7
				})
			else
				self.Library:Notify({
					Title = "Config",
					Content = "Error creating config file for the first time: " .. tostring(err),
					Duration = 7
				})
			end
		end
		self:Load(configName)
		self._autoConfigName = configName
		spawn(function()
			while true do
				wait(5)
				self:Save(configName)
			end
		end)
	end

	function SaveManager:ResetConfig()
		local name = self._autoConfigName
		if not name then return end
		local file = self.Folder .. "/settings/" .. name .. ".json"
		local origData = nil
		if isfile(DEFAULT_ORIG_CONFIG_PATH) then
			origData = readfile(DEFAULT_ORIG_CONFIG_PATH)
		else
			origData = DEFAULT_ORIG_CONFIG
			writefile(DEFAULT_ORIG_CONFIG_PATH, origData)
		end

		if not origData then
			self.Library:Notify({
				Title = "Config",
				Content = "No original data found to reset.",
				Duration = 7
			})
			return
		end
		writefile(file, origData)
		self:Load(name)
		self.Library:Notify({
			Title = "Config",
			Content = string.format("Reset config ID %q to default.", name),
			Duration = 7
		})
	end

	function SaveManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
	end

	function SaveManager:BuildConfigSection(tab, playerId)
		assert(self.Library, "Must set SaveManager.Library")
		assert(playerId, "Must provide playerId")
		local section = tab:AddSection("Configuration")
		section:AddButton({Title = "Reset config", Callback = function() self:ResetConfig() end})
		self:AutoInitPlayerConfig(playerId)
	end

	SaveManager:BuildFolderTree()
end

return SaveManager
