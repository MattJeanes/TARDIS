-- Test button

local PART={}
PART.ID = "test"
PART.Name = "Test Button"
PART.Model = "models/Gibs/HGIBS.mdl"
PART.AutoSetup = true

if SERVER then
	function PART:Initialize()
		self:SetColor(Color(255,255,255,0))
		self:DrawShadow(false) -- TODO: this doesnt work
	end
	
	function PART:Use(activator)
		activator:ChatPrint("Hello! This is the "..self.Name.." (ID: "..self.ID.."). I am "..tostring(self)..".")
	end
end

ENT:AddPart(PART,e)