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

local tip_control_texts = {
	coords = "Coordinates",
	destination = "Destination",
	hads = "H.A.D.S.",
	monitor = "Monitor",
	scanner = "Scanner", -- for the future updates
	screen_toggle = "Toggle Screen",
	power = "Power Switch",
	physlock = "Physlock",
	cloak = "Cloaking Device", -- partially exists in some interiors
	throttle = "Space-Time Throttle",
	fast_return = "Fast-Return Protocol",
	long_flight = "Vortex Flight Toggler",
	handbrake = "Time-Rotor Handbrake", -- for the future updates
	music = "Music",
	isomorphic = "Isomorphic Security System",
	repair = "Self-Repair",
	flight = "Flight Mode",
	float = "Anti-Gravs",
}

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
		if not tip.text then
			if tip.part then
				local part = TARDIS:GetRegisteredPart(tip.part)
				if part then
					if part.Control then
						if tip_control_texts[part.Control] then
							tip.text = tip_control_texts[part.Control]
						else
							error("Control \""..part.Control.."\" does not exist")
						end
					end
					if part.Text then
						tip.text = part.Text
					end
				else
					error("Part \""..tip.part.."\" does not exist")
				end
			end
			if tip.control then
				if tip_control_texts[tip.control] then
					tip.text = tip_control_texts[tip.control]
				else
					error("Control \""..tip.control.."\" does not exist")
				end
			end
		end
		if not tip.text then
			error("Tip at position "..tostring(tip.pos).." has no text set")
		end
		tip.pos=self:LocalToWorld(tip.pos)
		tip.colors.current = tip.colors.normal
		tip.highlighted = false

		tip.SetHighlight = function(self, on)
			self.highlighted = on
			if on then
				self.colors.current = self.colors.highlighted
			else
				self.colors.current = self.colors.normal
			end
		end
		tip.ToggleHighlight = function(self)
			self:SetHighlight(not tip.highlighted)
		end

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
	if LocalPlayer():GetTardisData("thirdperson") or LocalPlayer():GetTardisData("destination") then
		return false
	end
end)

hook.Add("HUDPaint", "TARDIS-DrawTips", function()
	local interior = TARDIS:GetInteriorEnt(LocalPlayer())
	if not (interior and interior.tips and TARDIS:GetSetting("tips") and (interior:CallHook("ShouldDrawTips")~=false)) then return end

	local selected_tip_style = TARDIS:GetSetting("tips_style", "default", false)
	if interior.tip_style_name ~= selected_tip_style then
		interior:InitializeTips(selected_tip_style)
	end

	local view_range_min = interior.metadata.Interior.Tips.view_range_min
	local view_range_max = interior.metadata.Interior.Tips.view_range_max

	local cseq_enabled = interior:GetSequencesEnabled()
	local cseq_sequences, cseq_active, cseq_next

	if cseq_enabled then
		cseq_sequences = TARDIS:GetControlSequence(interior.metadata.Interior.Sequences)
		cseq_enabled = cseq_sequences ~= nil
		cseq_active = interior:GetData("cseq-active")
		local cseq_curseq = interior:GetData("cseq-curseq")
		local cseq_step = interior:GetData("cseq-step")
		if cseq_sequences and cseq_curseq and cseq_sequences[cseq_curseq] then
			cseq_next = cseq_sequences[cseq_curseq].Controls[cseq_step]
		end
	end

	local player_pos = LocalPlayer():EyePos()
	for k,tip in ipairs(interior.tips)
	do
		if not cseq_active then
			tip:SetHighlight(cseq_enabled and cseq_sequences[tip.part] ~= nil)
		else
			tip:SetHighlight(cseq_enabled and tip.part == cseq_next)
		end

		local dist = tip.pos:Distance(player_pos)
		if dist <= view_range_max then
			surface.SetFont(tip.font)
			local w, h = surface.GetTextSize( tip.text )
			local pos = tip.pos:ToScreen()
			local padding = 10
			local offset = 50
			local x = pos.x - w - offset
			local y = pos.y - h - offset
			local alpha = tip.colors.current.background.a
			if dist > view_range_min then
				local normalised = 1 - ((dist - view_range_min) / (view_range_max - view_range_min))
				alpha = (tip.colors.current.background.a) * normalised
			end

			local background_color = ColorAlpha(tip.colors.current.background, alpha)
			local frame_color = ColorAlpha(tip.colors.current.frame, alpha)
			local text_color = ColorAlpha(tip.colors.current.text, alpha)

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