-- Helper functions

function TARDIS:GetExteriorEnt(ply)
	return (CLIENT and LocalPlayer() or ply):GetTardisData("exterior")
end

function TARDIS:GetInteriorEnt(ply)
	return (CLIENT and LocalPlayer() or ply):GetTardisData("interior")
end

function TARDIS:Benchmark(name,func)
	local time=SysTime()
	func()
	time=(SysTime()-time)*1000
	cam.Start2D()
		draw.DrawText(name.." took "..time .."ms","DermaLarge",50,1000*math.random(),Color(255,255,255,255),TEXT_ALIGN_LEFT)
	cam.End2D()
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