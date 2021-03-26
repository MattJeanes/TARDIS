-- Default Interior - Atom Accelerator

local PART = {}
PART.ID = "default_atomaccel"
PART.Name = "Default Atom Accelerator"
PART.Text = "Atom Accelerator"
PART.Model = "models/drmatt/tardis/atomaccel.mdl"
PART.AutoSetup = true
PART.Collision = true

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
        TARDIS:Message(ply, "Spin direction set to "..dir)
	end
end

TARDIS:AddPart(PART)
