-- Destination

TARDIS:AddScreen("Destination", {id="coordinates", text="Screens.Coordinates", menu=false, order=2, popuponly=true}, function(self,ext,int,frame,screen)
    local w = frame:GetWide()
    local h = frame:GetTall()
    local d = 0.05 * math.min( w,h )
--Panels--
    local llist = vgui.Create("DListView",frame)
    llist:SetSize( (w - 4 * d) / 2,(h - 2 * d) )
    llist:SetPos( d,d )
    llist:AddColumn("LOCATIONS LIST")

    local ip_w = (w - 4 * d) * 0.4
    local ip_h = 0.33 * h - 0.5 * d
    local ip_d = 0.02 * math.min(w,h)

    local ip_x = (ip_w - 4 * ip_d) / 3
    local ip_y = (ip_h - 4 * ip_d) / 3

    local cp_h = ip_h
    local cp_w = (w - 4 * d) * 0.1

    local cp_d = ip_d
    local cp_x = cp_w - 2 * cp_d
    local cp_y = ip_y

    local InputPanel = vgui.Create( "DPanel",frame )
    InputPanel:SetPos(0.5 * w, d)
    InputPanel:SetSize(ip_w, ip_h)
    InputPanel:SetBackgroundColor( Color(148,195,255))

    local ControlPanel = vgui.Create( "DPanel",frame )
    ControlPanel:SetPos(0.5 * w + ip_w + d, d)
    ControlPanel:SetSize(cp_w, cp_h)
    ControlPanel:SetBackgroundColor( Color(148,195,255))

    local x = vgui.Create("DTextEntry",InputPanel)
    x:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.X"))
    x:SetPos(ip_d, ip_d)
    x:SetSize(ip_x,ip_y)
    x:SetNumeric(true)
    local y = vgui.Create("DTextEntry",InputPanel)
    y:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Y"))
    y:SetPos(ip_x + 2 * ip_d, ip_d )
    y:SetSize(ip_x,ip_y)
    y:SetNumeric(true)
    local z = vgui.Create("DTextEntry",InputPanel)
    z:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Z"))
    z:SetPos(ip_x*2 + 3 * ip_d, ip_d)
    z:SetSize(ip_x,ip_y)
    z:SetNumeric(true)

    local pitch = vgui.Create("DTextEntry",InputPanel)
    pitch:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Pitch"))
    pitch:SetPos(ip_d, ip_y + 2 * ip_d)
    pitch:SetSize(ip_x,ip_y)
    pitch:SetNumeric(true)
    local yaw = vgui.Create("DTextEntry",InputPanel)
    yaw:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Yaw"))
    yaw:SetPos(ip_x + 2 * ip_d, ip_y + 2 * ip_d)
    yaw:SetSize(ip_x,ip_y)
    yaw:SetNumeric(true)
    local roll = vgui.Create("DTextEntry",InputPanel)
    roll:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Roll"))
    roll:SetPos(ip_x*2 + 3 * ip_d, ip_y + 2 * ip_d)
    roll:SetSize(ip_x,ip_y)
    roll:SetNumeric(true)

    local namebox = vgui.Create("DTextEntry", InputPanel)
    namebox:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Name"))
    namebox:SetPos(ip_d, 2 * ip_y + 3 * ip_d)
    namebox:SetSize(ip_w - 2 * ip_d, ip_y)

    local new = vgui.Create("DButton", ControlPanel)
    new:SetSize( cp_x, cp_y )
    new:SetPos( cp_d, cp_d )
    new:SetText(TARDIS:GetPhrase("Common.New"))
    new:SetFont(TARDIS:GetScreenFont(screen, "Default"))

    local remove = vgui.Create("DButton", ControlPanel)
    remove:SetSize( cp_x, cp_y )
    remove:SetPos(cp_d, cp_y + 2 * cp_d)
    remove:SetText(TARDIS:GetPhrase("Common.Delete"))
    remove:SetFont(TARDIS:GetScreenFont(screen, "Default"))

    local confirm = vgui.Create("DButton", ControlPanel)
    confirm:SetSize( cp_x, cp_y )
    confirm:SetPos(cp_d, 2 * cp_y + 3 * cp_d)
    confirm:SetText(TARDIS:GetPhrase("Common.Set"))
    confirm:SetFont(TARDIS:GetScreenFont(screen, "Default"))

    --[[
    local button=vgui.Create("DButton",frame)
    button:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.1 )
    button:SetPos(frame:GetWide()*0.86 - button:GetWide()*0.5,frame:GetTall()*0.08 - button:GetTall()*0.5)
    button:SetText(TARDIS:GetPhrase("Screens.Coordinates.SelectManually"))
    button:SetFont(TARDIS:GetScreenFont(screen, "Default"))
    button.DoClick = function()
        TARDIS:Control("destination", LocalPlayer())
        TARDIS:RemoveHUDScreen()
    end]]


    local function updatetextinputs(pos,ang,name)
        pitch:SetText(ang.p or 0.0)
        yaw:SetText(ang.y or 0.0)
        roll:SetText(ang.r or 0.0)
        x:SetText(pos.x or 0.0)
        y:SetText(pos.y or 0.0)
        z:SetText(pos.z or 0.0)
        if name then namebox:SetText(name) end
    end

    local function fetchtextinputs()
        local pos = 0
        local ang = 0
        local name = ""
        if x:GetText() ~= "" and y:GetText() ~= "" and z:GetText() ~= "" then
            pos = Vector(x:GetText() or 0, y:GetText() or 0, z:GetText() or 0)
        end
        if pitch:GetText() ~= "" and yaw:GetText() ~= "" and roll:GetText() ~= "" then
            ang = Angle(pitch:GetText() or 0, yaw:GetText() or 0, roll:GetText() or 0)
        end
        if namebox:GetText() ~= "" then
            name = namebox:GetText()
        end
        if name == "" then name = TARDIS:GetPhrase("Screens.Coordinates.Unnamed") end
        return pos,ang,name
    end
    if ext:GetData("demat-pos") and ext:GetData("demat-ang") then
        updatetextinputs(ext:GetData("demat-pos"), ext:GetData("demat-ang"), TARDIS:GetPhrase("Screens.Coordinates.CurrentSetDestination"))
        namebox:SetEnabled(false)
    end

    local pendingchanges = false

    local map = game.GetMap()
    local function updatelist()
        llist:Clear()
        if TARDIS.Locations[map] ~= nil then
            for k,v in pairs(TARDIS.Locations[map]) do
                llist:AddLine(v.name)
            end
        end
        llist:AddLine(TARDIS:GetPhrase("Screens.Coordinates.RandomGround"))
        llist:AddLine(TARDIS:GetPhrase("Screens.Coordinates.Random"))
    end
    updatelist()
    function llist:OnRowSelected(i,row)
        local locations_num = 0
        if TARDIS.Locations[map] ~= nil then
            locations_num = #TARDIS.Locations[map]
        end
        local name,pos,ang
        if i > locations_num then
            local ground = (i == locations_num + 1)
            local ext = LocalPlayer():GetTardisData("exterior")
            local randomLocation = ext:GetRandomLocation(ground)
            if randomLocation then
                pos = randomLocation
            else
                pos = ext:GetPos()
            end
            ang = {p = 0, y = 0, r = 0}
            if ground then
                name = TARDIS:GetPhrase("Screens.Coordinates.RandomLocationGround")
            else
                name = TARDIS:GetPhrase("Screens.Coordinates.RandomLocation")
            end
        else
            pos = TARDIS.Locations[map][i].pos
            ang = TARDIS.Locations[map][i].ang
            name = TARDIS.Locations[map][i].name
        end
        updatetextinputs(pos,ang,name)
        namebox:SetEnabled(true)
    end
    llist:SetMultiSelect(false)

    local gpos = vgui.Create("DButton", frame)
    gpos:SetSize( frame:GetWide()*0.247, frame:GetTall()*0.1 )
    gpos:SetPos(pitch:GetPos(),frame:GetTall()*0.4 - frame:GetTall() * 0.1*0.5)
    gpos:SetFont(TARDIS:GetScreenFont(screen, "Default"))
    gpos:SetText(TARDIS:GetPhrase("Screens.Coordinates.GetCurrentPosition"))

    function gpos:DoClick()
        updatetextinputs(ext:GetPos(), ext:GetAngles())
    end

    function new:DoClick()

        local vortex = ext:GetData("vortex", false)

        local request = vortex and "Screens.Coordinates.NameNewLocationFromInputs" or "Screens.Coordinates.NameNewLocation"

        local pos, ang, name = fetchtextinputs()

        Derma_StringRequest(
            TARDIS:GetPhrase("Screens.Coordinates.NewLocation"),
            TARDIS:GetPhrase(request),
            TARDIS:GetPhrase("Screens.Coordinates.NewLocation"),
            function(text)
                name = text
                if vortex then
                    TARDIS:AddLocation(pos,ang,name,map)
                    updatelist()
                else
                    Derma_Query(
                        TARDIS:GetPhrase("Screens.Coordinates.NewLocationUseCurrentPos", "Common.No"),
                        TARDIS:GetPhrase("Screens.Coordinates.NewLocation"),
                        TARDIS:GetPhrase("Common.Yes"),
                        function()
                            pos = ext:GetPos()
                            ang = ext:GetAngles()
                            if name == "" then name = TARDIS:GetPhrase("Screens.Coordinates.Unnamed") end
                            TARDIS:AddLocation(pos,ang,name,map)
                            updatelist()
                        end,
                        TARDIS:GetPhrase("Common.No"),
                        function()
                            TARDIS:AddLocation(pos,ang,name,map)
                            updatelist()
                        end
                    )
                end
            end
        )
    end

    function remove:DoClick()
        local index = llist:GetSelectedLine()
        if not index then return end
        Derma_Query(
            TARDIS:GetPhrase("Screens.Coordinates.ConfirmRemoveLocation"),
            TARDIS:GetPhrase("Screens.Coordinates.RemoveLocation"),
            TARDIS:GetPhrase("Common.Yes"),
            function() TARDIS:RemoveLocation(map,index) updatelist() pendingchanges = true end,
            TARDIS:GetPhrase("Common.No")
        )
    end
    function remove:Think()
        if llist:GetSelectedLine() ~= nil then
            if self:IsEnabled() then return end
            self:SetEnabled(true)
        elseif self:IsEnabled() then
            self:SetEnabled(false)
        end
    end

    function confirm:DoClick()
        local pos,ang = fetchtextinputs()
        if pos ~= nil and pos ~= 0 then
            ext:SendMessage("destination-demat", { pos, ang } )
            if TARDIS:GetSetting("dest-onsetdemat") then
                TARDIS:RemoveHUDScreen()
            end
        else
            TARDIS:ErrorMessage(LocalPlayer(), "Screens.Coordinates.NoDestinationSet")
        end
    end

    function frame:OnCloseScreen()
        local result = true
        if not pendingchanges then return end
        Derma_Query(
            TARDIS:GetPhrase("Common.UnsavedChangesWarning"),
            TARDIS:GetPhrase("Common.UnsavedChanges"),
            TARDIS:GetPhrase("Common.Yes"),
            function()
                TARDIS:SaveLocations()
                pendingchanges = false
                TARDIS:RemoveHUDScreen()
            end,
            TARDIS:GetPhrase("Common.No"),
            function()
                pendingchanges = false
                TARDIS:RemoveHUDScreen()
            end,
            TARDIS:GetPhrase("Common.Cancel"),
            function()

            end
        )
        return false;
    end

end)