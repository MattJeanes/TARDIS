if SERVER then
    function ENT:SetArtron(value)
        local maxArtron = TARDIS:GetSetting("artron_energy_max")
        value = math.max(0, math.min(value, maxArtron))
        self:SetData("artron-val", value, true)
        if value == 0 then
            self:CallHook("ArtronDepleted")
        end
    end

    function ENT:AddArtron(value)
        local currentArtron = self:GetData("artron-val", 0)
        self:SetArtron(currentArtron + value)
    end

    ENT:AddHook("Initialize", "artron_energy", function(self)
        local artron = 100
        if TARDIS:GetSetting("artron_energy_start_full") == true then
            self:SetArtron(TARDIS:GetSetting("artron_energy_max"))
        end
        self:SetArtron(artron)
        passiveArtronPower(self)
    end)

    ENT:AddHook("ArtronDepleted", "poweroff", function(self)
        if self:GetPower() then
            if self:GetData("cloak") == true then 
                self:SetCloak(false)
            end
            if self:GetData("floatfirst") == true then
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
    end)





    local function passiveArtronPower(this)

        timer.Simple(5, function() 
            if not IsValid(this.Entity) then return end
            local vortex = this:GetData("vortex")
            local teleport = this:GetData("teleport")
            local flight = this:GetData("flight")
            local power = this:GetData("power-state")
            local cloak = this:GetData("cloak")
            if not vortex and not teleport and not flight and power and not cloak then 
                this:AddArtron(50)
            end
            passiveArtronPower(this)
        end)
    end

    local function ArtronPowerOff(this)
        timer.Simple(5, function() 
            if not IsValid(this.Entity) or this:GetPower() then return end
            if this:GetData("artron-val") < TARDIS:GetSetting("artron_energy_max") then
                this:AddArtron(250)
            end
            ArtronPowerOff(this)
        end)
    end

    local function DematleechLoop(this)
        timer.Simple( 1, function()
            if not IsValid(this.Entity) or not this:GetData("vortex") or not this:GetData("teleport") then 
                return
            end
            this:AddArtron(-24)
            DematleechLoop(this)
        end )
    end

    local function FlyingLeechLoop(this)
        timer.Simple( 1, function() 
            if not IsValid(this.Entity) or not this:GetData("flight") then 
                return 
            end
            this:AddArtron(-25)
            FlyingLeechLoop(this)
        end )
    end

    local function CloakLeechLoop(this)
        timer.Simple( 1, function() 
            if not IsValid(this.Entity) or not this:GetData("cloak") then 
                return 
            end
            this:AddArtron(-20)
            CloakLeechLoop(this)
        end )
    end

    ENT:AddHook("CanTurnOnFloat", "floatartron", function(self)
        self:AddArtron(-50)
    end)

    ENT:AddHook("DematStart", "dematartron", function(self)
        self:AddArtron(-500)
    end)

    ENT:AddHook("CanTogglePower", "artronpowertoggled", function(self, on)
        if self:GetData("artron-val") <= 0 and self:GetData("power-state") == false then
            return false
        end
    end)

    ENT:AddHook("PowerToggled", "artronpowertoggledafter", function(self, on)
        if on == false then
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
else

    hook.Add("HUDPaint", "TARDIS-HUD2", function()
        if not TARDIS:GetSetting("health-enabled") then return end
        if not (LocalPlayer():GetTardisData("interior") or LocalPlayer():GetTardisData("exterior")) then return end
        local tardis = LocalPlayer():GetTardisData("exterior")
        if not IsValid(tardis) then return end
        local sw = ScrW()
        local sh = ScrH()
        local val = tardis:GetData("artron-val", 0)
        local percent = val * 100 / TARDIS:GetSetting("artron_energy_max")
        local health = math.ceil(percent)

        local width = 115
        if health >= 10 then width = width + 10 end
        if health == 100 then width = width + 35 end
        local height = (sw >= 800) and 120 or 95
        local healthfont = (height == 120) and "TARDIS-HUD-Large" or "TARDIS-HUD-Med"
        local x = (ScrW()-width)*0.02
        local y = (ScrH()-height)*0.025
        draw.RoundedBox( 10, x + 190, y, width, height, NamedColor("BgColor") )
        local textcolor
        local textcolor = (health > 0) and NamedColor("FgColor") or NamedColor("Caution")
        if (health > 20) then textcolor = NamedColor("FgColor")
        else textcolor = NamedColor("Caution") end
        draw.DrawText( TARDIS:GetPhrase("ARTRON"), "TARDIS-HUD-Small", x+200, y+10, textcolor, TEXT_ALIGN_LEFT )
        draw.DrawText( tostring(health) .. "%", healthfont, x+200, y+45, textcolor, TEXT_ALIGN_LEFT )
    end)

    list.Set("DesktopWindows", "TardisHUD2", {
        title = "TARDIS",
        icon = "materials/vgui/tardis_context_menu.png",
        init = function()
            local ext = LocalPlayer():GetTardisData("exterior")
            if IsValid(ext) then
                TARDIS:HUDScreen()
            else
                TARDIS:ErrorMessage(LocalPlayer(), "Common.NotInTARDIS")
            end
        end
    })

end

