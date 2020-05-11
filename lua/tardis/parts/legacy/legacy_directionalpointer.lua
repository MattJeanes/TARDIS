-- Legacy Interior - Directional Pointer

local PART = {}
PART.ID = "legacy_directionalpointer"
PART.Name = "Legacy Directional Pointer"
PART.Model = "models/drmatt/tardis/directionalpointer.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

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
