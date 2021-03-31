-- Teleport

TARDIS:AddSetting({
	id="breakdown-effects",
	name="Breakdown Effects",
	desc="Should TARDIS have sparkling and explosion effects in emergency moments?",
	section="Misc",
	value=true,
	type="bool",
	option=true,
	networked=true
})

TARDIS:AddSetting({
	id="teleport-door-autoclose",
	name="Auto-Close Doors at Demat",
	desc="Should TARDIS close doors automatically before demat?",
	section="Misc",
	value=false,
	type="bool",
	option=true,
	networked=true
})

-- Binds
TARDIS:AddKeyBind("teleport-demat",{
	name="Demat",
	section="Teleport",
	func=function(self,down,ply)
		if TARDIS:HUDScreenOpen(ply) then return end
		local pilot = self:GetData("pilot")
		if SERVER then
			if ply==pilot and down then
				ply:SetTardisData("teleport-demat-bind-down", true)
			end
			if ply==pilot and (not down) and ply:GetTardisData("teleport-demat-bind-down",false) then
				if not self:GetData("vortex") then
					if self:GetData("demat-pos") then
						self:Demat()
						return
					end
					local pos,ang=self:GetThirdPersonTrace(ply,ply:GetTardisData("viewang"))
					self:Demat(pos,ang)
				end
			end
			if not down and ply:GetTardisData("teleport-demat-bind-down",false) then
				ply:SetTardisData("teleport-demat-bind-down", nil)
			end
		else
			if ply==pilot and down and (not (self:GetData("vortex") or self:GetData("teleport"))) then
				self:SetData("teleport-trace",true)
			else
				self:SetData("teleport-trace",false)
			end
		end
	end,
	key=MOUSE_LEFT,
	exterior=true
})

TARDIS:AddKeyBind("teleport-mat",{
	name="Mat",
	section="Teleport",
	func=function(self,down,ply)
		if TARDIS:HUDScreenOpen(ply) then return end
		if ply==self.pilot and down then
			if self:GetData("vortex") then
				self:Mat()
			end
		end
	end,
	serveronly=true,
	key=MOUSE_LEFT,
	exterior=true
})

TARDIS:AddControl({
	id = "teleport",
	ext_func=function(self,ply)
		if (self:GetData("teleport") or self:GetData("vortex")) then
			self:Mat(function(result)
				if result then
					TARDIS:Message(ply, "Materialising")
				else
					TARDIS:ErrorMessage(ply, "Failed to materialise")
				end
			end)
		else
			local pos = pos or self:GetData("demat-pos") or self:GetPos()
			local ang = ang or self:GetData("demat-ang") or self:GetAngles()
			self:Demat(pos, ang, function(result)
				if result then
					TARDIS:Message(ply, "Dematerialising")
				else
					if self:GetData("doorstatereal", false) then
						TARDIS:ErrorMessage(ply, "Can't dematerialise while doors are open")
					elseif self:GetData("handbrake", false) then
						TARDIS:ErrorMessage(ply, "Time Rotor Handbrake is engaged! Cannot dematerialise")
					else
						TARDIS:ErrorMessage(ply, "Failed to dematerialise")
					end
				end
			end)
		end
	end,
	serveronly=true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {0, 1},
		text = "Teleport",
		pressed_state_from_interior = false,
		pressed_state_data = {"teleport", "vortex"},
		order = 7,
	},
	tip_text = "Space-Time Throttle",
})

TARDIS:AddControl({
	id = "fastreturn",
	ext_func=function(self,ply)
		self:FastReturn(function(result)
			if result then
				TARDIS:Message(ply, "Fast-return protocol initiated")
			else
				TARDIS:ErrorMessage(ply, "Failed to initiate fast-return protocol")
			end
		end)
	end,
	serveronly = true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = false,
		frame_type = {0, 1},
		text = "Fast Return",
		order = 8,
	},
	tip_text = "Fast Return Protocol",
})

TARDIS:AddControl({
	id = "vortex_flight",
	ext_func=function(self,ply)
		if self:ToggleFastRemat() then
			TARDIS:StatusMessage(ply, "Vortex flight", self:GetData("demat-fast"), "disabled", "enabled")
		else
			TARDIS:ErrorMessage(ply, "Failed to toggle vortex flight")
		end
	end,
	serveronly=true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = true,
		frame_type = {1, 2},
		text = "Vortex Flight",
		pressed_state_from_interior = false,
		pressed_state_data = "demat-fast",
		order = 9,
	},
	tip_text = "Vortex Flight Toggler",
})

TARDIS:AddControl({
	id = "engine_release",
	ext_func=function(self, ply)
		local pos = pos or self:GetData("demat-pos") or self:GetPos()
		local ang = ang or self:GetData("demat-ang") or self:GetAngles()
		self:EngineReleaseDemat(pos, ang, function(result)
			if result then
				TARDIS:Message(ply, "Force dematerialisation triggered")
			elseif result == false then
				TARDIS:ErrorMessage(ply, "Failed to dematerialise")
			end
		end)
	end,
	serveronly=true,
	screen_button = {
		virt_console = true,
		mmenu = false,
		toggle = false,
		frame_type = {0, 1},
		text = "Engine Release",
		order = 13,
	},
	tip_text = "Engine Release",
})

function ENT:GetRandomLocation(grounded)
	local td = {}
	td.mins = self:OBBMins()
	td.maxs = self:OBBMaxs()
	local max = 16384
	local tries = 1000
	local point
	while tries > 0 do
		tries = tries - 1
		point=Vector(math.random(-max, max),math.random(-max, max),math.random(-max, max))
		td.start=point
		td.endpos=point
		if not util.TraceHull(td).Hit
		then
			if grounded then
				local down = util.QuickTrace(point + Vector(0, 0, 50), Vector(0, 0, -1) * 99999999).HitPos
				return down, true
			else
				return point, false
			end
		end
	end
end

if SERVER then
	function ENT:ForceDemat(pos, ang, callback)
		self:SetData("force-demat", true, true)
		self:SetData("force-demat-time", CurTime(), true)
		self:Explode(30)
		self.interior:Explode(20)
		self:Demat(pos, ang, callback, true)
	end
	function ENT:EngineReleaseDemat(pos, ang, callback)
		if self:GetData("failing-demat", false) then
			self:SetData("failing-demat", false, true)
			self:ForceDemat(pos, ang, callback)
		end
	end
	function ENT:AutoDemat(pos, ang, callback)
		if self:CallHook("CanDemat", false) ~= false then
			self:Demat(pos, ang, callback)
		elseif self:CallHook("CanDemat", true)  ~= false then
			self:ForceDemat(pos, ang, callback)
		else
			if callback then callback(false) end
		end
	end

	function ENT:Demat(pos, ang, callback, force)
		if self:CallHook("CanDemat", force, false) == false then
			if self:CallHook("FailDemat", force) == true
				and self:CallHook("CanDemat", force, true) ~= false
			then
				self:SetData("failing-demat-time", CurTime(), true)
				self:SetData("failing-demat", true, true)
				self:SendMessage("failed-demat")
			end
			if callback then callback(false) end
		else
			if force or TARDIS:GetSetting("teleport-door-autoclose", false, self:GetCreator()) then
				if self:GetData("doorstatereal") then
					self:CloseDoor()
				end
				if self:GetData("doorstatereal") then
					if callback then callback(false) end
					return
				end
			end
			pos=pos or self:GetData("demat-pos") or self:GetPos()
			ang=ang or self:GetData("demat-ang") or self:GetAngles()
			self:SetBodygroup(1,0)
			self:SetData("demat-pos",pos,true)
			self:SetData("demat-ang",ang,true)
			self:SendMessage("demat", function() net.WriteVector(self:GetData("demat-pos",Vector())) end)
			self:SetData("demat",true)
			self:SetData("fastreturn-pos",self:GetPos())
			self:SetData("fastreturn-ang",self:GetAngles())
			self:SetData("step",1)
			self:SetData("teleport",true)
			self:SetCollisionGroup( COLLISION_GROUP_WORLD )
			self:CallHook("DematStart")
			self:DrawShadow(false)
			for k,v in pairs(self.parts) do
				v:DrawShadow(false)
			end
			local constrained = constraint.GetAllConstrainedEntities(self)
			local attached
			if constrained then
				for k,v in pairs(constrained) do
					if not (k.TardisPart or k==self) then
						local a=k:GetColor().a
						if not attached then attached = {} end
						attached[k] = a
					end
				end
			end
			self:SetData("demat-attached",attached,true)
			if callback then callback(true) end
		end
	end

	function ENT:InterruptTeleport(callback)
		if not self:GetData("teleport", false) and not self:GetData("vortex", false) then return end
		local pos, ang

		ang = self:GetAngles()
		if self:GetData("demat", false) then
			pos = self:GetPos()
		else
			pos = self:GetRandomLocation(false)
		end

		local attached=self:GetData("demat-attached")
		if attached then
			for k,v in pairs(attached) do
				if IsValid(k) then
					k:SetColor(ColorAlpha(k:GetColor(),v))
				end
				if IsValid(k) and not IsValid(k:GetParent()) then
					k.telepos=k:GetPos()-self:GetPos()
					if k:GetClass()=="gmod_hoverball" then -- fixes hoverballs spazzing out
						k:SetTargetZ( (pos-self:GetPos()).z+k:GetTargetZ() )
					end
				end
			end
		end
		self:SetPos(pos)
		self:SetAngles(ang)
		if attached then
			for k,v in pairs(attached) do
				if IsValid(k) and not IsValid(k:GetParent()) then
					if k:IsRagdoll() then
						for i=0,k:GetPhysicsObjectCount() do
							local bone=k:GetPhysicsObjectNum(i)
							if IsValid(bone) then
								bone:SetPos(self:GetPos()+k.telepos)
							end
						end
					end
					k:SetPos(self:GetPos()+k.telepos)
					k.telepos=nil
					local phys=k:GetPhysicsObject()
					if phys and IsValid(phys) then
						k:SetSolid(SOLID_VPHYSICS)
						if k.gravity~=nil then
							phys:EnableGravity(k.gravity)
							k.gravity = nil
						end
					end
					k.nocollide=nil
				end
			end
		end

		self:SetBodygroup(1,1)
		self:SetData("demat-attached",nil,true)
		self:SetData("fastreturn",false)

		self:DrawShadow(true)
		for k,v in pairs(self.parts) do
			if not v.NoShadow then
				v:DrawShadow(true)
			end
		end

		local ext = self.metadata.Exterior.Sounds.Teleport
		local int = self.metadata.Interior.Sounds.Teleport
		self:EmitSound(ext.demat_fail)
		self:EmitSound(ext.demat_fail)
		self.interior:EmitSound(int.demat_fail or ext.demat_fail)
		self.interior:EmitSound(int.demat_fail or ext.demat_fail)
		self.interior:EmitSound(int.mat_damaged or ext.mat_damaged)

		self:SetData("demat-pos",nil,true)
		self:SetData("demat-ang",nil,true)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)

		self:SetData("mat", false, true)
		self:SetData("demat", false, true)
		self:SetData("teleport", false, true)
		self:SetData("vortex", false, true)
		self:SetData("step", 1, true)
		self:SetFlight(false)
		self:SetFloat(false)

		self:Explode()
		self.interior:Explode(20)
		self:ChangeHealth(self:GetHealth() * math.random(85, 95) * 0.01)
		self:SetPower(false)
		self:CallHook("InterruptTeleport")

		self:SetData("teleport-interrupted", true, true)
		self:SetData("teleport-interrupt-time", CurTime(), true)
		self:SetData("teleport-interrupt-effects", true, true)
	end

	ENT:AddHook("OnHealthDepleted", "teleport", function(self)
		if self:GetData("teleport", false) then
			self:InterruptTeleport()
		end
	end)

	function ENT:Mat(callback)
		if self:CallHook("CanMat")~=false then
			self:CloseDoor(function(state)
				if state then
					if callback then callback(false) end
				else
					self:SendMessage("premat",function() net.WriteVector(self:GetData("demat-pos",Vector())) end)
					self:SetData("teleport",true)
					local timerdelay = (self:GetData("demat-fast",false) and 1.9 or 8.5)
					timer.Simple(timerdelay,function()
						if not IsValid(self) then return end
						self:SendMessage("mat")
						self:SetData("mat",true)
						self:SetData("step",1)
						self:SetData("vortex",false)
						local flight=self:GetData("prevortex-flight")
						if self:GetData("flight")~=flight then
							self:SetFlight(flight)
						end
						self:SetData("prevortex-flight",nil)
						self:SetSolid(SOLID_VPHYSICS)
						self:CallHook("MatStart")

						local pos=self:GetData("demat-pos",Vector())
						local ang=self:GetData("demat-ang",Angle())
						local attached=self:GetData("demat-attached")
						if attached then
							for k,v in pairs(attached) do
								if IsValid(k) and not IsValid(k:GetParent()) then
									k.telepos=k:GetPos()-self:GetPos()
									if k:GetClass()=="gmod_hoverball" then -- fixes hoverballs spazzing out
										k:SetTargetZ( (pos-self:GetPos()).z+k:GetTargetZ() )
									end
								end
							end
						end
						self:SetPos(pos)
						self:SetAngles(ang)
						if attached then
							for k,v in pairs(attached) do
								if IsValid(k) and not IsValid(k:GetParent()) then
									if k:IsRagdoll() then
										for i=0,k:GetPhysicsObjectCount() do
											local bone=k:GetPhysicsObjectNum(i)
											if IsValid(bone) then
												bone:SetPos(self:GetPos()+k.telepos)
											end
										end
									end
									k:SetPos(self:GetPos()+k.telepos)
									k.telepos=nil
									local phys=k:GetPhysicsObject()
									if phys and IsValid(phys) then
										k:SetSolid(SOLID_VPHYSICS)
										if k.gravity~=nil then
											phys:EnableGravity(k.gravity)
											k.gravity = nil
										end
									end
									k.nocollide=nil
								end
							end
						end
						self:SetData("demat-pos",nil,true)
						self:SetData("demat-ang",nil,true)
					end)
					if callback then callback(true) end
				end
			end)
		end
	end
	function ENT:FastReturn(callback)
		if self:CallHook("CanDemat")~=false and self:GetData("fastreturn-pos") then
			self:SetFastRemat(true)
			self:SetData("fastreturn",true)
			self:Demat(self:GetData("fastreturn-pos"),self:GetData("fastreturn-ang"))
			if callback then callback(true) end
		else
			if callback then callback(false) end
		end
	end
	function ENT:ToggleFastRemat()
		local on = not self:GetData("demat-fast",false)
		return self:SetFastRemat(on)
	end
	function ENT:SetFastRemat(on)
		self:SetData("demat-fast",on,true)
		return true
	end
	function ENT:StopDemat()
		self:SetData("demat",false)
		self:SetData("force-demat", false, true)
		self:SetData("step",1)
		self:SetData("vortex",true)
		self:SetData("teleport",false)
		self:SetSolid(SOLID_NONE)
		self:RemoveAllDecals()

		local flight = self:GetData("flight")
		self:SetData("prevortex-flight",flight)
		if not flight then
			self:SetFlight(true)
		end
		local attached=self:GetData("demat-attached")
		if attached then
			for k,v in pairs(attached) do
				if IsValid(k) and not IsValid(k:GetParent()) then
					local phys=k:GetPhysicsObject()
					if phys and IsValid(phys) then
						k:SetSolid(SOLID_NONE)
						k.gravity = phys:IsGravityEnabled()
						phys:EnableGravity(false)
					end
				end
			end
		end
		self:CallHook("StopDemat")
	end

	ENT:AddHook("StopDemat", "teleport-fast", function(self)
		if self:GetData("demat-fast",false) then
			timer.Simple(0.3, function()
				if not IsValid(self) then return end
				self:Mat()
			end)
		end
	end)

	function ENT:StopMat()
		self:SetBodygroup(1,1)
		self:SetData("mat",false)
		self:SetData("step",1)
		self:SetData("teleport",false)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:DrawShadow(true)
		for k,v in pairs(self.parts) do
			if not v.NoShadow then
				v:DrawShadow(true)
			end
		end
		local attached=self:GetData("demat-attached")
		if attached then
			for k,v in pairs(attached) do
				if IsValid(k) then
					k:SetColor(ColorAlpha(k:GetColor(),v))
				end
			end
		end
		self:SetData("demat-attached",nil,true)
		if self:GetData("fastreturn",false) then
			self:SetFastRemat(false)
			self:SetData("fastreturn",false)
		end
		self:CallHook("StopMat")
	end
	function ENT:SetDestination(pos, ang)
		self:SetData("demat-pos",pos,true)
		self:SetData("demat-ang",ang,true)
		return true
	end

	ENT:AddWireInput("Demat", "Dematerialise the TARDIS")
	ENT:AddWireInput("Mat", "Materialise the TARDIS")
	ENT:AddWireInput("Pos", "X,Y,Z: Teleport position", "VECTOR")
	ENT:AddWireInput("Ang", "X,Y,Z: Teleport angle", "ANGLE")

	ENT:AddHook("OnWireInput","teleport",function (self, name, value)
		if name == "Demat" and value >= 1 then
			self:Demat()
		elseif name == "Mat" and value >= 1 then
			self:Mat()
		elseif name == "Pos" then
			self:SetData("demat-pos",value,true)
		elseif name == "Ang" then
			self:SetData("demat-ang",value,true)
		end
	end)

	ENT:AddHook("HandleE2", "teleport_args", function(self, name, e2, pos, ang)
		if name == "Demat" and TARDIS:CheckPP(e2.player, self) then
			local success = self:CallHook("CanDemat")==false
			if not pos or not ang then
				self:Demat()
			else
				self:Demat(Vector(pos[1], pos[2], pos[3]), Angle(ang[1], ang[2], ang[3]))
			end
			return success and 0 or 1
		elseif name == "SetDestination" and TARDIS:CheckPP(e2.player, self) then
			local pos2 = Vector(pos[1], pos[2], pos[3])
			local ang2 = Angle(ang[1], ang[2], ang[3])
			return self:SetDestination(pos2,ang2) and 1 or 0
		end
	end)

	ENT:AddHook("HandleE2", "teleport_noargs", function(self, name, e2)
		if name == "Mat" and TARDIS:CheckPP(e2.player, self) then
			local success = (self:GetData("vortex",false) and self:CallHook("CanMat"))==false
			self:Mat()
			return success and 0 or 1
		elseif name == "Longflight" and TARDIS:CheckPP(e2.player, self) then
			return self:ToggleFastRemat() and 1 or 0
		elseif name == "FastReturn" and TARDIS:CheckPP(e2.player, self) then
			local success = self:CallHook("CanDemat")==false
			self:FastReturn()
			return success and 0 or 1
		elseif name == "FastDemat" and TARDIS:CheckPP(e2.player, self)then
			local success = self:CallHook("CanDemat")==false
			self:Demat()
			return success and 0 or 1
		end
	end)

	ENT:AddHook("HandleE2", "teleport_gets", function(self, name, e2)
		if name == "GetMoving" then
			return self:GetData("teleport",false) and 1 or 0
		elseif name == "GetInVortex" then
			return self:GetData("vortex",false) and 1 or 0
		elseif name == "GetLongflight" then
			return self:GetData("demat-fast",false) and 0 or 1
		elseif name == "LastAng" then
			return self:GetData("fastreturn-ang", {0,0,0})
		elseif name == "LastPos" then
			return self:GetData("fastreturn-pos", Vector(0,0,0))
		end
	end)

	ENT:AddHook("CanDemat", "teleport", function(self, force, ignore_fail_demat)
		if self:GetData("teleport") or self:GetData("vortex") or (not self:GetPower())
		then
			return false
		end
	end)

	ENT:AddHook("CanDemat", "failed", function(self, force, ignore_fail_demat)
		if ignore_fail_demat ~= true and self:CallHook("FailDemat", force) == true then
			return false
		end
	end)

	ENT:AddHook("FailDemat", "doors", function(self, force)
		if self:GetData("doorstatereal") and force ~= true
			and not TARDIS:GetSetting("teleport-door-autoclose", false, self:GetCreator())
		then
			return true
		end
	end)

	ENT:AddHook("CanMat", "teleport", function(self)
		if self:GetData("teleport") or (not self:GetData("vortex")) then
			return false
		end
	end)

	ENT:AddHook("CanToggleDoor","teleport",function(self,state)
		if self:GetData("teleport") then
			return false
		end
	end)

	ENT:AddHook("ShouldThinkFast","teleport",function(self)
		if self:GetData("teleport") then
			return true
		end
	end)

	ENT:AddHook("CanPlayerEnter","teleport",function(self)
		if self:GetData("teleport") or self:GetData("vortex") then
			return false, true
		end
	end)

	ENT:AddHook("CanPlayerEnterDoor","teleport",function(self)
		if (self:GetData("teleport") or self:GetData("vortex")) then
			return false
		end
	end)

	ENT:AddHook("CanPlayerExit","teleport",function(self)
		if self:GetData("teleport") or self:GetData("vortex") then
			return false
		end
	end)

	ENT:AddHook("ShouldTurnOnRotorwash", "teleport", function(self)
		if self:GetData("teleport") then
			return true
		end
	end)

	ENT:AddHook("ShouldTurnOffRotorwash", "teleport", function(self)
		if self:GetData("vortex") then
			return true
		end
	end)

	ENT:AddHook("ShouldTakeDamage", "vortex", function(self)
		if self:GetData("vortex",false) then return false end
	end)

	ENT:AddHook("ShouldExteriorDoorCollide", "teleport", function(self,open)
		if self:GetData("teleport") or self:GetData("vortex") then
			return false
		end
	end)
else
	TARDIS:AddSetting({
		id="teleport-sound",
		name="Teleport Sound",
		section="Sounds",
		value=true,
		type="bool",
		option=true
	})

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
	
	ENT:AddHook("ShouldTurnOnLight","teleport",function(self)
		if self:GetData("teleport") then
			return true
		end
	end)
	
	ENT:AddHook("ShouldPulseLight","teleport",function(self)
		if self:GetData("teleport") then
			return true
		end
	end)
	
	ENT:AddHook("ShouldTurnOffFlightSound", "teleport", function(self)
		if self:GetData("teleport") or self:GetData("vortex") then
			return true
		end
	end)
	
	ENT:OnMessage("demat", function(self)
		self:SetData("demat",true)
		self:SetData("step",1)
		self:SetData("teleport",true)
		if TARDIS:GetSetting("teleport-sound") and TARDIS:GetSetting("sound") then
			local ext = self.metadata.Exterior.Sounds.Teleport
			local int = self.metadata.Interior.Sounds.Teleport

			local sound_demat_ext = ext.demat
			local sound_demat_int = int.demat or ext.demat
			local sound_fullflight_ext = ext.fullflight
			local sound_fullflight_int = int.fullflight or ext.fullflight

			if self:GetData("health-warning", false) or self:GetData("force-demat", false) then
				sound_demat_ext = ext.demat_damaged
				sound_demat_int = int.demat_damaged or ext.demat_damaged
				sound_fullflight_ext = ext.fullflight_damaged
				sound_fullflight_int = int.fullflight_damaged or ext.fullflight_damaged
			end

			local pos = net.ReadVector()
			if LocalPlayer():GetTardisData("exterior")==self then
				if (self:GetData("demat-fast",false))==true then
					self.interior:EmitSound(sound_fullflight_int)
					self:EmitSound(sound_fullflight_ext)
				else
					self.interior:EmitSound(sound_demat_int)
					self:EmitSound(sound_demat_ext)
				end
			else
				sound.Play(sound_demat_ext,self:GetPos())
				if pos and self:GetData("demat-fast",false) then
					if not IsValid(self) then return end
					if (self:GetData("demat-fast",false))==true then
						sound.Play(ext.mat_damaged, pos)
					else
						sound.Play(ext.mat, pos)
					end
				end
			end
		end
	end)

	ENT:OnMessage("failed-demat", function(self)
		if TARDIS:GetSetting("teleport-sound") and TARDIS:GetSetting("sound") then
			local ext = self.metadata.Exterior.Sounds.Teleport
			local int = self.metadata.Interior.Sounds.Teleport
			self:EmitSound(ext.demat_fail)
			self.interior:EmitSound(int.demat_fail or ext.demat_fail)
		end
		if LocalPlayer():GetTardisData("exterior") == self then
			util.ScreenShake(self.interior:GetPos(), 2.5, 100, 3, 300)
		end
	end)

	ENT:OnMessage("premat", function(self)
		self:SetData("teleport",true)
		if TARDIS:GetSetting("teleport-sound") and TARDIS:GetSetting("sound") then
			local ext = self.metadata.Exterior.Sounds.Teleport
			local int = self.metadata.Interior.Sounds.Teleport
			local pos=net.ReadVector()
			if LocalPlayer():GetTardisData("exterior")==self and (not self:GetData("demat-fast",false)) then
				if self:GetData("health-warning", false) then
					self:EmitSound(ext.mat_damaged)
					self.interior:EmitSound(int.mat_damaged or ext.mat_damaged)
				else
					self:EmitSound(ext.mat)
					self.interior:EmitSound(int.mat or ext.mat)
				end
			elseif not self:GetData("demat-fast",false) then
				if self:GetData("health-warning", false) then
					sound.Play(ext.mat_damaged,pos)
				else
					sound.Play(ext.mat,pos)
				end
			end
		end
	end)

	ENT:OnMessage("mat", function(self)
		self:SetData("mat",true)
		self:SetData("step",1)
		self:SetData("vortex",false)
	end)

	function ENT:StopDemat()
		self:SetData("demat",false)
		self:SetData("step",1)
		self:SetData("vortex",true)
		self:SetData("teleport",false)
		self:CallHook("StopDemat")
	end

	function ENT:StopMat()
		self:SetData("mat",false)
		self:SetData("step",1)
		self:SetData("teleport",false)
	end

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

	ENT:AddHook("PilotChanged","teleport",function(self,old,new)
		if self:GetData("teleport-trace") then
			self:SetData("teleport-trace",false)
		end
	end)

	local function rand_offset() return math.random(-35, 35) end

	local function get_effect_pos(self)
		local console = self.interior:GetPart("console")
		if self.metadata.Interior.BreakdownEffectPos then
			self.effect_pos = self.interior:GetPos() + self.metadata.Interior.BreakdownEffectPos
		elseif console and IsValid(console) then
			self.effect_pos = console:GetPos() + Vector(0, 0, 50)
		else
			self.effect_pos = self.interior:GetPos() + Vector(0, 0, 50)
		end
	end

	function ENT:InteriorExplosion()
		if self.effect_pos == nil then
			get_effect_pos(self)
		end

		local function rand_offset() return math.random(-40, 40) end

		local effect_data = EffectData()
		effect_data:SetOrigin(self.effect_pos + Vector(rand_offset(), rand_offset(), 0))

		util.Effect("Explosion", effect_data)
		util.Effect("cball_explode", effect_data)

		effect_data:SetScale(math.random(1,3))
		effect_data:SetMagnitude(math.random(3, 13))
		effect_data:SetRadius(math.random(1,5))
		util.Effect("Sparks", effect_data)
	end

	function ENT:InteriorSparks(power)
		if self.effect_pos == nil then
			get_effect_pos(self)
		end

		local effect_data = EffectData()
		effect_data:SetOrigin(self.effect_pos + Vector(rand_offset(), rand_offset(), 0))

		effect_data:SetScale(math.random(1,3) * power)
		effect_data:SetMagnitude(math.random(3, 15) * power)
		effect_data:SetRadius(math.random(1,5) * power)
		util.Effect("Sparks", effect_data)
		if power > 0.5 then util.Effect("cball_explode", effect_data) end
	end

	ENT:OnMessage("failed-demat", function(self)
		if TARDIS:GetSetting("teleport-sound") and TARDIS:GetSetting("sound") then
			local ext = self.metadata.Exterior.Sounds.Teleport
			local int = self.metadata.Interior.Sounds.Teleport
			self:EmitSound(ext.demat_fail)
			self.interior:EmitSound(int.demat_fail or ext.demat_fail)
		end
		if LocalPlayer():GetTardisData("exterior") == self then
			util.ScreenShake(self.interior:GetPos(), 2.5, 100, 3, 300)
		end
	end)
end

function ENT:GetTargetAlpha()
	local demat=self:GetData("demat")
	local mat=self:GetData("mat")
	local step=self:GetData("step",1)
	if demat and (not mat) then
		return self.metadata.Exterior.Teleport.DematSequence[step]
	elseif mat and (not demat) then
		return self.metadata.Exterior.Teleport.MatSequence[step]
	else
		return 255
	end
end

ENT:AddHook("Think","teleport",function(self,delta)
	local demat=self:GetData("demat")
	local mat=self:GetData("mat")
	if not (demat or mat) then return end
	local alpha=self:GetData("alpha",255)
	local target=self:GetData("alphatarget",255)
	local step=self:GetData("step",1)
	if alpha==target then
		if demat then
			if step>=#self.metadata.Exterior.Teleport.DematSequence then
				self:StopDemat()
				return
			else
				self:SetData("step",step+1)
			end
		elseif mat then
			if step>=#self.metadata.Exterior.Teleport.MatSequence then
				self:StopMat()
				return
			else
				self:SetData("step",step+1)
			end
		end
		target=self:GetTargetAlpha()
		self:SetData("alphatarget",target)
	end
	local sequencespeed = (self:GetData("demat-fast",false) and self.metadata.Exterior.Teleport.SequenceSpeedFast or self.metadata.Exterior.Teleport.SequenceSpeed)
	alpha=math.Approach(alpha,target,delta*66*sequencespeed)
	self:SetData("alpha",alpha)
	local attached=self:GetData("demat-attached")
	if attached then
		for k,v in pairs(attached) do
			if IsValid(k) then
				if not (v==0) then
					if not (k:GetRenderMode()==RENDERMODE_TRANSALPHA) then
						k:SetRenderMode(RENDERMODE_TRANSALPHA)
					end
					k:SetColor(ColorAlpha(k:GetColor(),alpha))
				end
			end
		end
	end
end)

ENT:AddHook("Think","failed-demat-stop",function(self)
	if self:GetData("failing-demat", false) then
		if CurTime() > self:GetData("failing-demat-time") + 2.5 then
			self:SetData("failing-demat", false, true)
		end
	end
end)

ENT:AddHook("Think","breakdown-effects", function(self)
	if self:GetData("force-demat", false) then
		local timediff = CurTime() - self:GetData("force-demat-time")

		local showeffects = (CLIENT and LocalPlayer():GetTardisData("exterior") == self
			and TARDIS:GetSetting("breakdown-effects", true, LocalPlayer()))

		if showeffects then
			local effpos

			if timediff > 0.5 and timediff < 0.6 then
				self:InteriorExplosion()
				util.ScreenShake(self.effect_pos, 10, 100, 10, 300)
			end

			if timediff > 1.2 and timediff < 1.3 then
				self:InteriorExplosion()
				self:SetData("interior-lights-blinking", true, true)
				self:SetData("force-demat-sparkling", true, false)
			end

			if self:GetData("force-demat-sparkling", false) then
				if math.Round(1.5 * CurTime()) % 2 == 0 then
					local power = 1.2 + math.random(1, 5) * 0.1
					power = power - math.max(0, timediff) * 0.1
					power = math.max(0, power)
					self:InteriorSparks(power)
				end
			end

			if self:GetData("force-demat-sparkling", false) and timediff > 6 then
				self:InteriorExplosion()
				self:SetData("force-demat-sparkling", false, false)
			end
		end

		if self:GetData("interior-lights-blinking", false) and timediff > 4 then
			local newhealth = self:GetHealth() * math.random(75, 95) * 0.01
			self:ChangeHealth(newhealth)
			if showeffects then self:InteriorExplosion() end
			self:SetData("interior-lights-blinking", false, true)
		end
	end
end)

ENT:AddHook("Think","interrupted-teleport", function(self)
	if self:GetData("teleport-interrupted", false) then
		local timediff = CurTime() - self:GetData("teleport-interrupt-time")

		if timediff > 6 and timediff < 6.2 and self:GetData("teleport-interrupt-effects", false) then
			self:SetData("teleport-interrupt-effects", false, true)
		end

		local showeffects = (CLIENT and self:GetData("teleport-interrupt-effects", false)
				and LocalPlayer():GetTardisData("exterior") == self
				and TARDIS:GetSetting("breakdown-effects", true, LocalPlayer()))

		if showeffects then
			if math.Round(10 * CurTime()) % 2 == 0 then
				self:InteriorSparks(1)
			end
			if timediff < 0.1 or (timediff > 2 and timediff < 2.1)
				or (timediff > 2.6 and timediff < 2.7)
			then
				self:InteriorExplosion()
			end
		end

		if timediff > 10 then
			self:SetData("teleport-interrupted", false, true)
		end
	end
end)

ENT:AddHook("CanTogglePower","interrupted-teleport", function(self)
	if self:GetData("teleport-interrupted", false) then
		return false
	end
end)
