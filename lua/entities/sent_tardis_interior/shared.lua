ENT.Type = "anim"
if WireLib then
	ENT.Base 			= "base_wire_entity"
else
	ENT.Base			= "base_gmodentity"
end 
ENT.PrintName		= "TARDIS Interior"
ENT.Author			= "Dr. Matt"
ENT.Contact			= "mattjeanes23@gmail.com"
ENT.Instructions	= "Don't spawn this!"
ENT.Purpose			= "Time and Relative Dimension in Space's Interior"
ENT.Spawnable		= false
ENT.AdminSpawnable	= false
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.Category		= "Doctor Who"

hook.Add("PhysgunPickup", "TARDISInt-PhysgunPickup", function(_,e)
	if e:GetClass()=="sent_tardis_interior" or e.tardis_chair then
		return false
	end
end)

hook.Add("OnPhysgunReload", "TARDISInt-OnPhysgunReload", function(_,p)
	local e = p:GetEyeTraceNoCursor().Entity
	if e:GetClass()=="sent_tardis_interior" or e.tardis_chair then
		return false
	end
end)

hook.Add("CanTool", "TARDISInt-CanTool", function(ply,tr,mode)
	local e=tr.Entity
	if mode=="remover" and IsValid(e) and (e:GetClass()=="sent_tardis_interior" or e.tardis_chair) then
		return false
	end
end)

hook.Add("CanProperty", "TARDISInt-CanProperty", function(ply,property,e)
	if e:GetClass()=="sent_tardis_interior" or e.tardis_chair then
		return false
	end
end)

hook.Add("InitPostEntity", "TARDISInt-InitPostEntity", function()
	if pewpew and pewpew.NeverEverList then // nice and easy, blocks pewpew from damaging the interior.
		table.insert(pewpew.NeverEverList, "sent_tardis_interior")
		hook.Add("PewPew_ShouldDamage","TARDIS-BlockDamage",function(pewpew,e,dmg,dmgdlr)
			if e.tardis_chair then
				return false
			end
		end)
	end
	if ACF and ACF_Check then // this one is a bit hacky, but ACFs internal code is shockingly bad.
		local original=ACF_Check
		function ACF_Check(e)
			if IsValid(e) then
				local class=e:GetClass()
				if class=="sent_tardis_interior" or e.tardis_chair then
					if not e.ACF then ACF_Activate(e) end
					return false
				end
			end
			return original(e)
		end
	end
end)