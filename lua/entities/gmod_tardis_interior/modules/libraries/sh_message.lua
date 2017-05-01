-- Message

if SERVER then
	util.AddNetworkString("TARDIS-MessageInt")
end

function ENT:SendMessage(name,func,ply)
	net.Start("TARDIS-MessageInt")
	net.WriteEntity(self)
	net.WriteString(name)
	if func then
		func()
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

net.Receive("TARDIS-MessageInt", function(len,ply)
	local ent=net.ReadEntity()
	local name=net.ReadString()
	if IsValid(ent) and messagehandlers[name] then
		messagehandlers[name](ent,ply)
	end
end)