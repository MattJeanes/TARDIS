TARDIS:AddScreen("Companions", {id="companions", text="Screens.CompanionSystem", menu=false, order=2, popuponly=false}, function(self,ext,int,frame,screen)
--------------------------------------------------------------------------------
-- Layout calculations
--------------------------------------------------------------------------------
    local frW = frame:GetWide()
    local frT = frame:GetTall()
--------------------------------------------------------------------------------
-- Layout
--------------------------------------------------------------------------------
    local background=vgui.Create("DImage", frame)
    local theme = TARDIS:GetScreenGUITheme(screen)
    local background_img = TARDIS:GetGUIThemeElement(theme, "backgrounds", "companions")
    background:SetImage(background_img)
    background:SetSize(frW, frT)
    local bgcolor = TARDIS:GetScreenGUIColor(screen)


end)