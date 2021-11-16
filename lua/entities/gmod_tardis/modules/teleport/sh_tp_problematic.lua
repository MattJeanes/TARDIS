-- Failed teleport, interrupted teleport, effects

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

if SERVER then

	ENT:AddHook("FailDemat", "doors", function(self, force)
		if self:GetData("doorstatereal") and force ~= true
			and not TARDIS:GetSetting("teleport-door-autoclose", false, self:GetCreator())
		then
			return true
		end
	end)

	function ENT:ForceDemat(pos, ang, callback)
		self:SetData("force-demat", true, true)
		self:SetData("force-demat-time", CurTime(), true)
		self:Explode(30)
		self.interior:Explode(20)
		self:Demat(pos, ang, callback, true)
	end

	ENT:AddHook("OnHealthDepleted", "teleport", function(self)
		if self:GetData("teleport", false) or self:GetData("vortex", false) then
			self:InterruptTeleport()
		end
	end)

	function ENT:InterruptTeleport(callback)
		if not self:GetData("teleport", false) and not self:GetData("vortex", false) then return end
		local door_ok = true
		self:CloseDoor(function(state)
			if state then
				door_ok = false
			end
		end)

		if not door_ok then
			if callback then callback(false) end
			return
		end

		local pos, ang

		ang = self:GetAngles()
		if self:GetData("vortex", false) then
			pos = self:GetRandomLocation(false)
		else
			pos = self:GetPos()
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

		local was_demating = self:GetData("demat", false)
		self:SetData("demat", false, true)
		self:SetData("mat", false, true)
		self:SetData("teleport", false, true)
		self:SetData("vortex", false, true)
		self:SetData("step", 1, true)
		self:SetFlight(false)
		self:SetFloat(false)

		self:CallHook("InterruptTeleport")

		self:Explode()
		self.interior:Explode(20)
		if not was_demating then
			self:ChangeHealth(self:GetHealth() * math.random(85, 95) * 0.01)
			self:SetPower(false)
			self:SetData("teleport-interrupted", true, true)
			self:SetData("teleport-interrupt-time", CurTime(), true)
			self:SetData("teleport-interrupt-effects", true, true)
		end
	end

	ENT:AddHook("CanDemat", "failed", function(self, force, ignore_fail_demat)
		if ignore_fail_demat ~= true and self:CallHook("FailDemat", force) == true then
			return false
		end
	end)

	function ENT:EngineReleaseDemat(pos, ang, callback)
		if self:GetData("failing-demat", false) then
			self:SetData("failing-demat", false, true)
			if self:CallHook("FailDemat", false) == true then
				if not self:GetData("health-warning", false) then
					self:ForceDemat(pos, ang, callback)
				else
					self:SendMessage("engine-release-explode")
					self:TogglePower()
				end
			else
				self:Demat(pos, ang, callback, false)
			end
		end
	end

	ENT:AddHook("ToggleDoor", "failing-demat", function(self,open)
		if self:GetData("failing-demat", false) then
			if not open then
				self:SetData("failing-demat", false, true)
				local pos = pos or self:GetData("demat-pos") or self:GetPos()
				local ang = ang or self:GetData("demat-ang") or self:GetAngles()
				self:Demat(pos, ang, nil, false)
			end
		end
	end)

else
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

	ENT:OnMessage("engine-release-explode", function(self)
		self:InteriorExplosion()
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

		effect_data:SetScale(0.5)
		effect_data:SetMagnitude(math.random(3, 5))
		effect_data:SetRadius(math.random(1,5))
		util.Effect("ElectricSpark", effect_data)
	end

	function ENT:InteriorSparks(power)
		if self.effect_pos == nil then
			get_effect_pos(self)
		end

		local effect_data = EffectData()
		effect_data:SetOrigin(self.effect_pos + Vector(rand_offset(), rand_offset(), 0))

		effect_data:SetScale(power)
		effect_data:SetMagnitude(math.random(3, 5) * power)
		effect_data:SetRadius(math.random(1,5) * power)
		util.Effect("ElectricSpark", effect_data)
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
			and (not LocalPlayer():GetTardisData("thirdperson"))
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
				and (not LocalPlayer():GetTardisData("thirdperson"))
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
