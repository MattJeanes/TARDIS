-- Default Interior - HADS Switch

local PART = {}
PART.ID = "default_hads"
PART.Name = "Default HADS Switch"
PART.Control = "hads"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "drmatt/tardis/default/control_handbrake.wav"

if SERVER then
	function PART:Use(ply)
		self.exterior:ToggleHADS()
		local on = self.exterior:GetData("hads",false)
		ply:ChatPrint("HADS is now "..(on and "on" or "off"))
	end
end

TARDIS:AddPart(PART)
