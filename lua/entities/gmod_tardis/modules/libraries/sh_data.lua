-- Data

if SERVER then
    util.AddNetworkString("TARDIS-Data")
    util.AddNetworkString("TARDIS-DataClear")

    function ENT:SendData(ply)
        if self.data then
            net.Start("TARDIS-Data")
                net.WriteEntity(self)
                net.WriteBool(true)
                net.WriteString(TARDIS.von.serialize(self.data))
            if IsValid(ply) then
                net.Send(ply)
            else
                net.Broadcast()
            end
        end
    end

    hook.Add("PlayerInitialSpawn", "TARDIS-Data", function(ply)
        for k,v in pairs(ents.FindByClass("gmod_tardis")) do
            v:SendData(ply)
        end
    end)
else
    net.Receive("TARDIS-Data", function()
        local ent=net.ReadEntity()
        local mode=net.ReadBool()
        if mode then
            if IsValid(ent) then
                ent.data=TARDIS.von.deserialize(net.ReadString())
                ent:CallHook("DataLoaded")
            end
        else
            local k=net.ReadType()
            local v=net.ReadType()
            if IsValid(ent) and ent.SetData then
                ent:SetData(k,v)
            end
        end
    end)

    net.Receive("TARDIS-DataClear", function()
        local ent=net.ReadEntity()
        ent:ClearData()
    end)
end

function ENT:SetData(k,v,network)
    if not self.data then self.data = {} end
    self.data[k]=v
    self:CallHook("DataChanged",k,v)

    if SERVER and network then
        net.Start("TARDIS-Data")
            net.WriteEntity(self)
            net.WriteBool(false)
            net.WriteType(k)
            net.WriteType(v)
        net.Broadcast()
    end
    return v
end

function ENT:GetData(k,default)
    if self.data and self.data[k] ~= nil then
        return self.data[k]
    end
    return default
end

function ENT:ClearData()
    self.data=nil
    if SERVER then
        net.Start("TARDIS-DataClear")
            net.WriteEntity(self)
        net.Broadcast()
    end
end