-- Legacy Interior - Cloaking Blacksticks

local PART = {}
PART.ID = "legacy_blacksticks"
PART.Name = "Legacy Cloaking Blacksticks"
PART.Model = "models/drmatt/tardis/blacksticks.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.BypassIsomorphic = false

function PART:Use(ply)
    local result = self.exterior:ToggleCloak() || false
    ply:ChatPrint("Cloaking " .. (result and "engaged" || "disengaged"))
end

TARDIS:AddPart(PART)
