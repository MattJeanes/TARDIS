-- Key bind system (inspired by WAC)

if SERVER then
	util.AddNetworkString("TARDIS-Control")
end

local controls={}

function TARDIS:AddControl(id,data)
	if CLIENT or (SERVER and (not data.clientonly)) then
		controls[id]=table.Copy(data)
	end
end

function TARDIS:RemoveControl(id)
	controls[id]=nil
end

function TARDIS:GetControls()
	return controls
end

function TARDIS:GetControl(id)
	if controls[id] then
		return controls[id]
	end
end

function TARDIS:Control(id,ply)
	if CLIENT then ply=LocalPlayer() end
	local control=controls[id]
	local ext=ply:GetTardisData("exterior")
	if control and IsValid(ext) then
		local int=ply:GetTardisData("interior")
		local res,res2
		if (CLIENT and not control.serveronly) or (SERVER and not control.clientonly) and control.func then
			if control.exterior then
				res=control.func(ext,ply)
			end
			if control.interior and IsValid(ext) then
				res2=control.func(int,ply)
			end
		end
		if CLIENT and (res~=false) and (res2~=false) and (not control.clientonly) then
			net.Start("TARDIS-Control")
				net.WriteString(id)
			net.SendToServer()
		end
	end
end

net.Receive("TARDIS-Control", function(_,ply)
	TARDIS:Control(net.ReadString(),ply)
end)

TARDIS:AddControl("test",{
	func=function(self,ply)
		if CLIENT then
			LocalPlayer():ChatPrint("CLIENT: "..tostring(self))
		else
			ply:ChatPrint("SERVER: "..tostring(self))
		end
	end,
	exterior=true,
	interior=true
})