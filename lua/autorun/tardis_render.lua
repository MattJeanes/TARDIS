if SERVER then
	hook.Add( "SetupPlayerVisibility", "TARDIS-Render", function(ply,viewent)
		if IsValid(ply.tardis) then
			AddOriginToPVS(ply.tardis:GetPos())
		end
	end)
elseif CLIENT then
	local rt,mat
	local size=1024
	local CamData = {}
	CamData.x = 0
	CamData.y = 0
	CamData.fov = 90
	CamData.drawviewmodel = false
	CamData.w = size
	CamData.h = size
	
	hook.Add("InitPostEntity", "TARDIS-Render", function()
		rt=GetRenderTarget("tardis_rt",size,size,false)
		mat=Material("models/drmatt/tardis/TardisScanner")
		mat:SetTexture("$basetexture",rt)
	end)
	
	hook.Add("RenderScene", "TARDIS-Render", function()
		if tobool(GetConVarNumber("tardisint_scanner"))==false then return end
		local tardis=LocalPlayer().tardis
		if IsValid(tardis) and LocalPlayer().tardis_viewmode then
			CamData.origin = tardis:LocalToWorld(Vector(23, 0, 60))
			CamData.angles = tardis:GetAngles()
			LocalPlayer().tardis_render=true
			local old = render.GetRenderTarget()
			render.SetRenderTarget( rt )
			render.Clear(0,0,0,255)
			cam.Start2D()
				render.RenderView(CamData)
			cam.End2D()
			render.CopyRenderTargetToTexture(rt)
			render.SetRenderTarget(old)
			LocalPlayer().tardis_render=false
		end
	end)
	
	hook.Add( "PreDrawHalos", "TARDIS-Render", function() // not ideal, but the new scanner sorta forced me to do this
		if tobool(GetConVarNumber("tardisint_halos"))==false then return end
		local tardis=LocalPlayer().tardis
		if IsValid(tardis) and not LocalPlayer().tardis_render then
			local interior=tardis:GetNWEntity("interior",NULL)
			if IsValid(interior) and interior.parts then
				for k,v in pairs(interior.parts) do
					if v.shouldglow then
						halo.Add( {v}, Color( 255, 255, 255, 255 ), 1, 1, 1, true, true )
					end
				end
			end
		end
	end )
end