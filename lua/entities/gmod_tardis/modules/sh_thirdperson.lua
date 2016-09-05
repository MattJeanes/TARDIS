-- Third person

TARDIS:AddKeyBind("tp-toggledoor",{
	name="Toggle Door",
	section="Third Person",
	func=function(self,down,ply)
		if ply==self.pilot and down then
			self:ToggleDoor()
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

function ENT:GetThirdPersonPos(ply,ang)
	local pos=self:LocalToWorld(Vector(0,0,60))
	local tr = util.TraceLine({
		start=pos,
		endpos=pos-(ang:Forward()*ply:GetTardisData("thirdpersondist",defaultdist)),
		mask=MASK_NPCWORLDSTATIC
	})
	return tr.HitPos+(ang:Forward()*10), Angle(ang.p,ang.y,0)
end

function ENT:GetThirdPersonTrace(ply,ang)
	local pos,ang=self:GetThirdPersonPos(ply,ang)
	local trace=util.QuickTrace(pos,ang:Forward()*9999999999,self)
	local angle=trace.HitNormal:Angle()
	angle:RotateAroundAxis(angle:Right(),-90)
	return trace.HitPos,angle
end

if SERVER then
	function ENT:PlayerThirdPerson(ply, enabled)
		if IsValid(ply) and ply:IsPlayer() and self.occupants[ply] then
			if enabled then
				if IsValid(ply:GetActiveWeapon()) then
					ply:SetTardisData("activewep", ply:GetActiveWeapon():GetClass())
				end
				ply:Give("tardis_hands")
				ply:SetActiveWeapon(ply:GetWeapon("tardis_hands"))
				ply:SetTardisData("thirdperson",true,true)
				ply:SetTardisData("thirdpersonang",ply:EyeAngles(),true)
				ply:SetTardisData("thirdpersoncool", CurTime()+0.5)
				ply:SetEyeAngles(self:LocalToWorldAngles(Angle(10,180,0)))
				self:CallHook("ThirdPerson", ply, enabled)
			else
				if ply:GetTardisData("activewep") then
					ply:SetActiveWeapon(ply:GetWeapon(ply:GetTardisData("activewep")))
				end
				ply:SetTardisData("activewep")
				ply:StripWeapon("tardis_hands")
				ply:SetTardisData("thirdperson",false,true)
				ply:SetEyeAngles(ply:GetTardisData("thirdpersonang"))
				ply:SetTardisData("thirdpersonang")
				ply:SetTardisData("thirdpersoncool", CurTime()+0.5)
				self:CallHook("ThirdPerson", ply, enabled)
				self:SendMessage("ThirdPerson",function()
					net.WriteEntity(ply)
					net.WriteBool(enabled)
				end)
				if not IsValid(self.interior) then
					self:PlayerExit(ply,true)
				end
			end
		end
	end
	
	ENT:AddHook("PlayerExit", "thirdperson", function(self,ply)
		if ply:GetTardisData("thirdperson") then
			self:PlayerThirdPerson(ply,false)
		end
	end)

	hook.Add("SetupPlayerVisibility", "tardis-thirdperson", function(ply)
		if ply:GetTardisData("thirdperson") and IsValid(ply:GetTardisData("exterior")) then
			AddOriginToPVS(ply:GetTardisData("exterior"):GetPos())
		end
	end)
	
	hook.Add("StartCommand", "tardis-thirdperson", function(ply, cmd)
		if ply:GetTardisData("thirdperson") then
			local ext=ply:GetTardisData("exterior")
			if not IsValid(ext) then return end
			if not ply:Alive() then ext:PlayerThirdPerson(ply,false) return end
			local ang=cmd:GetViewAngles()
			ang.r=0
			ply:SetTardisData("viewang",ang)
			cmd:ClearMovement()
			cmd:SetViewAngles(ply:GetTardisData("thirdpersonang"))
			if cmd:KeyDown(IN_USE) and CurTime()>ply:GetTardisData("thirdpersoncool", 0) then -- user wants out
				ext:PlayerThirdPerson(ply,false)
			end
			cmd:ClearButtons()
		end
	end)
else
	hook.Add("StartCommand", "tardis-thirdperson", function(ply, cmd)
		if ply:GetTardisData("thirdperson") then
			if cmd:GetMouseWheel()~=0 then
				ply:SetTardisData("thirdpersondist",math.Clamp(ply:GetTardisData("thirdpersondist",defaultdist)-cmd:GetMouseWheel()*0.03*(1.1+ply:GetTardisData("thirdpersondist",defaultdist)),90,500))
			end
			cmd:ClearMovement()
		end
	end)
	
	hook.Add("SetupMove", "tardis-thirdperson", function(ply, mv, cmd)
		if ply:GetTardisData("thirdperson") then
			mv:SetButtons(0)
			mv:SetMoveAngles(ply:GetTardisData("thirdpersonang", Angle(0,0,0)))
		end
	end)
	
	ENT:AddHook("Initialize", "thirdperson", function(self)
		self.thpprop=ents.CreateClientProp("models/props_junk/PopCan01a.mdl")
		self.thpprop:SetNoDraw(true)
	end)
	
	ENT:AddHook("OnRemove", "thirdperson", function(self)
		if IsValid(self.thpprop) then
			self.thpprop:Remove()
			self.thpprop=nil
		end
	end)
	
	ENT:OnMessage("ThirdPerson",function(self)
		local ply = net.ReadEntity()
		local enabled = net.ReadBool()
		self:CallHook("ThirdPerson",ply,enabled)
	end)
	
	oldgetviewentity=oldgetviewentity or GetViewEntity
	function GetViewEntity(...)
		if LocalPlayer():GetTardisData("thirdperson") then
			local ext=LocalPlayer():GetTardisData("exterior")
			if IsValid(ext.thpprop) then
				return ext.thpprop
			end
		end
		return oldgetviewentity(...)
	end
	
	local meta=FindMetaTable("Player")
	oldgetviewentity2=oldgetviewentity2 or meta.GetViewEntity
	function meta:GetViewEntity(...)
		if self:GetTardisData("thirdperson") then
			local ext=self:GetTardisData("exterior")
			if IsValid(ext.thpprop) then
				return ext.thpprop
			end
		end
		return oldgetviewentity2(self,...)
	end
	hook.Add("CalcView", "tardis-thirdperson", function(ply, pos, ang)
		if ply:GetTardisData("thirdperson") then
			local ext=ply:GetTardisData("exterior")
			if IsValid(ext) then
				local pos,ang=ext:GetThirdPersonPos(ply,ang)
				local view = {}
				view.origin = pos
				view.angles = ang
				view.fov = fov
				
				if IsValid(ext.thpprop) then
					ext.thpprop:SetPos(view.origin)
					ext.thpprop:SetAngles(view.angles)
				end
				
				return view
			end
		end
	end)
	
	local hudblock={
		CHudAmmo = true,
		CHudBattery = true,
		CHudCrosshair = true,
		CHudHealth = true,
		CHudSecondaryAmmo = true,
		CHudWeaponSelection = true
	}
	hook.Add("HUDShouldDraw", "tardis-thirdperson", function(name)
		local ply=LocalPlayer()
		if ply.GetTardisData and ply:GetTardisData("thirdperson") and hudblock[name] then
			return false
		end
	end)
	
	hook.Add("Initialize", "tardis-thirdperson", function(name)
		oldtargetid=oldtargetid or GAMEMODE.HUDDrawTargetID
		GAMEMODE.HUDDrawTargetID = function(...)
			if LocalPlayer():GetTardisData("thirdperson") then return end
			oldtargetid(...)
		end
	end)
	
	hook.Add("PrePlayerDraw", "tardis-thirdperson", function(ply)
		if ply:GetTardisData("thirdperson") then
			ply.angtemp=ply:EyeAngles()
			ply:SetRenderAngles(Angle(0,ply:GetTardisData("thirdpersonang",0).y,0))
		end
	end)
	
	hook.Add("ShouldDrawLocalPlayer", "tardis-thirdperson", function(ply)
		if ply:GetTardisData("thirdperson") then
			return true
		end
	end)
end