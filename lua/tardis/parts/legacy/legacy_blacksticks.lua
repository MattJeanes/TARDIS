-- Legacy Interior - Cloaking Blacksticks

local PART = {}
PART.ID = "legacy_blacksticks"
PART.Name = "Legacy Cloaking Blacksticks"
PART.Model = "models/drmatt/tardis/blacksticks.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

function PART:Use(ply)
    local result = self.exterior:ToggleCloak() or false
    ply:ChatPrint("Cloaking " .. (result and "engaged" or "disengaged"))
end

TARDIS:AddPart(PART)
