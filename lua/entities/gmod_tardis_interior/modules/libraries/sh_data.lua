-- Data

if SERVER then
    function ENT:SendData(ply)
        self.exterior:SendData(ply)
    end

    hook.Add("PlayerInitialSpawn", "TARDISI-Data", function(ply)
        for k,v in pairs(ents.FindByClass("gmod_tardis_interior")) do
            v:SendData(ply)
        end
    end)
end

function ENT:SetData(k,v,network)
    return self.exterior:SetData(k, v, network)
end

function ENT:GetData(k,default)
    return self.exterior:GetData(k, default)
end

function ENT:ClearData()
    self.exterior:ClearData()
end