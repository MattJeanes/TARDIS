-- Legacy Interior - Unused Pull Handle

local PART = {}
PART.ID = "legacy_unused"
PART.Name = "Legacy Unused Pull Handle"
PART.Model = "models/drmatt/tardis/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
    function PART:Use(ply)
        self:EmitSound("tardis/control_handbrake.wav")
        local on = not self.interior:GetData("legacy-advanced",false)
        self.interior:SetData("legacy-advanced", on)
        ply:ChatPrint("Advanced mode is now "..tostring(on))
    end
end
        

TARDIS:AddPart(PART)
