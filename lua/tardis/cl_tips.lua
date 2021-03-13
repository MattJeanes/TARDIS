TARDIS:AddSetting({
	id="learning_mode_enabled",
	name="Learning mode",
	desc="Should tips be shown for TARDIS controls?",
	section="Misc",
	value=true,
	type="bool",
	option=true,
	networked=false
})

hook.Add("HUDPaint", "TARDISRewrite-DrawTips", function()

	local interior = TARDIS:GetInteriorEnt(LocalPlayer())
	if not (interior and interior.metadata and interior.metadata.Interior
		and interior.metadata.Interior.Tips
		and TARDIS:GetSetting("learning_mode_enabled"))
	then
		return
	end

	local interior_metadata = interior.metadata.Interior
	local interior_default = interior_metadata.Tips.default

	for k,interior_tip in pairs(interior_metadata.Tips)
	do
		local tip={
			pos=Vector(0,0,0),
			text="Tip",
			invisible=false,
			view_range=110,
			text_color=Color(0, 0, 0, 255),
			background_color=Color(255, 255, 200, 255),
			frame_color=Color(0, 0, 0, 255),
			font="GModWorldtip",
		}

		if interior_default ~= nil then
			for setting,value in pairs(interior_default) do
				tip[setting]=value
			end
		end

		for setting,value in pairs(interior_tip) do
			tip[setting]=value
		end

		tip.pos = tip.pos + interior:GetPos()

		local dist = tip.pos:Distance(LocalPlayer():GetPos())
		if (dist > tip.view_range) or k == "default" or tip.invisible then
			continue
		end

		surface.SetFont(tip.font)
		local w, h = surface.GetTextSize( tip.text )
		local pos = tip.pos:ToScreen()
		local padding = 10
		local offset = 50
		local x = pos.x - w - offset
		local y = pos.y - h - offset

		draw.RoundedBox(8, x-padding-2, y-padding-2, w+padding*2+4, h+padding*2+4, tip.frame_color)

		local verts = {}
		verts[1] = { x=x+w/1.5-2, y=y+h+2 }
		verts[2] = { x=x+w+2, y=y+h/2-1 }
		verts[3] = { x=pos.x-offset/2+2, y=pos.y-offset/2+2 }

		draw.NoTexture()
		surface.SetDrawColor( 0, 0, 0, tip.background_color.a )
		surface.DrawPoly( verts )

		draw.RoundedBox( 8, x-padding, y-padding, w+padding*2, h+padding*2, tip.background_color )

		local verts = {}
		verts[1] = { x=x+w/1.5, y=y+h }
		verts[2] = { x=x+w, y=y+h/2 }
		verts[3] = { x=pos.x-offset/2, y=pos.y-offset/2 }

		draw.NoTexture()
		surface.SetDrawColor(tip.background_color.r, tip.background_color.g, tip.background_color.b, tip.background_color.a)
		surface.DrawPoly( verts )

		draw.DrawText( tip.text, tip.font, x + w/2, y, tip.text_color, TEXT_ALIGN_CENTER )
		tip={}
	end
end)