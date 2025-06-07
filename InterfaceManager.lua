local httpService = game:GetService("HttpService")

local InterfaceManager = {} do
	InterfaceManager.Folder = "DuckXHub"
    InterfaceManager.Settings = {
        Theme = "Darker"
    }

    function InterfaceManager:SetFolder(folder)
		self.Folder = folder
		self:BuildFolderTree()
	end

    function InterfaceManager:SetLibrary(library)
		self.Library = library
        -- Cố định phím mở menu là LeftControl
        self.Library.MinimizeKeybind = { Value = "LeftControl" }
	end

    function InterfaceManager:BuildFolderTree()
		local paths = {}
		local parts = self.Folder:split("/")
		for idx = 1, #parts do
			paths[#paths + 1] = table.concat(parts, "/", 1, idx)
		end
		table.insert(paths, self.Folder)
		table.insert(paths, self.Folder .. "/settings")
		for _, path in ipairs(paths) do
			if not isfolder(path) then
				makefolder(path)
			end
		end
	end

    function InterfaceManager:SaveSettings()
        writefile(self.Folder .. "/options.json", httpService:JSONEncode(self.Settings))
    end

    function InterfaceManager:LoadSettings()
        local path = self.Folder .. "/options.json"
        if isfile(path) then
            local data = readfile(path)
            local success, decoded = pcall(httpService.JSONDecode, httpService, data)
            if success then
                for k, v in pairs(decoded) do
                    self.Settings[k] = v
                end
            end
        end
    end

    function InterfaceManager:BuildInterfaceSection(tab)
        assert(self.Library, "Must call SetLibrary first")
        local Library = self.Library
        local Settings = self.Settings

        self:LoadSettings()

        local section = tab:AddSection("Interface")

        local InterfaceTheme = section:AddDropdown("InterfaceTheme", {
            Title = "Theme",
            Description = "Changes the interface theme.",
            Values = Library.Themes,
            Default = Settings.Theme,
            Callback = function(Value)
                Library:SetTheme(Value)
                Settings.Theme = Value
                self:SaveSettings()
            end
        })

        InterfaceTheme:SetValue(Settings.Theme)
    end
end

return InterfaceManager
