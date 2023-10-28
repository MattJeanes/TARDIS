-- Various effects for the TARDIS (smoke, sparks, explosions)

if SERVER then
    function ENT:Explode(f)
        local force = 60
        if f ~= nil then
            force = tostring(f)
        end
        local explode = ents.Create("env_explosion")
        explode:SetPos( self:LocalToWorld(Vector(0,0,50)) )
        explode:SetOwner( self )
        explode:Spawn()
        explode:SetKeyValue("iMagnitude", force)
        explode:Fire("Explode", 0, 0 )
    end

	ENT:AddHook("Think", "smoke", function(self)
        if self:CallHook("ShouldStartSmoke") and self:CallHook("ShouldStopSmoke")~=true then
            if self.smoke then return end
            self:StartSmoke()
        else
            self:StopSmoke()
        end
    end)

    ENT:AddHook("Think", "fire", function(self)
        if self:CallHook("ShouldStartFire") and self:CallHook("ShouldStopFire")~=true then
            if self.fire then return end
            self:StartFire()
        else
            self:StopFire()
        end
    end)

    ENT:AddHook("Think", "RemoveSmoke", function(self)
        local smokedelay = self:GetData("smoke-killdelay")
        if smokedelay ~= nil and CurTime() >= smokedelay then
            if IsValid(self.smoke) then
                self.smoke:Remove()
                self.smoke = nil
                self:SetData("smoke-killdelay",nil)
            end
        end
    end)

    ENT:AddHook("ShouldStartSmoke", "health-warning", function(self)
        if self:GetData("health-warning",false) then
            return true
        end
    end)

    ENT:AddHook("ShouldStartFire", "health-warning", function(self)
        if self:IsBroken() and self:GetData("flight") then
            return true
        end
    end)

    function ENT:StartSmoke()
        local smoke = ents.Create("env_smokestack")
        smoke:SetPos(self:LocalToWorld(Vector(0,0,80)))
        smoke:SetAngles(self:GetAngles()+Angle(-90,0,0))
        smoke:SetKeyValue("InitialState", "1")
        smoke:SetKeyValue("WindAngle", "0 0 0")
        smoke:SetKeyValue("WindSpeed", "0")
        smoke:SetKeyValue("rendercolor", "50 50 50")
        smoke:SetKeyValue("renderamt", "70")
        smoke:SetKeyValue("SmokeMaterial", "particle/smokesprites_0001.vmt")
        smoke:SetKeyValue("BaseSpread", "5")
        smoke:SetKeyValue("SpreadSpeed", "10")
        smoke:SetKeyValue("Speed", "50")
        smoke:SetKeyValue("StartSize", "60")
        smoke:SetKeyValue("EndSize", "140")
        smoke:SetKeyValue("roll", "20")
        smoke:SetKeyValue("Rate", "25")
        smoke:SetKeyValue("JetLength", "100")
        smoke:SetKeyValue("twist", "5")
        smoke:Spawn()
        smoke:SetParent(self)
        smoke:Activate()
        self.smoke=smoke
    end

    function ENT:StopSmoke()
        if IsValid(self.smoke) and self:GetData("smoke-killdelay")==nil then
            self.smoke:Fire("TurnOff")
            local jetlength = self.smoke:GetInternalVariable("JetLength")
            local speed = self.smoke:GetInternalVariable("Speed")
            self:SetData("smoke-killdelay",CurTime()+(speed/jetlength)*5)
        end
    end

    function ENT:StartFire()
        self.fire = ents.Create("env_fire_trail")
        self.fire:SetPos(self:LocalToWorld(Vector(0,0,50)))
        self.fire:SetColor(Color(0,0,0,12))
        self.fire:Spawn()
        self.fire:SetParent(self)
    end

    function ENT:StopFire()
        if IsValid(self.fire) then
            self.fire:Remove()
            self.fire=nil
        end
    end

    -- Rotorwash

    function ENT:CreateRotorWash()
        if IsValid(self.rotorwash) then return end
        self.rotorwash = ents.Create("env_rotorwash_emitter")
        self.rotorwash:SetPos(self:GetPos())
        self.rotorwash:SetParent(self)
        self.rotorwash:Activate()
    end

    function ENT:RemoveRotorWash()
        if IsValid(self.rotorwash) then
            self.rotorwash:Remove()
            self.rotorwash=nil
        end
    end

    ENT:AddHook("Think", "rotorwash", function(self)
        local shouldon=self:CallHook("ShouldTurnOnRotorwash")
        local shouldoff=self:CallHook("ShouldTurnOffRotorwash")

        if shouldon and (not shouldoff) then
            if not self.rotorwash then
                self:CreateRotorWash()
            end
        elseif self.rotorwash then
            self:RemoveRotorWash()
        end
    end)

else -- CLIENT
	local function rand_offset(x)
		return math.random(-x, x)
	end

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

		local effect_data = EffectData()
		effect_data:SetOrigin(self.effect_pos + Vector(rand_offset(40), rand_offset(40), 0))

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
		effect_data:SetOrigin(self.effect_pos + Vector(rand_offset(35), rand_offset(35), 0))

		effect_data:SetScale(power)
		effect_data:SetMagnitude(math.random(3, 5) * power)
		effect_data:SetRadius(math.random(1,5) * power)
		util.Effect("ElectricSpark", effect_data)
	end

	function ENT:ExteriorSparks(power)
		local effect_data = EffectData()
		effect_data:SetOrigin(self:GetPos())

		effect_data:SetScale(power)
		effect_data:SetMagnitude(math.random(3, 5) * power)
		effect_data:SetRadius(math.random(10,15) * power)
		util.Effect("ElectricSpark", effect_data)
	end
end