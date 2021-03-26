-- Key bind system (inspired by WAC)

if SERVER then
	util.AddNetworkString("TARDIS-Control")
end

local controls={}

function TARDIS:AddControl(control)
	if CLIENT or (SERVER and (not control.clientonly)) then
		controls[control.id] = table.Copy(control)
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

function TARDIS:Control(control_id, ply)
	if CLIENT then ply=LocalPlayer() end
	if not ply:IsPlayer() then return end
	local control=controls[control_id]
	local ext=ply:GetTardisData("exterior")
	if control and IsValid(ext) then
		local int=ply:GetTardisData("interior")
		if not IsValid(int) then return end
		if ext:CallHook("CanUseTardisControl", control_id, ply) == false
			or int:CallHook("CanUseTardisControl", control_id, ply) == false
		then
			return
		end
		local res_ext, res_int
		local cl_serv_ok = (CLIENT and not control.serveronly) or (SERVER and not control.clientonly)
		if cl_serv_ok and control.ext_func then
			res_ext = control.ext_func(ext, ply)
		end
		if cl_serv_ok and control.int_func then
			res_int = control.int_func(int, ply)
		end
		if CLIENT and (res_ext ~= false) and (res_int ~= false) and (not control.clientonly) then
			net.Start("TARDIS-Control")
				net.WriteString(control_id)
			net.SendToServer()
		end
		ext:CallHook("TardisControlUsed", control_id, ply)
		int:CallHook("TardisControlUsed", control_id, ply)
	end
end

net.Receive("TARDIS-Control", function(_,ply)
	TARDIS:Control(net.ReadString(), ply)
end)

TARDIS:AddControl({
	id = "test",
	ext_func = function(self,ply)
		if CLIENT then
            TARDIS:Message(LocalPlayer(), "CLIENT: "..tostring(self))
		else
            TARDIS:Message(ply, "SERVER: "..tostring(self))
		end
	end,
	int_func = function(self,ply)
		if CLIENT then
            TARDIS:Message(LocalPlayer(), "CLIENT: "..tostring(self))
		else
            TARDIS:Message(ply, "SERVER: "..tostring(self))
		end
	end,
	screen_button = false,
	tip_text = "Test",
})