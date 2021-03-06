-- Physical Lock

TARDIS:AddKeyBind("physlock-toggle",{
	name="Physlock Toggle",
	section="Third Person",
	desc="Make the TARDIS constant and unmovable in space",
	func=function(self,down,ply)
		if ply==self.pilot and down then
			if self:TogglePhyslock() then
				ply:ChatPrint("Physlock "..(self:GetData("physlock") and "en" or "dis").."abled")
			end
		end
	end,
	key=KEY_G,
	serveronly=true,
	exterior=true
})

if SERVER then
	function ENT:SetPhyslock(on)
		if not on and self:CallHook("CanTurnOffPhyslock") == false then
			return false
		end
		if on and self:CallHook("CanTurnOnPhyslock") == false then
			return false
		end

		local phys = self:GetPhysicsObject()
		local vel = phys:GetVelocity():Length()
		if on then
			util.ScreenShake(self.interior:GetPos(), 1, 20, 0.3, 700)
			if vel > 1000 then
				self:Explode(math.max((vel - 2500) / 5, 0))
			end
		end
		if self:GetData("power-state") then
			self:SetData("physlock", on, true)
			phys:EnableMotion(not on)
		else
			self:SetData("physlock", false, true)
			phys:EnableMotion(true)
		end
		phys:Wake()
		return true
	end

	function ENT:TogglePhyslock()
		local on = not self:GetData("physlock", false)
		return self:SetPhyslock(on)
	end

	hook.Add("PlayerUnfrozeObject", "tardis-physlock", function(ply,ent,phys)
		if ent:GetClass()=="gmod_tardis" and ent:GetData("physlock",false)==true then 
			phys:EnableMotion(false) 
		end
	end)

	hook.Add("PhysgunDrop", "tardis-physlock", function(ply,ent)
		if ent:GetClass()=="gmod_tardis" and ent:GetData("physlock",false)==true then
			ent:GetPhysicsObject():EnableMotion(false)
		end
	end)

	ENT:AddHook("MatStart", "physlock", function(self)
		if not self:GetData("physlock",false) then
			self.phys:EnableMotion(true)
			self.phys:Wake()
		end
	end)

	ENT:AddHook("PowerToggled", "physlock", function(self,on)
		if on and self:GetData("power-lastphyslock", false) == true then
			self:SetPhyslock(true)
		else
			self:SetData("power-lastphyslock", self:GetData("physlock", false))
			self:SetPhyslock(false)
		end
	end)

	ENT:AddHook("CanTurnOnPhyslock", "physlock", function(self)
		if not self:GetData("power-state", false) then
			return false
		end
	end)
end

