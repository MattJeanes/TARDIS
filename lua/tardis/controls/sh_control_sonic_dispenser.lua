
function TARDIS:IsSonicInstalled()
    if SonicSD and file.Exists("autorun/sonicsd.lua", "LUA") then
        return true
    end
    return false
end

TARDIS:AddControl({
    id = "sonic_dispenser",
    int_func=function(self,ply)
        if TARDIS:IsSonicInstalled() then
            local currentWeapon = ply:GetActiveWeapon()
            if IsValid(currentWeapon) and currentWeapon:GetClass() == "swep_sonicsd" then
                TARDIS:ErrorMessage(ply, "Controls.SonicDispenser.AlreadyEquipped")
                return
            end
            if IsValid(ply:GetWeapon("swep_sonicsd")) then
                TARDIS:Message(ply, "Controls.SonicDispenser.Equipped")
            else
                ply:Give("swep_sonicsd")
                TARDIS:Message(ply, "Controls.SonicDispenser.Dispensed")
            end
            ply:SelectWeapon("swep_sonicsd")
        else
            TARDIS:ErrorMessage(ply, "Controls.SonicDispenser.MissingAddon")
        end
    end,
    power_independent = true,
    serveronly = true,
    screen_button = false,
    tip_text = "Controls.SonicDispenser.Tip",
})