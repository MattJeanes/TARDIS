if SERVER then

    local artron_values = {
        cost_demat = -540,
        cost_mat = -180,
        cost_full = -1200,
        cost_controls = {
            ["cloak"] = -720,
            ["physlock"] = -540,
            ["float"] = -540,
        },
        cost_hads = -180,
        cost_failed_demat = -80,

        -- every 1 second:
        spend_vortex_teleport = -32,
        spend_flight = -45,
        spend_flight_boost = -45,
        spend_cloak = -36,
        spend_cloak_handbrake = -12,

        -- every 5 seconds:
        increase_handbrake = 180 * 5,
        increase_normal = 15 * 5,
        increase_warning = 10 * 5,
        increase_poweroff = 24 * 5,
        increase_float = 8 * 5,
        increase_float_handbrake = 40 * 5,
    }

    function ENT:SetArtron(value)
        local maxArtron = TARDIS:GetSetting("artron_energy_max")
        value = math.max(0, math.min(value, maxArtron))
        self:SetData("artron-val", value, true)
        if value == 0 then
            self:CallHook("ArtronDepleted")
        end
        tardisdebug(value)
    end

    function ENT:AddArtron(value)
        local currentArtron = self:GetData("artron-val", 0)
        self:SetArtron(currentArtron + value)
    end

    ENT:AddHook("Initialize", "artron", function(self)
        local max = TARDIS:GetSetting("artron_energy_max")
        local start = TARDIS:GetSetting("artron_energy_start") -- 0, 0.25, 0.5, 0.75 or 1
        self:SetArtron(max * start)
    end)


    --
    -- Bad artron consequences
    --

    ENT:AddHook("ArtronDepleted", "teleport_and_poweroff", function(self)
        if not TARDIS:GetSetting("artron_energy") then return end

        if self:GetData("teleport") or self:GetData("vortex") then
            self:InterruptTeleport()
            return
        end
        if self:GetPower() then
            if self:GetData("flight") then
                self:SetData("floatfirst", true)
            end
            self:SetPower(false)
            for k,_ in pairs(self.occupants) do
                TARDIS:ErrorMessage(k, "Artron Depleted.")
            end
        end
    end)

    local function ArtronDematCheck(self)
        local fast = self:GetData("demat-fast", false)
        local artron = self:GetData("artron-val", 0)

        if self:CallHook("ShouldUpdateArtron") == false then return end
        if self:GetData("hads-triggered", false) then return end

        if fast and artron < -artron_values.cost_full then
            return true
        end
        if not fast and artron < -artron_values.cost_demat then
            return true
        end
    end

    ENT:AddHook("ShouldFailDemat", "artron", function(self, force)
        if not TARDIS:GetSetting("artron_energy") then return end
        if self:GetData("hads-attempt") then return end

        if ArtronDematCheck(self) == true then
            return true
        end
    end)

    ENT:AddHook("CanTogglePower", "artron", function(self, on)
        if not TARDIS:GetSetting("artron_energy") then return end

        if self:GetData("artron-val") <= 0 and self:GetPower() == false then
            return false
        end
    end)



    --
    -- Decreasing artron energy
    --

    ENT:AddHook("Think", "artron", function(self)
        if not TARDIS:GetSetting("artron_energy") then return end

        if self:CallHook("ShouldUpdateArtron") == false then return end

        -- if artron energy should decrease, it happens every second
        if CurTime() < self:GetData("artron_next_update_time", 0) then return end
        self:SetData("artron_next_update_time", CurTime() + 1)

        local power = self:GetPower()
        local vortex = self:GetData("vortex")
        local teleport = self:GetData("teleport")
        local flight = self:GetData("flight")
        local handbrake = self:GetData("handbrake")
        local cloak = self:GetCloak()
        local float = self:GetData("floatfirst")
        local warning = self:GetData("health-warning")

        local change = 0

        if vortex or teleport then
            change = change + artron_values.spend_vortex_teleport
        elseif flight then
            if TARDIS:IsBindDown(self.pilot,"flight-boost") then
                change = change + artron_values.spend_flight_boost
            end
            change = change + artron_values.spend_flight
        end
        if cloak then
            if handbrake then
                change = change + artron_values.spend_cloak_handbrake
            else
                change = change + artron_values.spend_cloak
            end
        end

        if change < 0 then
            self:AddArtron(change)
            return
        end

        -- if artron energy is charging, it happens every 5 seconds
        if self:CallHook("CanIncreaseArtron") == false then return end
        if CurTime() < self:GetData("artron_next_increase_time", 0) then return end
        self:SetData("artron_next_increase_time", CurTime() + 5)

        if handbrake and float then
            self:AddArtron(artron_values.increase_float_handbrake)
            return
        end
        if handbrake then
            self:AddArtron(artron_values.increase_handbrake)
            return
        end
        if not power then
            self:AddArtron(artron_values.increase_poweroff)
            return
        end
        if float then
            self:AddArtron(artron_values.increase_float)
            return
        end
        if warning then
            self:AddArtron(artron_values.increase_warning)
            return
        end
        self:AddArtron(artron_values.increase_normal) -- default state
    end)

    ENT:AddHook("TardisControlUsed", "artron", function(self, control)
        if not TARDIS:GetSetting("artron_energy") then return end

        if artron_values.cost_controls[control] then
            self:AddArtron(artron_values.cost_controls[control])
        end
    end)

    ENT:AddHook("HandleNoDemat", "artron", function(self)
        if not TARDIS:GetSetting("artron_energy") then return end

        if ArtronDematCheck(self) == true then return end
        self:AddArtron(artron_values.cost_failed_demat)
    end)

    ENT:AddHook("DematStart", "artron", function(self)
        if not TARDIS:GetSetting("artron_energy") then return end
        if self:CallHook("ShouldUpdateArtron") == false then return end

        if self:GetData("demat-fast", false) then
            self:AddArtron(artron_values.cost_full)
        else
            self:AddArtron(artron_values.cost_demat)
        end
    end)

    ENT:AddHook("MatStart", "artron", function(self)
        if not TARDIS:GetSetting("artron_energy") then return end
        if self:CallHook("ShouldUpdateArtron") == false then return end

        if self:GetData("demat-fast",false) ~= true then
            self:AddArtron(artron_values.cost_mat)
        end
    end)

    ENT:AddHook("HADSTrigger", "artron", function(self)
        if not TARDIS:GetSetting("artron_energy") then return end

        if self:GetData("artron-val",0) < -artron_values.cost_hads then
            self:SetArtron(1)
            return
        end
        self:AddArtron(artron_values.cost_hads)
    end)




    --
    -- Conditions for artron changing
    --

    ENT:AddHook("CanIncreaseArtron", "interrupt-cooldown", function(self)
        if self:GetData("teleport-interrupted") then
            return false
        end
    end)

    ENT:AddHook("ShouldUpdateArtron", "repair", function(self)
        if self:GetData("repair-primed") or self:GetData("repairing") then
            return false
        end
    end)

    ENT:AddHook("ShouldUpdateArtron", "redecoration", function(self)
        if self:GetData("redecorate") or self:GetData("redecorate_parent")
            or self:GetData("redecorate_child")
        then
            return false
        end
    end)

    ENT:AddHook("ShouldUpdateArtron", "hads", function(self)
        if self:GetData("hads-triggered")
            or self:GetData("hads-need-remat")
            or self:GetData("hads-auto-remat")
        then
            return false
        end
    end)

    ENT:AddHook("SettingChanged", "maxartron-changed", function(self, id, val)
        if id ~= "artron_energy_max" then return end

        if self:GetData("artron-val",0) > val then
            self:SetArtron(val)
        end
    end)
end

