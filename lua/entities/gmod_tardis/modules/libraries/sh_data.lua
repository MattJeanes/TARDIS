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
	
	hook.Add("PlayerInitialSpawn", "tardis-data", function(ply)
		for k,v in pairs(ents.FindByClass("gmod_tardis")) do
			v:SendData(ply)
		end
	end)
else
	net.Receive("TARDIS-Data", function()
		local ext=net.ReadEntity()
		local mode=net.ReadBool()
		if mode then
			if IsValid(ext) then
				ext.data=TARDIS.von.deserialize(net.ReadString())
			end
		else
			local k=net.ReadType()
			local v=net.ReadType()
			if IsValid(ext) and ext.SetData then
				ext:SetData(k,v)
			end
		end
	end)

	net.Receive("TARDIS-DataClear", function()
		local ext=net.ReadEntity()
		ext:ClearData()
	end)
end

function ENT:SetData(k,v,network)
	if not self.data then self.data = {} end
	self.data[k]=v
	
	if SERVER and network then
		net.Start("TARDIS-Data")
			net.WriteEntity(self)
			net.WriteBool(false)
			net.WriteType(k)
			net.WriteType(v)
		net.Broadcast()
	end
end

function ENT:GetData(k,default)
	return (self.data and self.data[k]~=nil) and self.data[k] or default
end

function ENT:ClearData()
	self.data=nil
	if SERVER then
		net.Start("TARDIS-DataClear")
			net.WriteEntity(self)
		net.Broadcast()
	end
end