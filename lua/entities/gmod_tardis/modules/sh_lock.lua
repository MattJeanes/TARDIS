-- Lock

function ENT:Locked()
    return self:GetData("locked",false)
end

function ENT:Locking()
    return self:GetData("locking",false)
end

if SERVER then
    function ENT:ToggleLocked(callback)
        self:SetLocked(not self:Locked(),callback)
    end

    function ENT:ActualSetLocked(locked,callback,silent)
        self:SetData("locking",false,true)
        self:SetData("locked",locked,true)
        self:FlashLight(0.6)
        if not silent then self:SendMessage("locksound") end
        if callback then callback(true) end
    end

    function ENT:SetLocked(locked,callback, silent)
        if not self:CallHook("CanLock") then return end
        if locked then
            self:SetData("locking",true,true)
            self:CloseDoor(function(state)
                if state then
                    if callback then callback(false) end
                else
                    self:ActualSetLocked(true,callback,silent)
                end
            end)
        else
            self:ActualSetLocked(false,callback,silent)
        end
    end
    
    ENT:AddHook("CanPlayerEnter","lock",function(self,ply)
        if self:Locked() then
            return false
        end
    end)

    ENT:AddHook("CanToggleDoor","lock",function(self,state)
        if (not state) and self:Locked() then
            return false
        end
    end)
    
    ENT:AddHook("Use", "lock", function(self,a,c)
        if self:GetData("locked") and IsValid(a) and a:IsPlayer() then
            if self:CallHook("LockedUse",a,c)==nil then
                TARDIS:Message(a, "This TARDIS is locked.")
            end
            self:EmitSound(self:GetExtMetadata().Sounds.Door.locked)
        end
    end)

    ENT:AddHook("HandleE2", "lock", function(self,name,e2)
        if name == "GetLocked" then
            if self:Locked() or self:Locking() then
                return 1
            else
                return 0
            end
        elseif name == "Lock" and TARDIS:CheckPP(e2.player, self) then
            self:ToggleLocked()
            return self:CallHook("CanLock") == true and 1 or 0
        end
    end)
else
    ENT:OnMessage("locksound",function(self)
        local extsound = self:GetExtMetadata().Sounds.Lock
        local intsound = self:GetIntMetadata().Sounds.Lock or extsound

        if TARDIS:GetSetting("locksound-enabled") and TARDIS:GetSetting("sound") then
            self:EmitSound(extsound)
            if IsValid(self.interior) then
                self.interior:EmitSound(intsound)
            end
        end
    end)
end
