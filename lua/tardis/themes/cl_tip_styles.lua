local tip_styles={}

function TARDIS:AddTipStyle(style)
	tip_styles[style.style_id]=table.Copy(style)
end

function TARDIS:RemoveTipStyle(id)
	tip_styles[id]=nil
end

function TARDIS:GetTipStyles()
	return tip_styles
end

function TARDIS:GetTipStyle(id)
	if tip_styles[id] then
		return tip_styles[id]
	end
end
