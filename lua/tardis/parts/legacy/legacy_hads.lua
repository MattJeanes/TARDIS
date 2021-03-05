-- Legacy Interior - HADS Switch

local PART = {}
PART.ID = "legacy_hads"
PART.Name = "Legacy HADS Switch"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "tardis/control_handbrake.wav"
PART.BypassIsomorphic = false

if SERVER then
	function PART:Use(ply)
		self.exterior:ToggleHADS()
		local on = self.exterior:GetData("hads",false)
		ply:ChatPrint("HADS is now "..(on and "on" or "off"))
	end
end

TARDIS:AddPart(PART)
