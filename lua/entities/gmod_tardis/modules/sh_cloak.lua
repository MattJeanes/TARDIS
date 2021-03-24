-- Placeholder cloak module (currently only for E2 and control presets, feel free to delete later)

TARDIS:AddControl({
	id = "cloak",
	ext_func=function(self,ply)
		self:ToggleCloak()
	end,
	serveronly=true,
	screen_button = {
		virt_console = true, -- change to true to add
		mmenu = false,
		toggle = true,
		frame_type = {0, 2},
		text = "Cloaking",
		pressed_state_from_interior = false,
		pressed_state_data = "cloak", -- can be changed
		order = 12,
	},
	tip_text = "Cloaking Device",
})


TARDIS:AddKeyBind("cloak-toggle",{
	name="Toggle",
	section="Cloak",
	func=function(self,down,ply)
		if ply == self.pilot and down then
			self:ToggleCloak()
		end
	end,
	key=KEY_L,
	serveronly=true,
	exterior=true	
})

ENT:AddHook("Initialize", "cloak", function(self)
    self:SetData("cloak", false, true)

	if CLIENT then
		self.cloakmat = TARDIS:GetCloakMaterial(self.metadata.ID)
	end

    self:SetData("modelmins", self:OBBMins())
    self:SetData("modelmaxs", self:OBBMaxs())
    self:SetData("modelheight", (self:GetData("modelmaxs").z - self:GetData("modelmins").z))

    self:SetData("phase-percent",1)

    -- For animating with math.approach
    self.LastThink = 0
end)

if SERVER then
    function ENT:SetCloak(on)
        if on then
            self:SendMessage("cloaksound")
        end

        return self:SetData("cloak", on, true)
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

	ENT:AddHook("Think", "cloak", function(self)
	    local timepassed = CurTime() - self:GetData("phase-lastTick",CurTime())
	    self:SetData("phase-lastTick", CurTime())
		local percent = self:GetData("phase-percent",1)
        if self:GetData("cloak",false) then
            self:SetData("phase-percent", math.Approach(percent, -0.5, 0.5 * timepassed))
        else
            self:SetData("phase-percent", math.Approach(percent, 1, 0.5 * timepassed))
        end
        self:SetData("phase-highPercent", math.Clamp(self:GetData("phase-percent",1) + 0.5, 0, 1))

		local pos = self:GetPos() + self:GetUp() * (self:GetData("modelmaxs").z - (self:GetData("modelheight") * self:GetData("phase-highPercent",1)))
		local pos2 = self:GetPos() + self:GetUp() * (self:GetData("modelmaxs").z - (self:GetData("modelheight") * self:GetData("phase-percent",1)))

		self:SetData("phase-highPos", pos)
		self:SetData("phase-pos", pos2)
	end)

	local oldClip

    ENT:AddHook("Draw", "cloak", function(self)
        -- Plane clipping, for animating the invisible effect
        local normal = self:GetUp()
        local pos = self:GetData("phase-highPos",Vector(0,0,0))
        local dist = normal:Dot(pos)
		
        self:SetRenderClipPlaneEnabled(true)
        self:SetRenderClipPlane(normal, dist)
		
        --[[doors:SetRenderClipPlaneEnabled(true)
        doors:SetRenderClipPlane(normal, dist)]]
		
        oldClip = render.EnableClipping(true)
        local restoreT = self:GetMaterial()

        render.MaterialOverride(self.cloakmat)
        render.PushCustomClipPlane(normal, dist)
		
        normal = self:GetUp()
        dist = normal:Dot(pos)
		

        local normal2 = self:GetUp() * -1
		local pos2 = self:GetData("phase-pos",Vector(0,0,0))
		local dist2 = normal2:Dot(pos2)
		
        render.PushCustomClipPlane(normal2, dist2)
			self:DrawModel()
		render.PopCustomClipPlane()
		render.PopCustomClipPlane()
		
		render.MaterialOverride(restoreT)
    end)

	ENT:AddHook("PostDraw", "cloak", function(self)
		render.EnableClipping(oldClip)
	end)

	local oldClipPart

	ENT:AddHook("DrawPart", "cloak", function(self,part)
		if part.ExteriorPart and part.ID ~= "vortex" then
			local normal = self:GetUp()
			local pos = self:GetData("phase-highPos",Vector(0,0,0))
			local dist = normal:Dot(pos)

			part:SetRenderClipPlaneEnabled(true)
			part:SetRenderClipPlane(normal, dist)

			oldClipPart = render.EnableClipping(true)
			local restoreT = part:GetMaterial()
	
			render.MaterialOverride(self.cloakmat)
			render.PushCustomClipPlane(normal, dist)

			local normal2 = self:GetUp() * -1
			local pos2 = self:GetData("phase-pos",Vector(0,0,0))
			local dist2 = normal2:Dot(pos2)
			
			render.PushCustomClipPlane(normal2, dist2)
				part:DrawModel()
			render.PopCustomClipPlane()
			render.PopCustomClipPlane()
			
			render.MaterialOverride(restoreT)
		end
	end)

	ENT:AddHook("PostDrawPart", "ID", function(self)
		render.EnableClipping(oldClipPart)
	end)

	ENT:AddHook("ShouldTurnOffLight", "cloak", function(self)
		if self:GetData("cloak",false) then return true end
	end)

	ENT:AddHook("ShouldTurnOffFlightSound", "cloak", function(self)
		if self:GetData("cloak",false) then return true end
	end)

    ENT:OnMessage("cloaksound", function(self)
        local snd = self.metadata.Exterior.Sounds.Cloak

        if TARDIS:GetSetting("cloaksound-enabled") && TARDIS:GetSetting("sound") then
            self:EmitSound(snd)

            if IsValid(self.interior) then
                self.interior:EmitSound(snd)
            end
        end
    end)
end