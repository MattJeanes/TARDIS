-- Time distortion generator by parar020100 and JEREDEK

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "#TARDIS.TimeDistortionGenerator"
ENT.Spawnable = true

ENT.Instructions= "#TARDIS.TimeDistortionGenerator.Instructions"
ENT.AdminOnly = false
ENT.Category = "#TARDIS.Spawnmenu.CategoryTools"
ENT.IconOverride = "materials/entities/time_distortion_generator.png"


function ENT:SetupDataTables()
    self:NetworkVar( "Bool", 1, "Enabled" )
end