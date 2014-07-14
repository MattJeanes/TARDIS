
include( "shared.lua" )

AccessorFunc( ENT, "texture", "Texture" )


--Draw world portals
function ENT:Draw()

	--self:DrawModel()

	if ( worldportals.drawing ) then return end

	render.ClearStencil()
	render.SetStencilEnable( true )

	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )

	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	render.SetStencilReferenceValue( 1 )
	
	render.SetMaterial( worldportals.matDummy )
	render.SetColorModulation( 1, 1, 1 )

	render.DrawQuadEasy( self:GetPos(), self:GetForward(), self:GetWidth(), self:GetHeight(), Color( 255, 255, 255, 255), self:GetAngles().roll )
	
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilReferenceValue( 1 )
	
	worldportals.matView:SetTexture( "$basetexture", self:GetTexture() )
	render.SetMaterial( worldportals.matView )
	render.DrawScreenQuad()
	
	render.SetStencilEnable( false )
end