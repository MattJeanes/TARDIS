TARDIS:AddScreen("Companions", {id="companions", text="Screens.CompanionSystem", menu=false, order=2, popuponly=false}, function(self,ext,int,frame,screen)
--------------------------------------------------------------------------------
-- Layout calculations
--------------------------------------------------------------------------------
    local w = frame:GetWide()
    local h = frame:GetTall()

    local gap = math.min(w, h) * 0.06
    local gap2 = math.min(w, h) * 0.10

    local listW = w * 0.3
    local listH = h - 2 * gap

    local pnlW = w - (listW*2) - (gap*4)
    local pnlH = listH * 0.5

    local list2X = gap + listW + gap

    local pnlX = list2X + listW + gap
    local pnlY = gap + (listW / 2) * 0.6
--------------------------------------------------------------------------------
-- Layout
--------------------------------------------------------------------------------
    local background=vgui.Create("DImage", frame)
    local theme = TARDIS:GetScreenGUITheme(screen)
    local background_img = TARDIS:GetGUIThemeElement(theme, "backgrounds", "companions")
    background:SetImage(background_img)
    background:SetSize(w, h)
    local bgcolor = TARDIS:GetScreenGUIColor(screen)

    local companions_list
    local players_list

    if screen.is3D2D then
        companions_list = ListView3D:new(frame,screen,34,bgcolor)
        players_list = ListView3D:new(frame,screen,34,bgcolor)
    else
        companions_list = frame:Add("DListView")
        players_list = frame:Add("DListView")
    end

    companions_list:SetSize(listW, listH)
    companions_list:SetPos(gap, gap)
    companions_list:SetMultiSelect(false)
    companions_list:AddColumn("Name")
    companions_list:AddColumn("SteamID")

    players_list:SetSize(listW, listH)
    players_list:SetPos(list2X, gap)
    players_list:SetMultiSelect(false)
    players_list:AddColumn("Online Players")

    local panel = frame:Add("DPanel")
    panel:SetSize(pnlW, pnlH)
    panel:SetPos(pnlX, pnlY)
    panel:SetBackgroundColor(bgcolor)
--------------------------------------------------------------------------------
-- Loading data
--------------------------------------------------------------------------------
end)