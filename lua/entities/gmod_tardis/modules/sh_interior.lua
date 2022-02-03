-- Adds an interior

if SERVER then
    ENT:AddHook("Use", "interior", function(self,a,c)
        if a:KeyDown(IN_WALK) or not IsValid(self.interior) then
            if self:CallHook("CanPlayerEnterDoor")~=false then
                self:PlayerEnter(a)
            end
        else
            self:ToggleDoor()
        end
    end)
end
