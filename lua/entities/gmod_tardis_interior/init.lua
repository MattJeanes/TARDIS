AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT:AddHook("PlayerInitialize", "interior", function(self)
    net.WriteString(self.metadata.ID)
end)

ENT:AddHook("PostPlayerInitialize", "senddata", function(self,ply)
    self:SendData(ply)
end)

function ENT:Initialize()
    if self.spacecheck then
        self.metadata=TARDIS:GetInterior(self.exterior.metadataID, self)
        if not self.metadata then
            self.metadata=TARDIS:GetInterior("default", self)
        end

        self.Model=self.metadata.Interior.Model
        self.Fallback=self.metadata.Interior.Fallback
        self.Portal=self.metadata.Interior.Portal
        self.CustomPortals=self.metadata.Interior.CustomPortals
        self.ExitDistance=self.metadata.Interior.ExitDistance
    end
    self.BaseClass.Initialize(self)

    if(#file.Find("weapons/gmod_tool/environments_tool_base.lua","LUA") == 1 or #file.Find("weapons/gmod_tool/stools/dev_link.lua","LUA") == 1 or #file.Find("weapons/gmod_tool/stools/rd3_dev_link.lua","LUA") == 1) then
		self.HasResourceDistribution = true;
	else
		self.HasResourceDistribution = false;
	end
end

function ENT:OnTakeDamage(dmginfo)
    if self:CallHook("ShouldTakeDamage",dmginfo)==false then return end
    self:CallHook("OnTakeDamage", dmginfo)
end

function ENT:Think()
    if(self.HasResourceDistribution) then
		self:LSSupport()
	end
end

--####### Give us air @RononDex (Modified by Jeppe)
function ENT:LSSupport()

	local ent_pos = self:GetPos();

	if(IsValid(self)) then
		for _,p in pairs(player.GetAll()) do -- Find all players
			local pos = (p:GetPos()-ent_pos):Length(); -- Where they are in relation to the interior
			if(pos<500 and p.suit) then -- If they're close enough
				if(not(CAF and CAF.GetAddon("Resource Distribution"))) then
					if (p.suit.air<100) then p.suit.air = 100; end -- They get air
					if (p.suit.energy<100) then p.suit.energy = 100; end -- and energy
					if (p.suit.coolant<100) then p.suit.coolant = 100; end -- and coolant
				else
					-- We need double the amount of LS3(No idea why)
					if (p.suit.air<200) then p.suit.air = 200; end -- They get air
					if (p.suit.energy<200) then p.suit.energy = 200; end -- and energy
					if (p.suit.coolant<200) then p.suit.coolant = 200; end -- and coolant
				end
			end
		end
	end
end