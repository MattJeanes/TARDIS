-- Health

if CLIENT then
	TARDIS:AddScreen("Health", {menu=false}, function(self,ext,int,frame,screen)
		local health = ext:GetData("health-val", 0)
		local label = vgui.Create("DLabel",frame)
		label:SetTextColor(Color(0,0,0))
		label:SetFont("TARDIS-Med")
		label.DoLayout = function(self)
			label:SizeToContents()
			label:SetPos((frame:GetWide()*0.5)-(label:GetWide()*0.5),(frame:GetTall()*0.5)-(label:GetTall()*0.5))
		end
		label:SetText("Health: "..health)
		label:DoLayout()
		
		frame.Think = function()
			if ext:GetData("UpdateHealthScreen") == true then
				health = ext:GetHealth()
				label:SetText("Health: "..health)
				label:DoLayout()
				ext:SetData("UpdateHealthScreen", false)
			end
		end
	end)
end
