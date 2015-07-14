ENT.Type = "anim"
if WireLib then
	ENT.Base 			= "base_wire_entity"
else
	ENT.Base			= "base_gmodentity"
end 
ENT.PrintName		= "TARDIS Rewrite"
ENT.Author			= "Dr. Matt"
ENT.Spawnable		= true
ENT.AdminSpawnable	= true
ENT.RenderGroup 	= RENDERGROUP_BOTH
ENT.Category		= "Doctor Who"
ENT.TardisExterior	= true

TARDIS=ENT
ENT.von=TARDIS_VON

ENT.hooks={}

// Hook system for modules
function ENT:AddHook(name,id,func)
	if not (self.hooks[name]) then self.hooks[name]={} end
	self.hooks[name][id]=func
end

function ENT:RemoveHook(name,id)
	if self.hooks[name] and self.hooks[name][id] then
		self.hooks[name][id]=nil
	end
end

function ENT:CallHook(name,...)
	if not self.hooks[name] then return end
	local a,b,c,d,e,f
	for k,v in pairs(self.hooks[name]) do
		a,b,c,d,e,f = v(self,...)
		if ( a != nil ) then
			return a,b,c,d,e,f
		end
	end
end

function ENT:LoadFolder(path,addonly,noprefix)
	-- Loads modules
	local folder = "entities/gmod_tardis/"..path.."/"
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
ENT:LoadFolder("modules/libraries") -- loaded before main modules
ENT:LoadFolder("modules")

function ENT:OnRemove()
	self:CallHook("OnRemove")
end

function ENT:Use(a,c)
	self:CallHook("Use",a,c)
end