local httpService = game:GetService("HttpService")

local SaveManager = {} do
	SaveManager.Folder = "DuckXHub"
	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object) return { type = "Toggle", idx = idx, value = object.Value } end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Slider = {
			Save = function(idx, object) return { type = "Slider", idx = idx, value = tostring(object.Value) } end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Dropdown = {
			Save = function(idx, object) return { type = "Dropdown", idx = idx, value = object.Value, mutli = object.Multi } end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValue(data.value)
				end
			end,
		},
		Colorpicker = {
			Save = function(idx, object) return { type = "Colorpicker", idx = idx, value = object.Value:ToHex(), transparency = object.Transparency } end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency)
				end
			end,
		},
		Keybind = {
			Save = function(idx, object) return { type = "Keybind", idx = idx, mode = object.Mode, key = object.Value } end,
			Load = function(idx, data)
				if SaveManager.Options[idx] then 
					SaveManager.Options[idx]:SetValue(data.key, data.mode)
				end
			end,
		},
		Input = {
			Save = function(idx, object) return { type = "Input", idx = idx, text = object.Value } end,
			Load = function(idx, data)
				if SaveManager.Options[idx] and type(data.text) == "string" then
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
	end

	function SaveManager:Save(name, isInitial)
		if not name then return false, "no config file is selected" end
		local fullPath = self.Folder .. "/settings/" .. name .. ".json"
		local data = { objects = {} }
		for idx, option in next, SaveManager.Options or {} do
			if not self.Parser[option.Type] then continue end
			table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
		end
		local success, encoded = pcall(httpService.JSONEncode, httpService, data)
		if not success then return false, "failed to encode data" end
		writefile(fullPath, encoded)
		if isInitial then
			self._originalConfigs[name] = encoded
			writefile(fullPath .. ".orig", encoded)
		end
		return true
	end

	function SaveManager:Load(name)
		if not name then return false, "no config file is selected" end
		local file = self.Folder .. "/settings/" .. name .. ".json"
		if not isfile(file) then return false, "invalid file" end
		local success, decoded = pcall(httpService.JSONDecode, httpService, readfile(file))
		if not success then return false, "decode error" end
		for _, option in next, (decoded and decoded.objects) or {} do
			if self.Parser[option.type] then
				task.spawn(function() self.Parser[option.type].Load(option.idx, option) end)
			end
		end
		return true
	end

	function SaveManager:AutoInitPlayerConfig(playerId)
		local configName = tostring(playerId) .. "-GAG"
		local file = self.Folder .. "/settings/" .. configName .. ".json"
		if not isfile(file) then
			local ok, err = self:Save(configName, true)
			if ok then
				self.Library:Notify({
					Title = "Config",
					Content = string.format("Đã tạo file config mới cho ID: %s", configName),
					Duration = 7
				})
			else
				self.Library:Notify({
					Title = "Config",
					Content = "Lỗi tạo file config lần đầu: " .. tostring(err),
					Duration = 7
				})
			end
		end
		self:Load(configName)
		self._autoConfigName = configName
		-- Auto overwrite loop
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
		local origData = self._originalConfigs[name] or (isfile(file .. ".orig") and readfile(file .. ".orig") or nil)
		if not origData then
			self.Library:Notify({
				Title = "Config",
				Content = "Không tìm thấy dữ liệu gốc để reset.",
				Duration = 7
			})
			return
		end
		writefile(file, origData)
		self:Load(name)
		self.Library:Notify({
			Title = "Config",
			Content = string.format("Đã reset config ID %q về mặc định.", name),
			Duration = 7
		})
	end

	function SaveManager:BuildConfigSection(tab, playerId)
		assert(self.Library, "Must set SaveManager.Library")
		local section = tab:AddSection("Configuration")
		section:AddButton({Title = "Reset config", Callback = function() self:ResetConfig() end})
		-- Tự động luôn cho player
		self:AutoInitPlayerConfig(playerId)
	end

	SaveManager:BuildFolderTree()
end

return SaveManager
