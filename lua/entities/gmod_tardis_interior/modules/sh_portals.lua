// Handles portals for rendering, thanks to bliptec (http://facepunch.com/member.php?u=238641) for being a babe

if SERVER then
	-- Disable player view model - TODO: Why?
	hook.Add( "PlayerInitialSpawn", "TARDIS-Portals", function( ply )
		ply:DrawViewModel(false)
	end)

	-- Set up visibility through portals
	hook.Add( "SetupPlayerVisibility", "TARDIS-Portals", function( ply, ent )
		for _, portal in ipairs( ents.FindByClass( "linked_portal_door" ) ) do
			if portal.exit and portal:Visible(ply) then
				AddOriginToPVS( portal.exit:GetPos() )
			end
		end
	end)
elseif CLIENT then
	local rtcount=0
	ENT:AddHook("Initialize", "Portals", function(self)
		local exterior=self:GetNWEntity("exterior")
		self.texture = GetRenderTarget("tardis-portal"..rtcount+1,
			ScrW(),
			ScrH(),
			false
		)
		self.texture2 = GetRenderTarget("tardis-portal"..rtcount+1,
			ScrW(),
			ScrH(),
			false
		)
		self.exitpos=vector_origin
		self.forward=vector_origin
		self.exitforward=vector_origin
		self.width=500
		self.height=500
	end)
	
	ENT:AddHook("Think", "Portals", function(self)
		local exterior=self:GetNWEntity("exterior")
		if not IsValid(exterior) then return end
		self.pos=exterior:GetPos()
		self.exitpos=self:LocalToWorld(Vector(0,-300,90))
		self.forward=exterior:GetForward()
		self.exitforward=self:GetRight()*-1
	end)
	
	local matView = CreateMaterial(
		"UnlitGeneric",
		"GMODScreenspace",
		{
			["$basetexturetransform"] = "center .5 .5 scale -1 -1 rotate 0 translate 0 0",
			["$texturealpha"] = "0",
			["$vertexalpha"] = "1",
		}
	)
	local matDummy = Material( "debug/white" )

	-- Render the portal views
	local drawing = false

	hook.Add( "RenderScene", "TARDIS-Portals", function( plyOrigin, plyAngles)
		if ( drawing ) then return end

		local oldWepColor = LocalPlayer():GetWeaponColor()
		LocalPlayer():SetWeaponColor( Vector(0, 0, 0) ) --no more phys gun glow or beam
		local interior=ents.FindByClass("gmod_tardis_interior")[1]
		if IsValid(interior) then
			exterior=interior:GetNWEntity("exterior")
		end
		if IsValid(exterior) and IsValid(interior) then
			if not ( LocalPlayer():GetNWEntity("tardis")==exterior ) then
				-- Render view from portal
				local oldRT = render.GetRenderTarget()
				render.SetRenderTarget( interior.texture )
					render.Clear( 0, 0, 0, 255 )
					render.ClearDepth()
					render.ClearStencil()

					render.EnableClipping(true)
					render.PushCustomClipPlane(interior.exitforward, interior.exitforward:Dot(interior.exitpos) )
					
					local rotation = interior.exitforward:Angle() - interior.forward:Angle()
					rotation = rotation + Angle( 0, 180, 0)
					local offset = LocalPlayer():EyePos() - interior.pos
					offset:Rotate( rotation )
					local camPos = interior.exitpos + offset

					local camAngles = plyAngles + rotation 
					
					drawing = true
						render.RenderView( {
							x = 0,
							y = 0,
							w = ScrW(),
							h = ScrH(),
							origin = camPos,
							angles = camAngles,
							drawpostprocess = true,
							drawhud = false,
							drawmonitors = false,
							drawviewmodel = false,
						} )
					drawing = false

				render.PopCustomClipPlane()
				render.EnableClipping(false)
				render.SetRenderTarget( oldRT )
			else
				-- Render view from portal
				render.SetRenderTarget( interior.texture2 )
					render.Clear( 0, 0, 0, 255 )
					render.ClearDepth()
					render.ClearStencil()

					render.EnableClipping(true)
					render.PushCustomClipPlane(interior.forward, interior.forward:Dot(interior.pos) )
					
					local rotation = interior.forward:Angle() - interior.exitforward:Angle()
					rotation = rotation + Angle( 0, 180, 0)
					local offset = LocalPlayer():EyePos() - interior.exitpos
					offset:Rotate( rotation )
					local camPos = interior.pos + offset

					local camAngles = plyAngles + rotation 
					
					drawing = true
						render.RenderView( {
							x = 0,
							y = 0,
							w = ScrW(),
							h = ScrH(),
							origin = camPos,
							angles = camAngles,
							drawpostprocess = true,
							drawhud = false,
							drawmonitors = false,
							drawviewmodel = false,
						} )
					drawing = false

				render.PopCustomClipPlane()
				render.EnableClipping(false)
				render.SetRenderTarget( oldRT )
			end
		end

		LocalPlayer():SetWeaponColor( oldWepColor )
	end )
	hook.Add( "PreDrawOpaqueRenderables", "TARDIS-Portals", function()

		render.UpdateScreenEffectTexture()
		
		if ( drawing ) then return end
		
		local interior=ents.FindByClass("gmod_tardis_interior")[1]
		if IsValid(interior) then
			exterior=interior:GetNWEntity("exterior")
		end
		if IsValid(exterior) and IsValid(interior) then
			-- Draw view over portal
			render.ClearStencil()
			render.SetStencilEnable( true )

			render.SetStencilWriteMask( 1 )
			render.SetStencilTestMask( 1 )

			render.SetStencilFailOperation( STENCILOPERATION_KEEP )
			render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
			render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
			render.SetStencilReferenceValue( 1 )
			
			render.SetMaterial( matDummy )
			render.SetColorModulation( 1, 1, 1 )

			render.DrawQuadEasy( interior.pos, interior.forward, interior.width, interior.height, Color( 255, 255, 255, 255) )
			
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
			render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
			render.SetStencilReferenceValue( 1 )
			
			matView:SetTexture( "$basetexture", interior.texture )
			render.SetMaterial( matView )
			render.DrawScreenQuad()
			
			render.SetStencilEnable( false )
			
			-- Draw view over portal
			render.ClearStencil()
			render.SetStencilEnable( true )

			render.SetStencilWriteMask( 1 )
			render.SetStencilTestMask( 1 )

			render.SetStencilFailOperation( STENCILOPERATION_KEEP )
			render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
			render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
			render.SetStencilReferenceValue( 1 )
			
			render.SetMaterial( matDummy )
			render.SetColorModulation( 1, 1, 1 )

			render.DrawQuadEasy( interior.exitpos, interior.exitforward, interior.width, interior.height, Color( 255, 255, 255, 255) )
			
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
			render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
			render.SetStencilReferenceValue( 1 )
			
			matView:SetTexture( "$basetexture", interior.texture2 )
			render.SetMaterial( matView )
			render.DrawScreenQuad()
			
			render.SetStencilEnable( false )
		end
	end )

	-- Set it to draw the player while rendering portals
	-- Calling Start3D to fix this is incredibly hacky
	-- TODO: Why?

	hook.Add( "PostDrawEffects", "WorldPortalPotentialFix", function()
		cam.Start3D( EyePos(), EyeAngles() )
		cam.End3D()
	end)

	hook.Add( "ShouldDrawLocalPlayer", "WorldPortalRenderHook", function()
		return drawing
	end)
end