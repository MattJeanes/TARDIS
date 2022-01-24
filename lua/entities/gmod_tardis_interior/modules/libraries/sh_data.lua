-- Data

if SERVER then
	util.AddNetworkString("TARDISI-Data")
	util.AddNetworkString("TARDISI-DataClear")
	
	function ENT:SendData(ply)
		if self.data then
			net.Start("TARDISI-Data")
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
	
	hook.Add("PlayerInitialSpawn", "TARDISI-Data", function(ply)
		for k,v in pairs(ents.FindByClass("gmod_tardis_interior")) do
			v:SendData(ply)
		end
	end)
else
	net.Receive("TARDISI-Data", function()
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

	net.Receive("TARDISI-DataClear", function()
		local ent=net.ReadEntity()
		ent:ClearData()
	end)
end

function ENT:SetData(k,v,network)
	if not self.data then self.data = {} end
	self.data[k]=v
	self:CallHook("DataChanged",k,v)
	
	if SERVER and network then
		net.Start("TARDISI-Data")
			net.WriteEntity(self)
			net.WriteBool(false)
			net.WriteType(k)
			net.WriteType(v)
		net.Broadcast()
	end
	return v
end

function ENT:GetData(k,default)
	return (self.data and self.data[k]~=nil) and self.data[k] or default
end

function ENT:ClearData()
	self.data=nil
	if SERVER then
		net.Start("TARDISI-DataClear")
			net.WriteEntity(self)
		net.Broadcast()
	end
end