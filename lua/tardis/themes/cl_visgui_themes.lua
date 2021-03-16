local visgui_themes={}

local theme_basefolder = "materials/vgui/tardis-themes/"

TARDIS:AddSetting({
	id="visgui_theme",
	name="VisGUI Theme",
	desc="Theme for new Visual GUI",
	value="default",
	networked=true
})

local function CheckGUITheme(theme)

end

function TARDIS:AddGUITheme(theme)
	visgui_themes[theme.id] = table.Copy(theme)
end

function TARDIS:RemoveGUITheme(id)
	visgui_themes[id]=nil
end

function TARDIS:GetGUIThemes()
	return visgui_themes
end

function TARDIS:GetGUITheme(id)
	if visgui_themes[id] then
		return visgui_themes[id]
	end
end

function TARDIS:GetGUIThemeElement(theme_id, section, element, no_defaults)
	if element == nil then
		return TARDIS:GetGUIThemeElement(theme_id, section, "default")
	end
	local theme = TARDIS:GetGUITheme(theme_id)
	if theme == nil then
		error("Attempt to access non-existing theme "..theme_id)
		return nil
	end
	if theme[section] == nil then
		if theme.base ~= nil then
			return TARDIS:GetGUIThemeElement(theme.base, section, element, no_defaults)
		else
			return nil
		end
	end
	if theme[section][element] then
		return "materials/vgui/tardis-themes/"..theme.folder..theme[section][element]
	end
	if theme.base ~= nil then
		local inherited = TARDIS:GetGUIThemeElement(theme.base, section, element, true)
		if inherited then
			return inherited
		end
	end
	if not no_defaults then
		return TARDIS:GetGUIThemeElement(theme, section, "default", true)
	end
	return nil
end