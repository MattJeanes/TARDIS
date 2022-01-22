-- Default Interior - Door frame

local PART = {}
PART.ID = "default_doorframe"
PART.Name = "Default Door Frame"
PART.Model = "models/drmatt/tardis/door.mdl"
PART.BypassIsomorphic = true
PART.AutoSetup = true
PART.Collision = false
PART.CollisionUse = false
PART.Animate = true

TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_doorframe_bottom"
PART.Name = "Default Door Frame Bottom"
PART.Model = "models/hunter/blocks/cube025x1x025.mdl"
PART.BypassIsomorphic = true
PART.AutoSetup = true
PART.Collision = false
PART.CollisionUse = false
PART.Animate = true

function PART:Initialize()
	self:SetMaterial("models/drmatt/tardis/tardisfloor")
end

TARDIS:AddPart(PART)

PART.ID = "default_doorframe_bottom2" -- make a copy
TARDIS:AddPart(PART)
