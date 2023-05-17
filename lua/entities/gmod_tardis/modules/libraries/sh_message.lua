-- Message

if SERVER then
    util.AddNetworkString("TARDIS-MessageExt")
end

function ENT:SendMessage(name,data,ply)
    net.Start("TARDIS-MessageExt")
    net.WriteEntity(self)
    net.WriteString(name)

    if data then
        net.WriteBit(1)
        net.WriteString(TARDIS.von.serialize(data))
    else
        net.WriteBit(0)
    end

    if SERVER then
        if IsValid(ply) and ply:IsPlayer() then
            net.Send(ply)
        else
            net.Broadcast()
        end
    else
        net.SendToServer()
    end
end

local messagehandlers={}
function ENT:OnMessage(name,func)
    messagehandlers[name]=func
end

net.Receive("TARDIS-MessageExt", function(len,ply)
    local ent = net.ReadEntity()
    local name = net.ReadString()
    local data_exists = net.ReadBit()
    local data

    if data_exists == 1 then
        data = TARDIS.von.deserialize(net.ReadString())
    end

    if not IsValid(ent) then return end

    if messagehandlers[name] and (ent._init or SERVER) then
        messagehandlers[name](ent,data,ply)
    else
        if not ent.msg_queue then ent.msg_queue = {} end
        ent.msg_queue[#ent.msg_queue + 1] = { name = name, data = data, ply = ply }
    end
end)

if CLIENT then
    ENT:AddHook("Initialize","messages",function(self)
        if not self.msg_queue then return end

        for k,v in ipairs(self.msg_queue) do
            if messagehandlers[v.name] then
                messagehandlers[v.name](self, v.data, v.ply)
            end
        end
    end)
end