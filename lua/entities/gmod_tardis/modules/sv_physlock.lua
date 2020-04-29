--Physical Lock
if SERVER then
    function ENT:SetPhyslock(on)
        local phys = self:GetPhysicsObject()
        phys:EnableMotion(!on)
        phys:Wake()
        //self:GetCreator():ChatPrint("Physics lock set to ".. (on and "on" or "off"))
        return self:SetData("physlock", on, true)
    end

    function ENT:TogglePhyslock()
        local on = !self:GetData("physlock", false)
        //self:GetCreator():ChatPrint("Physics lock set to ".. (on and "on" or "off"))
        return self:SetPhyslock(on)
    end

    hook.Add("PlayerUnfrozeObject", "tardis-physlock", function(ply,ent,phys)
        if ent:GetClass()=="gmod_tardis" and ent:GetData("physlock",false)==true then 
            phys:EnableMotion(false) 
        end
    end)

    hook.Add("PhysgunDrop", "tardis-physlock", function(ply,ent)
        if ent:GetClass()=="gmod_tardis" and ent:GetData("physlock",false)==true then
            ent:GetPhysicsObject():EnableMotion(false)
        end
    end)
end