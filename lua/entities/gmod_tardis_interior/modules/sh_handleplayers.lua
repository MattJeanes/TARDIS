-- Handles players inside the tardis interior

if SERVER then
	ENT:AddHook("Think", "handleplayers", function(self)
		local pos=self:GetPos()
		for k,v in pairs(self.occupants) do
			if k:GetPos():Distance(pos) > 600 then
				self.exterior:PlayerExit(k,true)
			end
		end
	end)
	hook.Add("PlayerSpawn", "tardis-handleplayers", function(ply)
		local int=ply:GetTardisData("interior")
		if IsValid(int) then
			local fallback=int.metadata.Interior.Fallback
			if fallback then
				ply:SetPos(int:LocalToWorld(fallback.pos))
				ply:SetEyeAngles(int:LocalToWorldAngles(fallback.ang))
			end
		end
	end)
else
	ENT:AddHook("ShouldDraw", "players", function(self)
		if ((not (LocalPlayer():GetTardisData("interior")==self)) or LocalPlayer():GetTardisData("thirdperson")) and not wp.drawing then
			return false
		end
	end)
	ENT:AddHook("ShouldThink", "players", function(self)
		if not (LocalPlayer():GetTardisData("interior")==self) then
			return false
		end
	end)
end