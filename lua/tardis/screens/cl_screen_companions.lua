local isValid = IsValid
local localPlayer = LocalPlayer

TARDIS:AddScreen("Companions", {id="companions", text="Screens.CompanionSystem", menu=false, order=2, popuponly=false}, function(self,ext,int,frame,screen)
--------------------------------------------------------------------------------
-- Layout calculations
--------------------------------------------------------------------------------
    local w = frame:GetWide()
    local h = frame:GetTall()

    local gap = math.min(w, h) * 0.06
    local gap2 = math.min(w, h) * 0.02

    local listW = w * 0.3
    local listH = h - 2 * gap

    local pnlW = w - (listW*2) - (gap*4)
    local pnlH = listH * 0.3

    local list2X = gap + listW + gap

    local pnlX = list2X + listW + gap
    local pnlY = gap + (listW / 2)

    local font = TARDIS:GetScreenFont(screen, "Default")
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
    players_list.players = {}

    players_list.AddPlayer = function(me, ply)
        local name = ply:Name()
        local steamid = ply:SteamID()
        
        me:AddLine(name)
        me.players[#me.players + 1] = {name=name, steamid=steamid}
    end

    players_list.PlayerAlreadyExists = function(me, ply)
        for _, v in ipairs(me.players) do
            if v.steamid ~= ply:SteamID() then continue end
            return true
        end

        return false
    end

    local panel = frame:Add("DPanel")
    panel:SetSize(pnlW, pnlH)
    panel:SetPos(pnlX, pnlY)
    panel:SetBackgroundColor(bgcolor)

    local add_player_btn = panel:Add("DButton")
    add_player_btn:Dock(BOTTOM)
    add_player_btn:DockMargin(gap2, gap2, gap2, gap2)
    add_player_btn:SetTall(panel:GetWide() * 0.25)
    add_player_btn:SetText("Add Player")
    add_player_btn:SetFont(font)

    local steamid_entry = panel:Add("DTextEntry3D2D")
    steamid_entry.is3D2D = screen.is3D2D
    steamid_entry:Dock(FILL)
    steamid_entry:DockMargin(gap2, gap2, gap2, 0) -- Don't need more padding on bottom, add_player_btn is giving us this
    steamid_entry:SetPlaceholderText("Enter a player steamid here")
    steamid_entry:SetFont(font)
--------------------------------------------------------------------------------
-- Loading data
--------------------------------------------------------------------------------
    -- Add online players to list
    for _, ply in ipairs(player.GetAll()) do
        if not isValid(ply) or ply == localPlayer() or players_list:PlayerAlreadyExists(ply) then continue end
        players_list:AddPlayer(ply)
    end
end)