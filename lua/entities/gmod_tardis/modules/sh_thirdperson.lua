-- Third person

hook.Add("PlayerSwitchFlashlight", "tardis-thirdperson", function(ply,enabled)
	if ply:GetTardisData("thirdperson") then
		return false
	end
end)

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
			else
				if ply:GetTardisData("activewep") then
					ply:SetActiveWeapon(ply:GetWeapon(ply:GetTardisData("activewep")))
				end
				ply:SetTardisData("activewep")
				ply:StripWeapon("tardis_hands")
				ply:SetTardisData("thirdperson",false,true)
				ply:SetEyeAngles(ply:GetTardisData("thirdpersonang"),true)
				ply:SetTardisData("thirdpersonang")
				ply:SetTardisData("thirdpersoncool", CurTime()+0.5)
				if not IsValid(self.interior) then
					self:PlayerExit(ply,true)
				end
			end
		end
	end

	hook.Add("SetupPlayerVisibility", "tardis-thirdperson", function(ply)
		if ply:GetTardisData("thirdperson") and IsValid(ply:GetTardisData("exterior")) then
			AddOriginToPVS(ply:GetTardisData("exterior"):GetPos())
		end
	end)
	
	hook.Add("StartCommand", "tardis-thirdperson", function(ply, cmd)
		if ply:GetTardisData("thirdperson") then
			if not ply:Alive() then ply:GetTardisData("exterior"):PlayerThirdPerson(ply,false) return end
			cmd:ClearMovement()
			cmd:SetViewAngles(ply:GetTardisData("thirdpersonang"))
			if cmd:KeyDown(IN_USE) and CurTime()>ply:GetTardisData("thirdpersoncool", 0) then -- user wants out
				ply:GetTardisData("exterior"):PlayerThirdPerson(ply,false)
			end
			cmd:ClearButtons()
		end
	end)
else
	ENT:AddHook("ShouldDraw", "thirdperson", function(self)
		if LocalPlayer():GetTardisData("thirdperson") then
			return false
		end
	end)

	hook.Add("StartCommand", "tardis-thirdperson", function(ply, cmd)
		if ply:GetTardisData("thirdperson") then
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
				local pos=ext:LocalToWorld(Vector(0,0,60))
				local tr = util.TraceLine({
					start=pos,
					endpos=pos-(ang:Forward()*210),
					mask=MASK_NPCWORLDSTATIC
				})
				local view = {}
				view.origin = tr.HitPos + (ang:Forward()*10)
				view.angles = Angle(ang.p,ang.y,0)
				view.fov = fov
				
				if IsValid(ext.thpprop) then
					ext.thpprop:SetPos(view.origin)
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
		else
			--print(name)
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
	
	--[[ bad dirty hacks do not use
	hook.Add("wp-shouldrender", "tardisi-thirdperson", function(portal,exit,origin)
		local ply=LocalPlayer()
		if ply:GetTardisData("thirdperson") then
			if portal:GetParent()==ply:GetTardisData("exterior") then
				return true
			elseif portal:GetParent()==ply:GetTardisData("interior") then
				return false
			end
		end
	end)
	]]--
end