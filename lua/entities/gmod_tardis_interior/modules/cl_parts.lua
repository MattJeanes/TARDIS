-- Special rendering for transparent parts

ENT:AddHook("PostDrawTranslucentRenderables","parts",function(self)
	if self.parts then
		for _,part in pairs(self.parts) do
			if IsValid(part) and part.UseTransparencyFix then
				TARDIS.DrawOverride(part,true)
			end
		end
	end
end)