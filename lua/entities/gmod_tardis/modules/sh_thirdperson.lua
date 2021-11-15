-- Third person

TARDIS:AddKeyBind("tp-toggledoor",{
	name="Toggle Door",
	section="Third Person",
	func=function(self,down,ply)
		if ply==self.pilot and down then
			TARDIS:Control("door", ply)
		end
	end,
	key=KEY_F,
	serveronly=true,
	exterior=true
})

hook.Add("PlayerSwitchFlashlight", "tardis-thirdperson", function(ply,enabled)
	if ply:GetTardisData("thirdperson") then
		return false
	end
end)

local defaultdist=210

function ENT:GetThirdPersonPos(ply, ang)
	local pos=self:LocalToWorld(Vector(0,0,60))
	local tr = util.TraceLine({
		start=pos,
		endpos=pos-(ang:Forward()*ply:GetTardisData("thirdpersondist",defaultdist)),
		mask=MASK_NPCWORLDSTATIC,
		ignoreworld=self:GetData("vortex")
	})
	return tr.HitPos+(ang:Forward()*10), Angle(ang.p,ang.y,0)
end

function ENT:GetThirdPersonTrace(ply,ang)
	local pos,ang=self:GetThirdPersonPos(ply,ang)
	local trace=util.QuickTrace(pos,ang:Forward()*9999999999,{self,TARDIS:GetPart(self,"door")})
	local angle=trace.HitNormal:Angle()
	angle:RotateAroundAxis(angle:Right(),-90)
	return trace.HitPos,angle
end

if SERVER then
	function ENT:PlayerThirdPerson(ply, enabled)
		if IsValid(ply) and ply:IsPlayer() and self.occupants[ply] then
			if self:SetOutsideView(ply, enabled) then
				ply:SetTardisData("thirdperson", enabled, true)
				self:CallHook("ThirdPerson", ply, enabled)
			end
		end
	end
	ENT:AddHook("Outside", "thirdperson", function(self, ply, enabled)
		if not enabled then
			ply:SetTardisData("thirdperson", enabled, true)
			self:CallHook("ThirdPerson", ply, enabled)
		end
	end)
else
	ENT:AddHook("Outside-StartCommand", "thirdperson", function(self, ply, cmd)
		if LocalPlayer():GetTardisData("thirdperson") and cmd:GetMouseWheel()~=0 then
			ply:SetTardisData("thirdpersondist",math.Clamp(ply:GetTardisData("thirdpersondist",defaultdist)-cmd:GetMouseWheel()*0.03*(1.1+ply:GetTardisData("thirdpersondist",defaultdist)),90,500))
		end
	end)
	ENT:AddHook("Outside-PosAng", "thirdperson", function(self, ply, pos, ang)
		if LocalPlayer():GetTardisData("thirdperson") then
			return self:GetThirdPersonPos(ply, ang)
		end
	end)
end