TARDIS:AddSetting({
    id="artron-val",
    type="integer",
    value=1000,
    min=1,
    max=10000,
    round_func = function(x)
        if x < 50 then return x end
        if x < 500 then return (x - x % 10) end
        if x < 2000 then return (x - x % 100) end
        return (x - x % 500)
    end,

    class="global",
    convar = {
        name = "tardis2_artronenergy",
        flags = CONVAR_FLAGS,
        desc = "TARDIS - Artron Energy",
    },

    option = true,
    section=SETTING_SECTION,
    name="MaxHealth",
})
if SERVER then

local function passiveArtronPower(this)

    timer.Simple( 5, function() 
        if not IsValid(this.Entity) then 
            return 
        end
        if not this:GetData("vortex") and not this:GetData("teleport") and not this:GetData("flight") and this:GetData("power-state") and not this:GetData("cloak") then 
            if this:GetData("artron-val") < GetConVar("te_maxartronenergy"):GetInt() then
                this:SetData("artron-val", this:GetData("artron-val") + 50, true)
            end
            if this:GetData("artron-val") > GetConVar("te_maxartronenergy"):GetInt() then
                this:SetData("artron-val", GetConVar("te_maxartronenergy"):GetInt())
            end
        end
        passiveArtronPower(this)
        checkTardisArtron(this)
    end )

end

local function ArtronPowerOff(this)

    timer.Simple( 5, function() 
        if not IsValid(this.Entity) or this:GetData("power-state") then 
            return 
        end
        if this:GetData("artron-val") < GetConVar("te_maxartronenergy"):GetInt() then
            this:SetData("artron-val", this:GetData("artron-val") + 250, true)
        end
        ArtronPowerOff(this)
        checkTardisArtron(this)

    end )

end

local function DematleechLoop(this)
    timer.Simple( 1, function() 
        if not IsValid(this.Entity) or not this:GetData("vortex") or not this:GetData("teleport") then 
            return 
        end
        this:SetData("artron-val", this:GetData("artron-val") - 24, true)
        if this:GetData("artron-val") < 0 then
            this:SetData("artron-val", 0)
        end
        DematleechLoop(this)
    end )
end

local function FlyingLeechLoop(this)
    timer.Simple( 1, function() 
        if not IsValid(this.Entity) or not this:GetData("flight") then 
            return 
        end
        this:SetData("artron-val", this:GetData("artron-val") - 25, true)
        if this:GetData("artron-val") < 0 then
            this:SetData("artron-val", 0)
        end
        FlyingLeechLoop(this)
    end )
end

local function CloakLeechLoop(this)
    timer.Simple( 1, function() 
        if not IsValid(this.Entity) or not this:GetData("cloak") then 
            return 
        end
        this:SetData("artron-val", this:GetData("artron-val") - 25, true)
        if this:GetData("artron-val") < 0 then
            this:SetData("artron-val", 0)
        end
        CloakLeechLoop(this)
    end )
end


ENT:AddHook("Initialize","artron-init",function(self)
    if GetConVar("te_startwithmaxenergy"):GetBool() == true then
        self:SetData("artron-val", GetConVar("te_maxartronenergy"):GetInt(), true)
    else
        self:SetData("artron-val", 500, true)
    end
    passiveArtronPower(self)

end)


ENT:AddHook("CanTurnOnFloat", "floatartron", function(self)
    self:SetData("artron-val", self:GetData("artron-val") - 50, true)
    checkTardisArtron(self)
end)

ENT:AddHook("CanDemat", "dematartron", function(self)
    self:SetData("artron-val", self:GetData("artron-val") - 500, true)
    checkTardisArtron(self)
    if self:GetData("artron-val") <= 0 then
        return false
    end
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

function checkTardisArtron(this)
    if this:GetData("artron-val") < 0 then
        this:SetData("artron-val", 0, true)
    elseif this:GetData("artron-val") > GetConVar("te_maxartronenergy"):GetInt() then
                
        this:SetData("artron-val", GetConVar("te_maxartronenergy"):GetInt(), true)
 
    end
end


ENT:AddHook("Think", "powerdisableartron", function(self)
    if  self:GetData("power-state") == true and self:GetData("artron-val") <= 0 then
        if self:GetData("cloak") == true then 
            self:SetCloak(false)
        end
        if self:GetData("flight") == true then
            self:SetFlight(false)
        end
        self:SetPower(false)
        self:SetHandbrake(true)
        self:SetHandbrake(false)
        for k,_ in pairs(self.occupants) do
            TARDIS:ErrorMessage(k, "Artron Depleted.")
        end
    end
end)

end

