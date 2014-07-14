
ENT.Type				= "anim"
ENT.Spawnable			= false
ENT.AdminOnly			= false
ENT.Editable			= false


--ENT.Model = Model("models/props/cs_office/microwave.mdl")

function ENT:Initialize()

	local mins = Vector(-1, -self:GetWidth() /2, -self:GetHeight() /2)
	local maxs = -mins

	if CLIENT then

		self:SetTexture( GetRenderTarget("portal" .. self:EntIndex(),
			ScrW(),
			ScrH(),
			false
		) )

		self:SetRenderBounds( mins, maxs )

	end

	--[[self:SetModel(self.Model)

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)

	local b = 32
	self:SetCollisionBounds(Vector(-b, -b, -b), Vector(b,b,b))

	local phys = self:GetPhysicsObject()
	--phys:EnableMotion( true )
	--phys:Wake()]]--

end


function ENT:SetupDataTables()

	self:NetworkVar( "Entity", 0, "Exit" )
	self:NetworkVar( "Int", 1, "Width" )
	self:NetworkVar( "Int", 2, "Height" )
	self:NetworkVar( "Int", 3, "DisappearDist" )

end
