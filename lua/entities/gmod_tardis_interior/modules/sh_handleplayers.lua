-- Handles players inside the tardis interior

if SERVER then
	hook.Add("PlayerSpawn", "tardis-handleplayers", function(ply)
		local int=ply:GetTardisData("interior")
		if IsValid(int) and int.TardisInterior then
			local fallback=int.metadata.Interior.Fallback
			if fallback then
				ply:SetPos(int:LocalToWorld(fallback.pos))
				ply:SetEyeAngles(int:LocalToWorldAngles(fallback.ang))
			end
		end
	end)
else
	ENT:AddHook("ShouldDraw", "players", function(self)
		if ((not (LocalPlayer():GetTardisData("interior")==self)) or (LocalPlayer():GetTardisData("thirdperson") and (self.props[self.exterior]==nil))) and not wp.drawing and not self.contains[LocalPlayer().door] then
			return false
		end
	end)
	ENT:AddHook("ShouldThink", "players", function(self)
		if not (LocalPlayer():GetTardisData("interior")==self) then
			return false
		end
	end)
end