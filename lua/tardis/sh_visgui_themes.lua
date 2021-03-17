TARDIS.visgui_themes={}

local theme_basefolder = "materials/vgui/tardis-themes/"

local function CheckGUITheme(theme)
	return true
end

function TARDIS:RemoveGUITheme(id)
	if self.visgui_themes[id] then
		self.visgui_themes[id] = nil
	end
end

function TARDIS:AddGUITheme(theme)
	if CheckGUITheme(theme) then
		TARDIS:RemoveGUITheme(theme.id)
		self.visgui_themes[theme.id] = table.Copy(theme)
		if theme.folder ~= nil then
			self.visgui_themes[theme.id].folder = theme_basefolder .. theme.folder .. "/"
		end
	end
end

TARDIS:LoadFolder("themes/visgui", nil, true)

function TARDIS:GetGUIThemes()
	return self.visgui_themes
end

function TARDIS:GetGUITheme(id)
	if self.visgui_themes[id] then
		return self.visgui_themes[id]
	end
end

function TARDIS:GetGUIThemeElement(theme_id, section, element, no_defaults)
	if element == nil then
		return TARDIS:GetGUIThemeElement(theme_id, section, "default")
	end
	local theme = self.visgui_themes[theme_id]
	if theme == nil then
		error("Attempt to access non-existing theme "..theme_id)
		return nil
	end
	if theme[section] == nil then
		if theme.base_id ~= nil then
			return TARDIS:GetGUIThemeElement(theme.base_id, section, element, no_defaults)
		else
			return nil
		end
	end
	if theme[section][element] then
		if theme[section].subfolder ~= nil then
			return theme.folder..theme[section].subfolder.."/"..theme[section][element]
		end
		return theme.folder..theme[section][element]
	end
	if theme.base_id ~= nil then
		local inherited = TARDIS:GetGUIThemeElement(theme.base_id, section, element, true)
		if inherited then
			return inherited
		end
	end
	if not no_defaults then
		return TARDIS:GetGUIThemeElement(theme_id, section, "default", true)
	end
	return nil
end