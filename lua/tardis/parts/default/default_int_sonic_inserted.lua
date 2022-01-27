-- Default Interior - Sonic charger

local PART = {}
PART.ID = "default_sonic_inserted"
PART.Name = "Default Sonic Screwdriver in the charger"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Model = "models/weapons/c_sonicsd.mdl"

if CLIENT then
	function PART:Think()
		local weapon = LocalPlayer():GetActiveWeapon()
		if IsValid(weapon) and weapon:GetClass() == "swep_sonicsd" then
			self:SetColor(Color(0,0,0,0))
		else
			self:SetColor(Color(255,255,255,255))
		end
	end
end

TARDIS:AddPart(PART)