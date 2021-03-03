-- Legacy Interior - Atom Accelerator

local PART = {}
PART.ID = "legacy_atomaccel"
PART.Name = "Legacy Atom Accelerator"
PART.Model = "models/drmatt/tardis/atomaccel.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.BypassIsomorphic = false

if SERVER then
	function PART:Use(ply)
		local dir
		if self.exterior.spindir==-1 then
			self.exterior.spindir=0
			dir="none"
		elseif self.exterior.spindir==0 then
			self.exterior.spindir=1
			dir="clockwise"
		elseif self.exterior.spindir==1 then
			self.exterior.spindir=-1
			dir="anti-clockwise"
		end
		ply:ChatPrint("Spin direction set to "..dir)
	end
end

TARDIS:AddPart(PART)
