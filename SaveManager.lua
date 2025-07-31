local httpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local SaveManager = {} do
	SaveManager.Folder = "DuckXHub"
	SaveManager.Ignore = {}
	SaveManager.AutoSave = true
	SaveManager.ResetCooldown = false

	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object)
				return { type = "Toggle", idx = idx, value = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Slider = {
			Save = function(idx, object)
				return { type = "Slider", idx = idx, value = tostring(object.Value) }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Dropdown = {
			Save = function(idx, object)
				return { type = "Dropdown", idx = idx, value = object.Value, multi = object.Multi }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Colorpicker = {
			Save = function(idx, object)
				return {
					type = "Colorpicker",
					idx = idx,
					value = object.Value:ToHex(),
					transparency = object.Transparency
				}
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
				end
			end,
		},
		Keybind = {
			Save = function(idx, object)
				return { type = "Keybind", idx = idx, mode = object.Mode, key = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.key, data.mode)
				end
			end,
		},
		Input = {
			Save = function(idx, object)
				return { type = "Input", idx = idx, text = object.Value }
			end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then
					SaveManager.Options[idx]:SetValue(data.text)
				end
			end,
		},
	}

	function SaveManager:SetIgnoreIndexes(list)
		for _, key in next, list do
			self.Ignore[key] = true
		end
	end

	function SaveManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
	end

	function SaveManager:Save(name)
		local fullPath = self.Folder .. "/settings/" .. name .. ".json"
		local data = { objects = {} }

		for idx, option in pairs(self.Options) do
			if not self.Parser[option.Type] then continue end
			if self.Ignore[idx] then continue end
			table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
		end

		local success, encoded = pcall(httpService.JSONEncode, httpService, data)
		if success then
			writefile(fullPath, encoded)
			return true
		end
		return false
	end

	function SaveManager:Load(name)
		local file = self.Folder .. "/settings/" .. name .. ".json"
		if not isfile(file) then return false end

		local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
		if not success then return false end

		for _, option in pairs(decoded.objects) do
			if self.Parser[option.type] then
				task.spawn(function()
					self.Parser[option.type].Load(option.idx, option)
				end)
			end
		end

		return true
	end

	function SaveManager:BuildFolderTree()
		for _, path in ipairs({ self.Folder, self.Folder .. "/settings" }) do
			if not isfolder(path) then
				makefolder(path)
			end
		end
	end

	function SaveManager:HookAutoSave(configName)
		for idx, option in pairs(self.Options) do
			if self.Ignore[idx] then continue end
			if typeof(option) ~= "table" or typeof(option.SetValue) ~= "function" then continue end

			local originalSet = option.SetValue
			option.SetValue = function(this, ...)
				originalSet(this, ...)
				if self.AutoSave and not self.ResetCooldown then
					self:Save(configName)
				end
			end

			if typeof(option.SetValueRGB) == "function" then
				local originalRGB = option.SetValueRGB
				option.SetValueRGB = function(this, ...)
					originalRGB(this, ...)
					if self.AutoSave and not self.ResetCooldown then
						self:Save(configName)
					end
				end
			end
		end
	end

	function SaveManager:StartAutoSaveTimer(interval, configName)
		interval = interval or 3
		task.spawn(function()
			while true do
				task.wait(interval)
				if self.AutoSave and not self.ResetCooldown then
					self:Save(configName)
				end
			end
		end)
	end

	function SaveManager:AutoSetup()
		local playerId = tostring(Players.LocalPlayer.UserId)
		local configFile = self.Folder .. "/settings/" .. playerId .. ".json"

		if not isfile(configFile) then
			self:Save(playerId)
		end

		self:Load(playerId)
		self:HookAutoSave(playerId)
		self:StartAutoSaveTimer(3, playerId)
	end

	function SaveManager:SetLibrary(library)
		self.Library = library
		self.Options = library.Options
	end

	function SaveManager:DeleteConfig(name)
		if not name or tostring(name):gsub(" ", "") == "" then
			self.Library:Notify({
				Title = "Config",
				Content = "No config selected to delete.",
				Duration = 7
			})
			return
		end

		local file = self.Folder .. "/settings/" .. name .. ".json"
		if isfile(file) then
			delfile(file)
			self.Library:Notify({
				Title = "Config",
				Content = "Deleted config: " .. name,
				Duration = 7
			})

			-- Delay AutoSave to prevent re-saving deleted file
			self.ResetCooldown = true
			task.delay(15, function()
				self.ResetCooldown = false
			end)
		else
			self.Library:Notify({
				Title = "Config",
				Content = "Config file not found: " .. name,
				Duration = 7
			})
		end
	end

	function SaveManager:BuildConfigSection(tab)
		assert(self.Library, "SaveManager: Library not set.")
		local section = tab:AddSection("Config")
		local playerId = tostring(Players.LocalPlayer.UserId)

		section:AddButton({
			Title = "Copy config",
			Callback = function()
				local newName = "Copy_" .. os.time()
				local src = self.Folder .. "/settings/" .. playerId .. ".json"
				local dest = self.Folder .. "/settings/" .. newName .. ".json"
				if isfile(src) then
					writefile(dest, readfile(src))
					self.Library:Notify({
						Title = "Config",
						Content = "Copied config: " .. newName,
						Duration = 6
					})
				end
			end
		})

		section:AddButton({
			Title = "Reset config",
			Callback = function()
				self:DeleteConfig(playerId)
			end
		})

		self:SetIgnoreIndexes({})
	end

	SaveManager:BuildFolderTree()
end

return SaveManager
