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
	local default = interior_metadata.Tips.default

	for k,tip in pairs(interior_metadata.Tips)
	do
		if tip == default or tip.text == nil or tip.text == "" or tip.invisible then continue end
		local text = tip.text

		local pos = tip.pos + interior:GetPos()
		local range = tip.view_range or 110
		local dist = pos:Distance(LocalPlayer():GetPos())

		if (dist > range) then continue end
		local pos = pos:ToScreen()

		local text_col, tip_col, frame_col, font

		if tip.text_color then
			text_col = tip.text_color
		elseif default and default.text_color then
			text_col = default.text_color
		else
			text_col = Color(0, 0, 0, 255)
		end

		if tip.tip_color then
			tip_col = tip.tip_color
		elseif default and default.tip_color then
			tip_col = default.tip_color
		else
			tip_col = Color(255, 255, 200, 255)
		end

		if tip.frame_color then
			frame_col = tip.frame_color
		elseif default and default.frame_color then
			frame_col = default.frame_color
		else
			frame_col = Color(0, 0, 0, 255)
		end

		if tip.font then
			font = tip.font
		elseif default and default.font then
			font = default.font
		else
			font = "GModWorldtip"
		end

		local x = 0
		local y = 0
		local padding = 10
		local offset = 50

		surface.SetFont(font)
		local w, h = surface.GetTextSize( text )

		x = pos.x - w - offset
		y = pos.y - h - offset


		draw.RoundedBox( 8, x-padding-2, y-padding-2, w+padding*2+4, h+padding*2+4, frame_col )

		local verts = {}
		verts[1] = { x=x+w/1.5-2, y=y+h+2 }
		verts[2] = { x=x+w+2, y=y+h/2-1 }
		verts[3] = { x=pos.x-offset/2+2, y=pos.y-offset/2+2 }

		draw.NoTexture()
		surface.SetDrawColor( 0, 0, 0, tip_col.a )
		surface.DrawPoly( verts )

		draw.RoundedBox( 8, x-padding, y-padding, w+padding*2, h+padding*2, tip_col )

		local verts = {}
		verts[1] = { x=x+w/1.5, y=y+h }
		verts[2] = { x=x+w, y=y+h/2 }
		verts[3] = { x=pos.x-offset/2, y=pos.y-offset/2 }

		draw.NoTexture()
		surface.SetDrawColor( tip_col.r, tip_col.g, tip_col.b, tip_col.a )
		surface.DrawPoly( verts )

		draw.DrawText( text, font, x + w/2, y, text_col, TEXT_ALIGN_CENTER )
	end
end)