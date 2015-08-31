-- Helper functions

function TARDIS:GetExterior(ply)
	return (CLIENT and LocalPlayer() or ply):GetTardisData("exterior")
end

function TARDIS:GetInterior(ply)
	return (CLIENT and LocalPlayer() or ply):GetTardisData("interior")
end

--[[
local meta=FindMetaTable("Player")
meta.OldSetEyeAngles=meta.OldSetEyeAngles or meta.SetEyeAngles
function meta:SetEyeAngles(...)
	print(...)
	print(debug.traceback())
	self:OldSetEyeAngles(...)
end

hook.Add("HUDPaint", "tardis-debug", function()
	local ply=LocalPlayer()
	local int=TARDIS:GetInterior(ply)
	if IsValid(int) then
		local portals=int.portals
		local e=ply:EyeAngles()
		local l=portals[2]:WorldToLocalAngles(e)
		local n=portals[1]:LocalToWorldAngles(l)
		draw.SimpleText(tostring(e), "DermaLarge", 100, 50, Color(86, 104, 86, 255), 0, 0)
		draw.SimpleText(tostring(l), "DermaLarge", 100, 100, Color(86, 104, 86, 255), 0, 0)
		draw.SimpleText(tostring(n), "DermaLarge", 100, 150, Color(86, 104, 86, 255), 0, 0)
	end
end)
]]--