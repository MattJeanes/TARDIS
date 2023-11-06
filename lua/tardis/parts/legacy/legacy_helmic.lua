-- Default Interior - Helmic Regulator

local PART = {}
PART.ID = "legacy_helmic"
PART.Name = "Default Helmic Regulator"
PART.Text = "Parts.DefaultHelmic.Text"
PART.Model = "models/drmatt/tardis/helmicregulator.mdl"
PART.AutoSetup = true
PART.Collision = true

if CLIENT then
    function PART:Think()
        local pos = self:GetPoseParameter("switch")
        if pos == 1 then
            pos = 0
        end
        self:SetPoseParameter("switch", math.Approach( pos, 1, FrameTime() * 1 ))
        self:InvalidateBoneCache()
    end
end

TARDIS:AddPart(PART)
