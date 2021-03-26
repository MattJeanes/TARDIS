-- Destination

TARDIS:AddControl({
	id = "destination",
	ext_func=function(self,ply)
		self:SelectDestination(ply, true)
	end,
	serveronly=true,
	screen_button = {
		virt_console = false,
		mmenu = true,
		toggle = false,
		frame_type = {0, 1},
		text = "Destination",
		order = 4,
	},
	tip_text = "Destination Select",
})

-- Binds
TARDIS:AddKeyBind("destination-forward",{
	name="Forward",
	section="Destination",
	key=KEY_W,
	clientonly=true,
	exterior=true
})
TARDIS:AddKeyBind("destination-backward",{
	name="Backward",
	section="Destination",
	key=KEY_S,
	clientonly=true,
	exterior=true
})
TARDIS:AddKeyBind("destination-left",{
	name="Left",
	section="Destination",
	key=KEY_A,
	clientonly=true,
	exterior=true
})
TARDIS:AddKeyBind("destination-right",{
	name="Right",
	section="Destination",
	key=KEY_D,
	clientonly=true,
	exterior=true
})
TARDIS:AddKeyBind("destination-up",{
	name="Up",
	section="Destination",
	key=KEY_SPACE,
	clientonly=true,
	exterior=true
})
TARDIS:AddKeyBind("destination-down",{
	name="Down",
	section="Destination",
	key=KEY_LCONTROL,
	clientonly=true,
	exterior=true
})
TARDIS:AddKeyBind("destination-boost",{
	name="Boost",
	section="Destination",
	desc="Hold this key while navigating to speed up",
	key=KEY_LSHIFT,
	clientonly=true,
	exterior=true
})
TARDIS:AddKeyBind("destination-slow",{
	name="Rotate",
	section="Destination",
	desc="Hold this key to slow movement",
	key=KEY_LALT,
	clientonly=true,
	exterior=true
})
TARDIS:AddKeyBind("destination-rotate",{
	name="Rotate",
	section="Destination",
	desc="Hold this with the boost and left or right keys to rotate",
	key=KEY_LALT,
	clientonly=true,
	exterior=true
})
TARDIS:AddKeyBind("destination-demat",{
	name="Set",
	section="Teleport",
	func=function(self,down,ply)
		if TARDIS:HUDScreenOpen(ply) then return end
		if ply:GetTardisData("destination") then
			local prop = self:GetData("destinationprop")
			if IsValid(prop) then
				self:SendMessage("destination-demat", function()
					net.WriteVector(prop:GetPos())
					net.WriteAngle(prop:GetAngles())
				end)
			end
		end
	end,
	key=MOUSE_LEFT,
	clientonly=true,
	exterior=true	
})
TARDIS:AddKeyBind("destination-snaptofloor",{
	name="Snap To Floor",
	section="Destination",
	desc="Press this key to snap to the nearest floor",
	func=function(self,down,ply)
		if TARDIS:HUDScreenOpen(ply) then return end
		if ply:GetTardisData("destination") then
			local prop = self:GetData("destinationprop")
			if IsValid(prop) then
				local pos = util.QuickTrace(prop:GetPos()+Vector(0,0,50), Vector(0,0,-1)*99999999).HitPos
				prop:SetPos(pos)
			end
		end
	end,
	key=KEY_R,
	clientonly=true,
	exterior=true
})

if SERVER then
	function ENT:SelectDestination(ply, enabled)
		if IsValid(ply) and ply:IsPlayer() and self.occupants[ply] then
			if ply:GetTardisData("thirdperson") then
				-- bit hacky but allows us to take away pilot controls without taking them out third person
				ply:SetTardisData("thirdperson", false, true)
				self:CallHook("ThirdPerson", ply, false)
				ply:SetTardisData("wasthirdperson", true, true)
			end
			if enabled==false and ply:GetTardisData("wasthirdperson") then
				ply:SetTardisData("thirdperson", true, true)
				self:CallHook("ThirdPerson", ply, true)
				ply:SetTardisData("wasthirdperson", false, true)

				ply:SetTardisData("destination", false, true)
				self:CallHook("Destination", ply, false)
				self:SendMessage("destination",function()
					net.WriteBool(false)
				end, ply)
				return true
			elseif self:SetOutsideView(ply, enabled) then
				ply:SetTardisData("destination", enabled, true)
				self:CallHook("Destination", ply, enabled)
				self:SendMessage("destination",function()
					net.WriteBool(enabled)
				end,ply)
				return true
			end
		end
		return false
	end
	ENT:AddHook("Outside", "destination", function(self, ply, enabled)
		if not enabled then
			ply:SetTardisData("destination", enabled, true)
			self:CallHook("Destination", ply, enabled)
			self:SendMessage("destination",function()
				net.WriteBool(enabled)
			end,ply)
		end
	end)
	ENT:OnMessage("destination-demat", function(self, ply)
		local pos = net.ReadVector()
		local ang = net.ReadAngle()
		if ply:GetTardisData("destination") then
			self:SelectDestination(ply, false)
		end
		if self:GetData("vortex") or self:GetData("teleport") then
			if self:SetDestination(pos,ang) then
                TARDIS:Message(ply, "Destination locked, ready to materialise")
			else
                TARDIS:Message(ply, "Failed to set destination, may be transitioning")
			end
		else
			if TARDIS:GetSetting("dest-onsetdemat",false,ply) then
				self:Demat(pos,ang,function(success)
					if success then
                        TARDIS:Message(ply, "Destination locked, dematerialising...")
					else
                        TARDIS:Message(ply, "Failed to dematerialise")
					end
				end)
			else
				if self:SetDestination(pos,ang) then
                    TARDIS:Message(ply, "Destination locked, ready to dematerialise")
				else
                    TARDIS:Message(ply, "Failed to set destination")
				end
			end
		end
	end)
else
	local defaultdist = 210
	function ENT:GetDestinationPos(ply, pos, ang)
		local prop = self:GetData("destinationprop")
		if not IsValid(prop) then return end
		local pos=prop:LocalToWorld(Vector(0,0,60))
		local tr = util.TraceLine({
			start=pos,
			endpos=pos-(ang:Forward()*ply:GetTardisData("destinationdist",defaultdist)),
			mask=MASK_NPCWORLDSTATIC,
			ignoreworld=self:GetData("vortex")
		})
		return tr.HitPos+(ang:Forward()*10), Angle(ang.p,ang.y,0)
	end
	local function setup(ent)
		local prop = ents.CreateClientProp()
		prop:SetModel(ent:GetModel())
		prop:SetPos(ent:GetPos())
		prop:SetAngles(ent:GetAngles())
		local col = prop:GetColor()
		prop:SetColor(Color(col.r, col.g, col.b, 100))
		prop:SetRenderMode(RENDERMODE_TRANSALPHA)
		prop:SetSkin(ent:GetSkin())
		prop:Spawn()
		local groups = ent:GetBodyGroups()
		if groups then
			for k,v in pairs(groups) do
				prop:SetBodygroup(v.id, v.num)
			end
		end
		return prop
	end
	function ENT:CreateDestinationProp()
		self:RemoveDestinationProp()

		local prop = setup(self)
		for k,v in pairs(self.parts) do
			if not v.NoShadowCopy then
				local attachment = setup(v)
				attachment:SetParent(prop)
			end
		end

		prop:SetAngles(Angle(0,0,0))

		self:SetData("destinationprop", prop)
	end
	function ENT:RemoveDestinationProp()
		local prop = self:GetData("destinationprop")
		if IsValid(prop) then
			for k,v in pairs(prop:GetChildren()) do
				if IsValid(v) then
					v:Remove()
				end
			end
			prop:Remove()
		end
	end
	TARDIS:AddSetting({
		id="dest-onsetdemat",
		name="Destination - Demat on Set",
		desc="Should the TARDIS dematerialise immediately after destination is set?",
		section="Misc",
		value=false,
		type="bool",
		option=true,
		networked=true
	})
	ENT:AddHook("Outside-StartCommand", "destination", function(self, ply, cmd)
		if LocalPlayer():GetTardisData("destination") and cmd:GetMouseWheel()~=0 then
			ply:SetTardisData("destinationdist",math.Clamp(ply:GetTardisData("destinationdist",defaultdist)-cmd:GetMouseWheel()*0.03*(1.1+ply:GetTardisData("destinationdist",defaultdist)),90,500))
		end
	end)
	ENT:AddHook("Outside-PosAng", "destination", function(self, ply, pos, ang)
		if LocalPlayer():GetTardisData("destination") then
			return self:GetDestinationPos(ply, pos, ang)
		end
	end)
	ENT:AddHook("Destination", "destination", function(self, enabled)
		if enabled then
			self:CreateDestinationProp()
		else
			self:RemoveDestinationProp()
		end
	end)
	ENT:OnMessage("destination", function(self)
		local enabled = net.ReadBool()
		self:CallHook("Destination", enabled)
	end)
	ENT:AddHook("OnRemove", "destination", function(self)
		self:RemoveDestinationProp()
	end)
	ENT:AddHook("VortexEnabled", "destination", function(self)
		if LocalPlayer():GetTardisData("destination") then
			return false
		end
	end)
	ENT:AddHook("Think", "destination", function(self)
		if LocalPlayer():GetTardisData("destination") then
			local prop=self:GetData("destinationprop")
			if not IsValid(prop) then return end
			local dt=FrameTime()*66
			local eye=LocalPlayer():EyeAngles()
			eye.r = 0
			if not eye then
				eye=angle_zero
			end
			local force = 15
			local angforce = 1.5
			local boostmul = 2
			local slowmul = 0.1
			local angslowmul = 0.5
			local fwd=eye:Forward()
			local ri=eye:Right()
			local up=prop:GetUp()

			local mv = Vector(0,0,0)
			local rt = Angle(0,0,0)
			if TARDIS:IsBindDown("destination-forward") then
				mv:Add(force*fwd*dt)
			elseif TARDIS:IsBindDown("destination-backward") then
				mv:Add(force*fwd*-1*dt)
			end
			
			if TARDIS:IsBindDown("destination-rotate") and TARDIS:IsBindDown("destination-boost") then
				if TARDIS:IsBindDown("destination-left") then
					rt = rt + Angle(0,angforce*dt,0)
				end
				if TARDIS:IsBindDown("destination-right") then
					rt = rt + Angle(0,angforce*-1*dt,0)
				end
			else
				if TARDIS:IsBindDown("destination-left") then
					mv:Add(force*ri*-1*dt)
				end
				if TARDIS:IsBindDown("destination-right") then
					mv:Add(force*ri*dt)
				end
			end

			if TARDIS:IsBindDown("destination-up") then
				mv:Add(force*up*dt)
			elseif TARDIS:IsBindDown("destination-down") then
				mv:Add(force*up*-1*dt)
			end
			
			if TARDIS:IsBindDown("destination-slow") then
				mv=mv*slowmul
				rt=rt*angslowmul
			elseif TARDIS:IsBindDown("destination-boost") then
				mv=mv*boostmul
				rt=rt*boostmul
			end

			if not mv:IsZero() then
				prop:SetPos(prop:GetPos() + mv)
			end
			if not rt:IsZero() then
				prop:SetAngles(prop:GetAngles() + rt)
			end
		end
	end)
end
