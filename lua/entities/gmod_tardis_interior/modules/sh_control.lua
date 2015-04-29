-- Secure networking layer for control

if SERVER then
	util.AddNetworkString("TARDISInt-Control")
	
	function ENT:Control(name,func,ply)
		net.Start("TARDISInt-Control")
		net.WriteString(name)
		net.WriteEntity(self)
		if func then func() end
		if IsValid(ply) then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end

	local controls={}

	net.Receive("TARDISInt-Control", function(len,ply)
		if IsValid(ply) then
			local control=net.ReadString()
			local int=ply:GetNetEnt("tardis_i")
			if controls[control] and IsValid(int) then
				controls[control](ply,int)
			end
		end
	end)
else
	function ENT:Control(name,func)
		net.Start("TARDISInt-Control")
		net.WriteString(name)
		if func then func() end
		net.SendToServer()
	end
	
	local controls={
		["thirdperson"] = function() LocalPlayer().tardis_tp = net.ReadBool() end
	}
	
	net.Receive("TARDISInt-Control", function(len)
		local control=net.ReadString()
		local int=net.ReadEntity()
		if controls[control] and IsValid(int) then
			controls[control](ply,int)
		end
	end)
end