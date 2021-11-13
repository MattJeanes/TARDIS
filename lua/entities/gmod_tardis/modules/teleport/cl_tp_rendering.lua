-- Draw and render teleport-related functions


local function dopredraw(self,part)
	if (self:GetData("teleport") or self:GetData("teleport-trace")) and ((not part) or (part and (not part.CustomAlpha))) then
		render.SetBlend((self:GetData("teleport-trace") and 20 or self:GetData("alpha",255))/255)
	end
end

local function dodraw(self,part)
	if (self:GetData("teleport") or self:GetData("teleport-trace")) and ((not part) or (part and (not part.CustomAlpha))) then
		render.SetBlend(1)
	end
end

ENT:AddHook("PreDraw","teleport",dopredraw)
ENT:AddHook("PreDrawPart","teleport",dopredraw)
ENT:AddHook("Draw","teleport",dodraw)
ENT:AddHook("DrawPart","teleport",dodraw)

hook.Add("PostDrawTranslucentRenderables", "tardis-trace", function()
	local ext=TARDIS:GetExteriorEnt()
	if IsValid(ext) and ext:GetData("teleport-trace") then
		local pos,ang=ext:GetThirdPersonTrace(LocalPlayer(),LocalPlayer():EyeAngles())
		local fw=ang:Forward()
		local bk=fw*-1
		local ri=ang:Right()
		local le=ri*-1

		local size=10
		local col=Color(255,0,0)
		render.DrawLine(pos,pos+(fw*size),col)
		render.DrawLine(pos,pos+(bk*size),col)
		render.DrawLine(pos,pos+(ri*size),col)
		render.DrawLine(pos,pos+(le*size),col)
	end
end)