-- Placeholder cloak module (currently only for E2 and control presets, feel free to delete later)

ENT:AddHook("HandleE2", "cloak", function(self,name,e2)
	if name == "Phase" and TARDIS:CheckPP(e2.player, self) then
		return 0
	elseif name == "GetVisible" then
		return 0
	end
end)

-- We add this earlier so that extension creators could add them
TARDIS:AddControl({
	id = "cloak",
	ext_func=function(self,ply)
		-- Code will be added here

		-- Just a temporary joke
		TARDIS:ErrorMessage(ply, "Cloaking is not yet implemented")
	end,
	serveronly=true,
	screen_button = {
		virt_console = false, -- change to true to add
		mmenu = false,
		toggle = true,
		frame_type = {0, 2},
		text = "Cloaking",
		pressed_state_from_interior = false,
		pressed_state_data = "cloak", -- can be changed
		order = 12,
	},
	tip_text = "Cloaking Device",
})
