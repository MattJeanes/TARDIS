-- Tips

TARDIS:AddSetting({
	id="tips",
	name="Tips",
	desc="Should tips be shown for TARDIS controls?",
	section="Misc",
	value=true,
	type="bool",
	option=true,
	networked=false
})

TARDIS:AddSetting({
	id="tips_style",
	name="Tips Style",
	desc="Which style should the TARDIS tips use?",
	section="Misc",
	value="default",
	option=true,
	networked=false
})

function ENT:InitializeTips(style_name)
	if style_name == "default" then
		style_name = self.metadata.Interior.Tips.style
	end
	self.tip_style_name = style_name
	local style = TARDIS:GetTipStyle(style_name)
	local tips = {}
	for k,interior_tip in ipairs(self.metadata.Interior.Tips)
	do
		local tip = table.Copy(style)
		tip.view_range = self.metadata.Interior.Tips.view_range
		for setting,value in pairs(interior_tip) do
			tip[setting]=value
		end
		tip.pos=self:LocalToWorld(tip.pos)
		table.insert(tips, tip)
	end
	return tips
end

ENT:AddHook("Initialize", "tips", function(self)
	if TARDIS:GetSetting("tips") and #self.metadata.Interior.Tips == 0 then
		LocalPlayer():ChatPrint("WARNING: Tips are enabled but this interior does not support them")
		return
	end

	local style_name = TARDIS:GetSetting("tips_style", "default", false)
	self.tips = self:InitializeTips(style_name)
end)

hook.Add("HUDPaint", "TARDISRewrite-DrawTips", function()
	local interior = TARDIS:GetInteriorEnt(LocalPlayer())
	if not (interior and interior.tips and TARDIS:GetSetting("tips")) then return end

	local selected_tip_style = TARDIS:GetSetting("tips_style", "default", false)
	if interior.tip_style_name ~= selected_tip_style then
		interior.tips = interior:InitializeTips(selected_tip_style)
	end

	local player_pos = LocalPlayer():GetPos()
	for k,tip in ipairs(interior.tips)
	do
		local dist = tip.pos:Distance(player_pos)
		if dist <= tip.view_range then
			surface.SetFont(tip.font)
			surface.SetDrawColor(tip.background_color.r, tip.background_color.g, tip.background_color.b, tip.background_color.a)
			local w, h = surface.GetTextSize( tip.text )
			local pos = tip.pos:ToScreen()
			local padding = 10
			local offset = 50
			local x = pos.x - w - offset
			local y = pos.y - h - offset

			draw.RoundedBox(8, x-padding-2, y-padding-2, w+padding*2+4, h+padding*2+4, tip.frame_color)

			local verts = {}
			verts[1] = { x=x+w-(padding*2), y=y+h+padding+2 }
			verts[2] = { x=x+w+(padding/2), y=y+h+padding+2 }
			verts[3] = { x=pos.x-offset/2+2, y=pos.y-offset/2+2 }

			draw.NoTexture()
			surface.DrawPoly( verts )

			draw.RoundedBox( 8, x-padding, y-padding, w+padding*2, h+padding*2, tip.background_color )

			draw.NoTexture()
			surface.DrawPoly( verts )

			draw.DrawText( tip.text, tip.font, x + w/2, y, tip.text_color, TEXT_ALIGN_CENTER )
		end
	end
end)