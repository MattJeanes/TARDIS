--Legacy Interior - Throttle

local PART = {}
PART.ID = "legacy_throttle"
PART.Name = "Legacy Throttle"
PART.Model = "models/drmatt/tardis/throttle.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

if SERVER then
    function PART:Use(ply)
        if self.exterior:GetData("teleport",false)==false or self.exterior:GetData("vortex",false)==false then
            self.exterior:Demat()
        end 
        
        if self.exterior:GetData("teleport")==true or self.exterior:GetData("vortex")==true then
            self.exterior:Mat()
        end
        self:EmitSound("tardis/control_throttle.wav")
    end
end
        

TARDIS:AddPart(PART)