-- Default Interior - Atom Accelerator

local PART = {}
PART.ID = "default_atomaccel"
PART.Name = "Default Atom Accelerator"
PART.Text = "Parts.DefaultAtomAccelerator.Text"
PART.Model = "models/drmatt/tardis/atomaccel.mdl"
PART.AutoSetup = true
PART.Collision = true

if CLIENT then
    function PART:Think()
        if not self:GetData("flight") then return end
        local spindir = self.exterior:GetSpinDir()
        if spindir == 0 then return end
        local pos = self:GetPoseParameter("switch")
        local target
        if spindir == 1 then
            target = 0
            if pos == 0 then
                pos = 1
            end
        else
            target = 1
            if pos == 1 then
                pos = 0
            end
        end
        self:SetPoseParameter("switch", math.Approach( pos, target, FrameTime() * 1 ))
        self:InvalidateBoneCache()
    end
end

TARDIS:AddPart(PART)
