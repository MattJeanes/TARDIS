-- TARDIS

ENT.Base="gmod_door_exterior"
ENT.Spawnable=false
ENT.PrintName="TARDIS"
ENT.Category="Doctor Who - TARDIS"
ENT.Author="Dr. Matt"
ENT.TardisExterior=true
ENT.Interior="gmod_tardis_interior"

if TARDIS_OVERRIDES and TARDIS_OVERRIDES.MainCategory then
    ENT.Category = TARDIS_OVERRIDES.MainCategory
end


function ENT:GetMetadata()
    if self.metadata then
        return self.metadata
    end
end

function ENT:GetIntMetadata()
    return self:GetMetadata().Interior
end

function ENT:GetExtMetadata()
    return self:GetMetadata().Exterior
end

function ENT:GetID()
    return self:GetMetadata().ID
end

-- Hook system for modules
local hooks={}

function ENT:AddHook(name,id,func)
    if not (hooks[name]) then hooks[name]={} end
    if hooks[name][id] then error("Duplicate hook ID '"..id.."' for '"..name.."' hook",2) end
    if type(id)==func or not func then error("Invalid parameters - need name, id and func",2) end
    hooks[name][id]=func
end

function ENT:RemoveHook(name,id)
    if hooks[name] and hooks[name][id] then
        hooks[name][id]=nil
    end
end

function ENT:GetHooksTable()
    return hooks
end

function ENT:ListHooks(listInteriorHooks)
    print("[Exterior]"..(SERVER and "[Server]" or "[Client]"))
    for h in pairs(hooks) do
        print(h)
    end
    if listInteriorHooks then self.interior:ListHooks() end
end

function ENT:CallCommonHook(name, ...)
    local a,b,c,d,e,f

    a,b,c,d,e,f = self:CallHook(name, ...)
    if a~=nil then
        return a,b,c,d,e,f
    end

    if IsValid(self.interior) then
        a,b,c,d,e,f = self.interior:CallHook(name, ...)
        if a~=nil then
            return a,b,c,d,e,f
        end
    end
end

function ENT:CallHook(name,...)
    local a,b,c,d,e,f
    a,b,c,d,e,f=self.BaseClass.CallHook(self,name,...)
    if a~=nil then
        return a,b,c,d,e,f
    end
    if hooks[name] then
        for k,v in pairs(hooks[name]) do
            a,b,c,d,e,f = v(self,...)
            if a~=nil then
                return a,b,c,d,e,f
            end
        end
    end
    if self.metadata and self:GetExtMetadata() and self:GetExtMetadata().CustomHooks then
        for hook_id,body in pairs(self:GetExtMetadata().CustomHooks) do
            if body and istable(body) and ((body[1] == name) or (istable(body[1]) and body[1][name])) then
                local func = body[2]
                a,b,c,d,e,f = func(self, ...)
                if a~=nil then
                    return a,b,c,d,e,f
                end
            end
        end
    end
    if self.metadata and self:GetMetadata().CustomHooks then
        for hook_id,body in pairs(self:GetMetadata().CustomHooks) do
            if body and istable(body) and body.exthooks and body.exthooks[name] then
                a,b,c,d,e,f = body.func(self, self.interior, ...)
                if a~=nil then
                    return a,b,c,d,e,f
                end
            end
        end
    end
end

local class=string.sub(ENT.Folder,string.find(ENT.Folder, "/[^/]*$")+1) -- only works if in a folder

function ENT:LoadFolder(folder,addonly,noprefix)
    folder="entities/"..class.."/"..folder.."/"
    local modules = file.Find(folder.."*.lua","LUA")
    for _, plugin in ipairs(modules) do
        if noprefix then
            if SERVER then
                AddCSLuaFile(folder..plugin)
            end
            if not addonly then
                include(folder..plugin)
            end
        else
            local prefix = string.Left( plugin, string.find( plugin, "_" ) - 1 )
            if (CLIENT and (prefix=="sh" or prefix=="cl")) then
                if not addonly then
                    include(folder..plugin)
                end
            elseif (SERVER) then
                if (prefix=="sv" or prefix=="sh") and (not addonly) then
                    include(folder..plugin)
                end
                if (prefix=="sh" or prefix=="cl") then
                    AddCSLuaFile(folder..plugin)
                end
            end
        end
    end
end

ENT:LoadFolder("modules/libraries")
ENT:LoadFolder("modules")