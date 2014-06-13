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
		self.portals={}
		self.portals[1]={
			pos=vector_origin,
			fwd=vector_origin,
			width=500,
			height=500,
			tex = GetRenderTarget("tardis-portal"..rtcount+1,
				ScrW(),
				ScrH(),
				false
			)
			
		}
		self.portals[2]={
			pos=vector_origin,
			fwd=vector_origin,
			width=500,
			height=500,
			tex = GetRenderTarget("tardis-portal"..rtcount+1,
				ScrW(),
				ScrH(),
				false
			)
		}
		self.portals[1].exit=2
		self.portals[2].exit=1
	end)
	
	ENT:AddHook("Think", "Portals", function(self)
		local exterior=self:GetNWEntity("exterior")
		if not IsValid(exterior) then return end
		self.portals[1].pos=exterior:GetPos()
		self.portals[1].fwd=exterior:GetForward()
		self.portals[2].pos=self:LocalToWorld(Vector(0,-300,90))
		self.portals[2].fwd=self:GetRight()*-1
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

	hook.Add( "RenderScene", "TARDIS-Portals", function( origin, angles )
		if ( drawing ) then return end

		local oldWepColor = LocalPlayer():GetWeaponColor()
		LocalPlayer():SetWeaponColor( Vector(0, 0, 0) ) --no more phys gun glow or beam
		for k,interior in pairs(ents.FindByClass("gmod_tardis_interior")) do
			local oldshoulddraw=interior.shoulddraw
			interior.shoulddraw=true
			if IsValid(interior) then
				exterior=interior:GetNWEntity("exterior")
			end
			if IsValid(exterior) and IsValid(interior) then
				local viewent=LocalPlayer():GetViewEntity()
				if IsValid(viewent) and not (viewent==LocalPlayer()) then
					origin = viewent:GetPos()
					angles = viewent:GetAngles()
				end
				local portal=LocalPlayer():GetNWEntity("tardis")==exterior and interior.portals[2] or interior.portals[1]
				local exit=interior.portals[portal.exit]
				-- Render view from portal
				local oldRT = render.GetRenderTarget()
				render.SetRenderTarget( portal.tex )
					render.Clear( 0, 0, 0, 255 )
					render.ClearDepth()
					render.ClearStencil()

					render.EnableClipping(true)
					render.PushCustomClipPlane(exit.fwd, exit.fwd:Dot(exit.pos) )
					
					local rotation = exit.fwd:Angle() - portal.fwd:Angle()
					rotation = rotation + Angle( 0, 180, 0 )
					local offset = origin - portal.pos
					offset:Rotate( rotation )
					local camPos = exit.pos + offset

					local camAngles = angles + rotation
					
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
				interior.shoulddraw=oldshoulddraw
			end
		end

		LocalPlayer():SetWeaponColor( oldWepColor )
	end)
	hook.Add( "PreDrawOpaqueRenderables", "TARDIS-Portals", function()

		render.UpdateScreenEffectTexture()
		
		if ( drawing ) then return end
		
		for k,interior in pairs(ents.FindByClass("gmod_tardis_interior")) do
			local exterior
			if IsValid(interior) then
				exterior=interior:GetNWEntity("exterior")
			end
			if IsValid(exterior) and IsValid(interior) then
				local portal=LocalPlayer():GetNWEntity("tardis")==exterior and interior.portals[2] or interior.portals[1]
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

				render.DrawQuadEasy( portal.pos, portal.fwd, portal.width, portal.height, Color( 255, 255, 255, 255), exterior:GetAngles().r )
				
				render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
				render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
				render.SetStencilReferenceValue( 1 )
				
				matView:SetTexture( "$basetexture", portal.tex )
				render.SetMaterial( matView )
				render.DrawScreenQuad()
				
				render.SetStencilEnable( false )
			end
		end
	end)

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