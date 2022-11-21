if SERVER then

    local artron_values = {
        initial_value = 100,

        cost_demat = -500,
        cost_enable_float = -50,
        cost_disable_float = -25,

        -- every 1 second:
        spend_vortex_teleport = -24,
        spend_flight = -25,
        spend_cloak = -20,

        -- every 5 seconds:
        charge_handbrake = 400,
        charge_poweroff = 250,
        charge_normal = 50,
        charge_float = 20,
    }

    function ENT:SetArtron(value)
        local maxArtron = TARDIS:GetSetting("artron_energy_max")
        value = math.max(0, math.min(value, maxArtron))
        self:SetData("artron-val", value, true)
        if value == 0 then
            self:CallHook("ArtronDepleted")
        end
        tardisdebug("ARTRON: ", value)
    end

    function ENT:AddArtron(value)
        local currentArtron = self:GetData("artron-val", 0)
        self:SetArtron(currentArtron + value)
    end

    ENT:AddHook("Initialize", "artron", function(self)
        local artron = artron_values.initial_value
        if TARDIS:GetSetting("artron_energy_start_full") == true then
            self:SetArtron(TARDIS:GetSetting("artron_energy_max"))
        end
        self:SetArtron(artron)
    end)

    ENT:AddHook("ArtronDepleted", "poweroff", function(self)
        if self:GetPower() then
            self:SetPower(false)
            for k,_ in pairs(self.occupants) do
                TARDIS:ErrorMessage(k, "Artron Depleted.")
            end
        end
    end)

    ENT:AddHook("ArtronDepleted", "teleport", function(self)
        if self:GetData("teleport") or self:GetData("vortex") then
            self:InterruptTeleport()
        end
    end)

    ENT:AddHook("ArtronDepleted", "cloak", function(self)
        if self:GetCloak() then
            self:SetCloak(false)
        end
    end)

    ENT:AddHook("Think", "artron", function(self)
        if not TARDIS:GetSetting("artron_energy") then return false end

        -- if artron energy should decrease, it happens every second
        if CurTime() < self:GetData("artron_next_decrease_time", 0) then return end
        self:SetData("artron_next_decrease_time", CurTime() + 1)

        local power = self:GetPower()
        local vortex = self:GetData("vortex")
        local teleport = self:GetData("teleport")
        local flight = self:GetData("flight")
        local handbrake = self:GetData("handbrake")
        local cloak = self:GetCloak()
        local float = self:GetData("floatfirst")

        local change = 0

        if vortex or teleport then
            change = change + artron_values.spend_vortex_teleport
        end
        if flight then
            change = change + artron_values.spend_flight
        end
        if cloak then
            change = change + artron_values.spend_cloak
        end

        if change < 0 then
            self:AddArtron(change)
            return
        end

        -- if artron energy is charging, it happens every 5 seconds
        if CurTime() < self:GetData("artron_next_charge_time", 0) then return end
        self:SetData("artron_next_charge_time", CurTime() + 5)

        if handbrake then
            self:AddArtron(artron_values.charge_handbrake)
            return
        end
        if not power then
            self:AddArtron(artron_values.charge_poweroff)
            return
        end
        if float then
            self:AddArtron(artron_values.change_float)
            return
        end

        self:AddArtron(artron_values.charge_normal) -- default state
    end)

    ENT:AddHook("FloatToggled", "artron", function(self, on)
        if on then
            self:AddArtron(artron_values.cost_enable_float)
        else
            self:AddArtron(artron_values.cost_disable_float)
        end
    end)

    ENT:AddHook("DematStart", "artron", function(self)
        self:AddArtron(artron_values.cost_demat)
    end)

    ENT:AddHook("CanTogglePower", "artron", function(self, on)
        if self:GetData("artron-val") <= 0 and self:GetPower() == false then
            return false
        end
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

        local textcolor = (health > 0) and NamedColor("FgColor") or NamedColor("Caution")
        if (health > 20) then
            textcolor = NamedColor("FgColor")
        else
            textcolor = NamedColor("Caution")
        end

        draw.DrawText( TARDIS:GetPhrase("ARTRON"), "TARDIS-HUD-Small", x+200, y+10, textcolor, TEXT_ALIGN_LEFT )
        draw.DrawText( tostring(health) .. "%", healthfont, x+200, y+45, textcolor, TEXT_ALIGN_LEFT )
    end)

end

