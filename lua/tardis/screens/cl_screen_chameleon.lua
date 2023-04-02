TARDIS:AddScreen("Chameleon", {id="chameleon", text="Screens.Chameleon", menu=false, order=4, popuponly=false}, function(self,ext,int,frame,screen)
    local frW = frame:GetWide()
    local frT = frame:GetTall()

    local gap = math.min(frT, frW) * 0.05 * 1.2
    local gap2 = math.min(frT, frW) * 0.02

    local listW = frW - 2 * gap
    local listT = frT - 2 * gap
    local tbW = frW - 4 * gap - 2 * listW - 2 * gap2
    local tbT = frT * 0.1
    local bW = 0.5 * (tbW - gap2)
    local bT = frT * 0.1

    local midX = 3 * gap + 2 * listW

    local background=vgui.Create("DImage", frame)
    local theme = TARDIS:GetScreenGUITheme(screen)
    local background_img = TARDIS:GetGUIThemeElement(theme, "backgrounds", "music")
    background:SetImage(background_img)
    background:SetSize(frW, frT)
    local bgcolor = TARDIS:GetScreenGUIColor(screen)

    local list_interiors
    local list_custom

    if screen.is3D2D then
        list_interiors = ListView3D:new(frame,screen,34,bgcolor)
    else
        list_interiors = vgui.Create("DListView",frame)
    end


    list_interiors:SetSize(listW, listT)
    list_interiors:SetPos(gap, gap)
    list_interiors:AddColumn(TARDIS:GetPhrase("Screens.Music.DefaultMusic"))
    list_interiors:SetMultiSelect(false)

    local exteriors = {}

    list_interiors:Clear()
    for k,v in pairs(TARDIS:GetExteriors()) do
        if v.Base ~= true then
            table.insert(exteriors, {k, v.Name or v.ID})
        end
    end

    for i,v in ipairs(exteriors) do
        list_interiors:AddLine(v[2])
    end

    local change_id

    function list_interiors:OnRowSelected(rowIndex, row)
        change_id = exteriors[rowIndex][1]

        if list_interiors:GetSelectedLine() and change_id ~= nil then
            ext:ChangeExterior(change_id, true)
        end
    end

    function list_interiors:DoDoubleClick(rowIndex, row)

    end

end)