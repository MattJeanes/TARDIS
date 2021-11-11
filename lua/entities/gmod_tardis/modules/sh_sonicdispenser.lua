
function TARDIS:IsSonicInstalled()
	if SonicSD and file.Exists("autorun/sonicsd.lua", "LUA") then
		return true
	end
	return false
end

TARDIS:AddControl({
	id = "sonic_dispenser",
	int_func=function(self,ply)
		if TARDIS:IsSonicInstalled() then
			if ply:GetWeapon("swep_sonicsd") == NULL then
				ply:Give("swep_sonicsd")
			end
			TARDIS:Message(ply, "Sonic Screwdriver has been dispensed.")
			ply:SelectWeapon("swep_sonicsd")
		else
			TARDIS:ErrorMessage(ply, "You do not have Sonic Screwdriver addon installed. Install it for this part to work.")
		end
	end,
	serveronly = true,
	screen_button = false,
	tip_text = "Sonic Charger",
})