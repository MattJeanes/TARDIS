
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
			local currentWeapon = ply:GetActiveWeapon()
			if IsValid(currentWeapon) and currentWeapon:GetClass() == "swep_sonicsd" then
				TARDIS:ErrorMessage(ply, "You are already holding a Sonic Screwdriver.")
				return
			end
			if IsValid(ply:GetWeapon("swep_sonicsd")) then
				TARDIS:Message(ply, "Sonic Screwdriver has been equipped.")
			else
				ply:Give("swep_sonicsd")
				TARDIS:Message(ply, "Sonic Screwdriver has been dispensed.")
			end
			ply:SelectWeapon("swep_sonicsd")
		else
			TARDIS:ErrorMessage(ply, "You do not have the Sonic Screwdriver addon installed. Install it for this part to work.")
		end
	end,
	power_independent = true,
	serveronly = true,
	screen_button = false,
	tip_text = "Sonic Charger",
})