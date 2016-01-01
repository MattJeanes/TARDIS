-- TARDIS Interior

ENT.Base="gmod_door_interior"
ENT.Author="Dr. Matt"
ENT.TardisInterior=true
ENT.Exterior="gmod_tardis"

local class=string.sub(ENT.Folder,string.find(ENT.Folder, "/[^/]*$")+1) -- only works if in a folder

local hooks={}

-- Hook system for modules
function ENT:AddHook(name,id,func)
	if not (hooks[name]) then hooks[name]={} end
	hooks[name][id]=func
end

function ENT:RemoveHook(name,id)
	if hooks[name] and hooks[name][id] then
		hooks[name][id]=nil
	end
end

function ENT:CallHook(name,...)
	local a,b,c,d,e,f
	a,b,c,d,e,f=self.BaseClass.CallHook(self,name,...)
	if a~=nil then
		return a,b,c,d,e,f
	end
	if not hooks[name] then return end
	for k,v in pairs(hooks[name]) do
		a,b,c,d,e,f = v(self,...)
		if a~=nil then
			return a,b,c,d,e,f
		end
	end
end

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