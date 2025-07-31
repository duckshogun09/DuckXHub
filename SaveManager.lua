local httpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local SaveManager = {} do
	SaveManager.Folder = "DuckXHub"
	SaveManager.Ignore = {}
	SaveManager.AutoSave = true

	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object) return { type = "Toggle", idx = idx, value = object.Value } end,
			Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
		},
		Slider = {
			Save = function(idx, object) return { type = "Slider", idx = idx, value = tostring(object.Value) } end,
			Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
		},
		Dropdown = {
			Save = function(idx, object) return { type = "Dropdown", idx = idx, value = object.Value, multi = object.Multi } end,
			Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.value) end end,
		},
		Colorpicker = {
			Save = function(idx, object) return { type = "Colorpicker", idx = idx, value = object.Value:ToHex(), transparency = object.Transparency } end,
			Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValueRGB(Color3.fromHex(data.value), data.transparency) end end,
		},
		Keybind = {
			Save = function(idx, object) return { type = "Keybind", idx = idx, mode = object.Mode, key = object.Value } end,
			Load = function(idx, data) if SaveManager.Options[idx] then SaveManager.Options[idx]:SetValue(data.key, data.mode) end end,
		},
		Input = {
			Save = function(idx, object) return { type = "Input", idx = idx, text = object.Value } end,
			Load = function(idx, data) if SaveManager.Options[idx] and type(data.text) == "string" then SaveManager.Options[idx]:SetValue(data.text) end end,
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

		for idx, option in next, SaveManager.Options do
			if not self.Parser[option.Type] or self.Ignore[idx] then continue end
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

		for _, option in next, decoded.objects do
			if self.Parser[option.type] then
				task.spawn(function() self.Parser[option.type].Load(option.idx, option) end)
			end
		end

		return true
	end

	function SaveManager:BuildFolderTree()
		for _, path in ipairs({ self.Folder, self.Folder .. "/settings" }) do
			if not isfolder(path) then makefolder(path) end
		end
	end

	function SaveManager:HookAutoSave(configName)
		for idx, option in pairs(self.Options) do
			if self.Ignore[idx] then continue end
			if typeof(option) ~= "table" or typeof(option.SetValue) ~= "function" then continue end

			local originalSet = option.SetValue
			option.SetValue = function(this, ...)
				originalSet(this, ...)
				if SaveManager.AutoSave then
					SaveManager:Save(configName)
				end
			end

			if typeof(option.SetValueRGB) == "function" then
				local originalRGB = option.SetValueRGB
				option.SetValueRGB = function(this, ...)
					originalRGB(this, ...)
					if SaveManager.AutoSave then
						SaveManager:Save(configName)
					end
				end
			end
		end
	end

	function SaveManager:AutoSetup()
		local playerId = tostring(Players.LocalPlayer.UserId)
		local filePath = self.Folder .. "/settings/" .. playerId .. ".json"

		if not isfile(filePath) then
			self:Save(playerId)
		end

		self:Load(playerId)
		self:HookAutoSave(playerId)
	end

	function SaveManager:SetLibrary(library)
		self.Library = library
		self.Options = library.Options
	end

	function SaveManager:BuildConfigSection(tab)
		assert(self.Library, "Library not set for SaveManager")
		local section = tab:AddSection("Auto Config")

		local playerId = tostring(Players.LocalPlayer.UserId)

		section:AddButton({
			Title = "Copy config",
			Description = "Sao chép config hiện tại thành bản mới",
			Callback = function()
				local newName = "Copy_" .. os.time()
				local sourcePath = self.Folder .. "/settings/" .. playerId .. ".json"
				local destPath = self.Folder .. "/settings/" .. newName .. ".json"

				if isfile(sourcePath) then
					writefile(destPath, readfile(sourcePath))
					self.Library:Notify({
						Title = "Config",
						Content = "Đã tạo bản sao: " .. newName,
						Duration = 6
					})
				end
			end
		})

		section:AddButton({
			Title = "Reset config",
			Description = "Xóa config người dùng và reset lại mặc định",
			Callback = function()
				local file = self.Folder .. "/settings/" .. playerId .. ".json"
				if isfile(file) then
					delfile(file)
					self.Library:Notify({
						Title = "Config",
						Content = "Đã reset config!",
						Duration = 6
					})
				end
				for _, option in pairs(self.Options) do
					pcall(function()
						if option.Default then
							option:SetValue(option.Default)
						end
					end)
				end
			end
		})

		self:SetIgnoreIndexes({})
	end

	SaveManager:BuildFolderTree()
end

return SaveManager
