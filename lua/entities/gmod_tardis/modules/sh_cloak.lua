-- Cloak


TARDIS:AddKeyBind("cloak-toggle",{
	name="Toggle",
	section="Cloak",
	func=function(self,down,ply)
		if ply == self.pilot and down then
			TARDIS:Control("cloak", ply)
		end
	end,
	key=KEY_L,
	serveronly=true,
	exterior=true
})

ENT:AddHook("Initialize", "cloak", function(self)
    self:SetData("cloak", false)

    self:SetData("modelmins", self:OBBMins())
	local maxs = self:OBBMaxs()
	maxs.z = maxs.z + 25
    self:SetData("modelmaxs", maxs)
    self:SetData("modelheight", (self:GetData("modelmaxs").z - self:GetData("modelmins").z))

    self:SetData("phase-percent",1)
end)

function ENT:GetCloak()
	return self:GetData("cloak",false)
end

if SERVER then
    function ENT:SetCloak(on)
		if self:CallHook("CanToggleCloak")==false then return false end
		self:SetData("cloak", on)
		self:SendMessage("cloak", function()
			net.WriteBool(on)
		end)
		if (not self:GetData("teleport")) and (not self:GetData("vortex")) then
			self:DrawShadow(not on)
		end
		return true
    end
    
    function ENT:ToggleCloak()
        local on = not self:GetData("cloak", false)
        return self:SetCloak(on)
    end

	ENT:AddHook("HandleE2", "cloak", function(self,name,e2)
		if name == "Phase" and TARDIS:CheckPP(e2.player, self) then
			return self:ToggleCloak() and 1 or 0
		elseif name == "GetVisible" then
			return self:GetData("cloak",false) and 0 or 1
		end
	end)

	ENT:AddHook("ShouldTurnOffRotorwash", "cloak", function(self)
		if self:GetData("cloak") then
			return true
		end
	end)

	ENT:AddHook("OnHealthDepleted", "cloak", function(self)
		if self:GetCloak() then
			self:SetCloak(false)
		end
	end)
else
    TARDIS:AddSetting({
        id = "cloaksound-enabled",
        name = "Cloak Sound",
        desc = "Toggles whether or not sounds play when TARDIS cloaking is toggled",
        section = "Sound",
        value = true,
        type = "bool",
        option = true
    })

	ENT:AddHook("Initialize", "cloak-material", function(self)
		self.PhaseMaterial = Material(self.metadata.Exterior.PhaseMaterial or "models/drmatt/tardis/exterior/phase_noise.vmt")
	end)

	ENT:AddHook("ShouldThinkFast", "cloak", function(self)
		if self:GetData("cloak-animating",false) then return true end
	end)

	ENT:AddHook("Think", "cloak", function(self)
		local target = self:GetData("cloak",false) and -0.5 or 1
		local animating = self:GetData("cloak-animating",false)
		local percent = self:GetData("phase-percent",1)
		if percent == target and animating then
			self:SetData("cloak-animating", false)
			return
		elseif percent ~= target and not animating then
			self:SetData("cloak-animating", true)
		end
	    local timepassed = CurTime() - self:GetData("phase-lastTick",CurTime())
	    self:SetData("phase-lastTick", CurTime())
        if self:GetData("cloak",false) then
            self:SetData("phase-percent", math.Approach(percent, target, 0.5 * timepassed))
        else
            self:SetData("phase-percent", math.Approach(percent, target, 0.5 * timepassed))
        end
        self:SetData("phase-highPercent", math.Clamp(self:GetData("phase-percent",1) + 0.5, 0, 1))

		local pos = self:GetPos() + self:GetUp() * (self:GetData("modelmaxs").z - (self:GetData("modelheight") * self:GetData("phase-highPercent",1)))
		local pos2 = self:GetPos() + self:GetUp() * (self:GetData("modelmaxs").z - (self:GetData("modelheight") * self:GetData("phase-percent",1)))

		self:SetData("phase-highPos", pos)
		self:SetData("phase-pos", pos2)
	end)

	local oldClip

	local function dodraw(self, ent)
		ent = ent or self
		local animating = self:GetData("cloak-animating",false)
		if animating and not wp.drawing then
			ent:SetRenderClipPlaneEnabled(true)
		else
			ent:SetRenderClipPlaneEnabled(false)
			return
		end
		oldClip = render.EnableClipping(true)
        local restoreT = ent:GetMaterial()

        local normal = self:GetUp()
        local pos = self:GetData("phase-highPos",Vector(0,0,0))
        local dist = normal:Dot(pos)

        local normal2 = self:GetUp() * -1
		local pos2 = self:GetData("phase-pos",Vector(0,0,0))
		local dist2 = normal2:Dot(pos2)

        ent:SetRenderClipPlane(normal, dist)

        render.PushCustomClipPlane(normal, dist)
		render.MaterialOverride(self.PhaseMaterial)
		
        render.PushCustomClipPlane(normal2, dist2)
			ent:DrawModel()
		render.PopCustomClipPlane()
		render.PopCustomClipPlane()
		
		render.MaterialOverride(restoreT)
	end

	local function postdraw()
		if not self:GetData("cloak-animating",false) then return end
		render.EnableClipping(oldClip)
	end

    ENT:AddHook("Draw", "cloak", dodraw)

	ENT:AddHook("PostDraw", "cloak", postdraw)

	ENT:AddHook("DrawPart", "cloak", function(self,part)
		if part.NoCloak~=true then
			dodraw(self,part)
		end
	end)

	ENT:AddHook("PostDrawPart", "ID", function(self,part)
		if part.NoCloak~=true then
			dodraw(self,part)
		end
	end)

	ENT:AddHook("ShouldTurnOffLight", "cloak", function(self)
		if self:GetData("cloak",false) then return true end
	end)

	ENT:AddHook("ShouldTurnOffFlightSound", "cloak", function(self)
		if self:GetData("cloak",false) then return true end
	end)

	ENT:AddHook("ShouldPlayDematSound", "cloak", function(self,interior)
		if self:GetData("cloak",false) and not interior then return false end
	end)

	ENT:AddHook("ShouldPlayMatSound", "cloak", function(self,interior)
		if self:GetData("cloak",false) and not interior then return false end
	end)

	ENT:AddHook("ShouldDraw", "cloak", function(self)
		if self:GetData("cloak",false) and not self:GetData("cloak-animating",false) then return false end
	end)

	ENT:OnMessage("cloak", function(self)
		local on = net.ReadBool()
		self:SetData("cloak", on)
		self:SetData("cloak-animating", true)
		local snd
		if on then
			snd = self.metadata.Exterior.Sounds.Cloak
		else
			snd = self.metadata.Exterior.Sounds.CloakOff
		end

		if TARDIS:GetSetting("cloaksound-enabled") and TARDIS:GetSetting("sound") then
			self:EmitSound(snd)

			if IsValid(self.interior) then
				self.interior:EmitSound(snd)
			end
		end
	end)
end