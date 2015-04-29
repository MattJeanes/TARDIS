-- Client to server control

if SERVER then
	util.AddNetworkString("TARDIS-Control")

	local controls={
		["toggledoor"]=function(ply, ext) ext:ToggleDoor() end
	}

	net.Receive("TARDIS-Control", function(len,ply)
		if IsValid(ply) then
			local control=net.ReadString()
			local ext=ply:GetNetEnt("tardis")
			if controls[control] and IsValid(ext) then
				controls[control](ply,ext)
			end
		end
	end)
else
	function ENT:Control(name,func)
		net.Start("TARDIS-Control")
		net.WriteString(name)
		if func then func() end
		net.SendToServer()
	end
end