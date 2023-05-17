-- Default Interior - Throttle

local PART = {}
PART.ID = "default_throttle"
PART.Name = "Default Throttle"
PART.Model = "models/drmatt/tardis/throttle.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "drmatt/tardis/default/control_throttle.wav"

if SERVER then
    function PART:Use(ply)
        if self.Control ~= "teleport_double" then
            TARDIS:Control(self.Control, ply, self)
        end

        if self.exterior:GetData("teleport") == true or self.exterior:GetData("vortex") == true
            or not self.interior:GetSequencesEnabled()
        then
            TARDIS:Control("teleport_double", ply, self)
        else
            TARDIS:ErrorMessage(ply, "Common.ControlSequencesEnabledWarning")
        end
    end
end

TARDIS:AddPart(PART)
