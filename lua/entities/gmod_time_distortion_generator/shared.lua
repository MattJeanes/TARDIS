-- Time distortion generator by parar020100 and JEREDEK

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Time Distortion Generator"
ENT.Spawnable = true

ENT.Instructions= "Creates time distortions, which mess with the TARDIS engines, and prevent it from taking off or landing"
ENT.AdminOnly = false
ENT.Category = "Doctor Who - TARDIS Tools"
ENT.IconOverride = "materials/entities/time_distortion_generator.png"


function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 1, "Enabled" )
end