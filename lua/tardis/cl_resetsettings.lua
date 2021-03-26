-- Reset settings

TARDIS:AddGUISetting("Reset Settings", function(self,frame,screen)
	local button = vgui.Create("DButton",frame)
	button:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	button:SetText("Reset clientside settings")
	button:SetSize(frame:GetWide()*0.3,frame:GetTall()*0.15)
	button:SetPos((frame:GetWide()*0.5)-(button:GetWide()*0.5),(frame:GetTall()*0.5)-(button:GetTall()*0.5))
	button.DoClick = function(button)
		Derma_Query("Reset all clientside settings? This cannot be undone.", "TARDIS Interface", "OK", function()
			TARDIS:ResetSettings()
            TARDIS:Message(LocalPlayer(), "TARDIS clientside settings have been reset. You may need to respawn the TARDIS for all changes to apply.")
		end, "Cancel", function() end):SetSkin("TARDIS")
	end
	
	-- TODO: Reset serverside settings (admin only)
end)