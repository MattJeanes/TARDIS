-- Legacy Interior - Wibbly Lever

local PART = {}
PART.ID = "legacy_wibblylever"
PART.Name = "Legacy Wibbly lever"
PART.Model = "models/drmatt/tardis/wibblylever.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
    function PART:Use(ply)
        self.exterior:ToggleLocked()
    end
end

TARDIS:AddPart(PART)
