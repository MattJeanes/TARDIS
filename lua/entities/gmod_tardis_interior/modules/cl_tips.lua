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
	option=false,
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
		for setting,value in pairs(interior_tip) do
			tip[setting]=value
		end
		tip.pos=self:LocalToWorld(tip.pos)
		table.insert(tips, tip)
	end
	self.tips = tips
end

ENT:AddHook("Initialize", "tips", function(self)
	if TARDIS:GetSetting("tips") and #self.metadata.Interior.Tips == 0 then
		LocalPlayer():ChatPrint("WARNING: Tips are enabled but this interior does not support them")
		return
	end

	local style_name = TARDIS:GetSetting("tips_style", "default", false)
	self:InitializeTips(style_name)
end)

ENT:AddHook("ShouldDrawTips", "tips", function(self)
	if ply:GetTardisData("thirdperson") then
		return false
	end
end)

hook.Add("HUDPaint", "TARDISRewrite-DrawTips", function()
	local interior = TARDIS:GetInteriorEnt(LocalPlayer())
	if not (interior and interior.tips and TARDIS:GetSetting("tips") and (interior:CallHook("ShouldDrawTips")~=false)) then return end

	local selected_tip_style = TARDIS:GetSetting("tips_style", "default", false)
	if interior.tip_style_name ~= selected_tip_style then
		interior:InitializeTips(selected_tip_style)
	end

	local view_range_min = interior.metadata.Interior.Tips.view_range_min
	local view_range_max = interior.metadata.Interior.Tips.view_range_max

	local player_pos = LocalPlayer():EyePos()
	for k,tip in ipairs(interior.tips)
	do
		local dist = tip.pos:Distance(player_pos)
		if dist <= view_range_max then
			surface.SetFont(tip.font)
			local w, h = surface.GetTextSize( tip.text )
			local pos = tip.pos:ToScreen()
			local padding = 10
			local offset = 50
			local x = pos.x - w - offset
			local y = pos.y - h - offset
			local alpha = tip.background_color.a
			if dist > view_range_min then
				local normalised = 1 - ((dist - view_range_min) / (view_range_max - view_range_min))
				alpha = (tip.background_color.a) * normalised
			end

			local background_color = ColorAlpha(tip.background_color, alpha)
			local frame_color = ColorAlpha(tip.frame_color, alpha)
			local text_color = ColorAlpha(tip.text_color, alpha)

			local verts = {}
			verts[1] = { x=x+w-(padding*2), y=y+h+padding }
			verts[2] = { x=x+w+(padding/2), y=y+h+padding }
			verts[3] = { x=pos.x-offset/2+2, y=pos.y-offset/2+2 }

			draw.NoTexture()
			surface.SetDrawColor( background_color:Unpack() )
			surface.DrawPoly( verts )
			surface.SetDrawColor( frame_color:Unpack() )
			surface.DrawPoly( verts )

			draw.RoundedBox( 8, x-padding-2, y-padding-2, w+padding*2+4, h+padding*2+4, frame_color )
			draw.RoundedBox( 8, x-padding, y-padding, w+padding*2, h+padding*2, background_color )

			draw.NoTexture()
			surface.DrawPoly( verts )

			draw.DrawText( tip.text, tip.font, x + w/2, y, text_color, TEXT_ALIGN_CENTER )
		end
	end
end)