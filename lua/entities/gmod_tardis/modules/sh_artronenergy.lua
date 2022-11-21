if SERVER then
    function ENT:ChangeArtron(setartron, add) -- Second one is for if you wanna add or set it.
        local currentArtron = self:GetData("artron-val")
        local maxArtron = TARDIS:GetSetting("artron_energy_max")
        if currentArtron == nil then  
            currentArtron = 0
        end
        if currentArtron + setartron > maxArtron then
            if setartron == maxArtron then
                return
            end
            currentArtron = 0
            setartron = maxArtron

        end  
        if currentArtron + setartron < 0 then
            if setartron == 0 then
                return
            end
            currentArtron = 0
            setartron = 0

        end  
        if add == false or add == nil then
            currentArtron = 0
        end
        self:SetData("artron-val", setartron + currentArtron, true)
    end

    local function passiveArtronPower(this)

        timer.Simple( 5, function() 
            if not IsValid(this.Entity) then 
                return 
            end
            if not this:GetData("vortex") and not this:GetData("teleport") and not this:GetData("flight") and this:GetData("power-state") and not this:GetData("cloak") then 
                this:ChangeArtron(50, true)
            end
            passiveArtronPower(this)
        end )

    end

    local function ArtronPowerOff(this)

        timer.Simple( 5, function() 
            if not IsValid(this.Entity) or this:GetData("power-state") then 
                return 
            end
            if this:GetData("artron-val") < TARDIS:GetSetting("artron_energy_max") then
                this:ChangeArtron(250, true)
            end
            ArtronPowerOff(this)

        end )

    end

    local function DematleechLoop(this)
        timer.Simple( 1, function() 
            if not IsValid(this.Entity) or not this:GetData("vortex") or not this:GetData("teleport") then 
                return 
            end
            this:ChangeArtron(-24, true)
            DematleechLoop(this)
        end )
    end

    local function FlyingLeechLoop(this)
        timer.Simple( 1, function() 
            if not IsValid(this.Entity) or not this:GetData("flight") then 
                return 
            end
            this:ChangeArtron(-25, true)
            FlyingLeechLoop(this)
        end )
    end

    local function CloakLeechLoop(this)
        timer.Simple( 1, function() 
            if not IsValid(this.Entity) or not this:GetData("cloak") then 
                return 
            end
            this:ChangeArtron(-20, true)
            CloakLeechLoop(this)
        end )
    end


    ENT:AddHook("Initialize","artron-init",function(self)
        if TARDIS:GetSetting("artron_energy_start_full") == true then
            self:ChangeArtron(TARDIS:GetSetting("artron_energy_max"), false)
        else
            self:ChangeArtron(100, false)
        end
        passiveArtronPower(self)

    end)


    ENT:AddHook("CanTurnOnFloat", "floatartron", function(self)
        self:ChangeArtron(-50, true)
    end)

    ENT:AddHook("DematStart", "dematartron", function(self)
        self:ChangeArtron(-500, true)
    end)

    ENT:AddHook("CanTogglePower", "artronpowertoggled", function(self, on)
        if self:GetData("artron-val") <= 0 and self:GetData("power-state") == false then
            return false
        end
    end)

    ENT:AddHook("PowerToggled", "artronpowertoggledafter", function(self, on)
        if self:GetData("power-state") == false then
            ArtronPowerOff(self)
        end
    end)

    ENT:AddHook("StopDemat", "artronpowervortexleech", function(self, on)
        DematleechLoop(self)
    end)

    ENT:AddHook("CanTurnOnFlight", "artronpowerflightleech", function(self, on)
        FlyingLeechLoop(self)
    end)

    ENT:AddHook("CanToggleCloak", "artronpowercloakleech", function(self, on)
        CloakLeechLoop(self)
    end)




    ENT:AddHook("Think", "thinkartrontardis", function(self)
        if  self:GetData("power-state") == true and self:GetData("artron-val") <= 0 then
            if self:GetData("cloak") == true then 
                self:SetCloak(false)
            end
            if self:GetData("floatfirst") == true then
                print("stop")
                self:ToggleFloat()
            end
            if self:GetData("flight") == true then
                self:SetFlight(false)
            end


            self:SetPower(false) -- Do all flight and cloak stuff before this because it wont work i think i dont remember -\_(o.o)_/-
            self:SetHandbrake(true)
            self:SetHandbrake(false)
            for k,_ in pairs(self.occupants) do
                TARDIS:ErrorMessage(k, "Artron Depleted.")
            end
        end

        --Timers n stuff (soon)






        
    end)
end

