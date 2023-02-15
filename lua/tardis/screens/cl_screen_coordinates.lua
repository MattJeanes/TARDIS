-- Destination

TARDIS:AddScreen("Destination", {id="coordinates", text="Screens.Coordinates", menu=false, order=2, popuponly=true}, function(self,ext,int,frame,screen)
    local a = frame:GetWide()
    local b = frame:GetTall()
    local d = 0.05 * math.min( a,b )
--Panels--
    local InputPanel = vgui.Create( "DPanel",frame )
    InputPanel:SetPos(0.5 * a + 0.5 * d, d)
    InputPanel:SetSize( (a - 4 * d) * 0.25, 0.25 * b -0.5*d )
    InputPanel:SetBackgroundColor( Color(90,87,143))

    local ip_a = InputPanel:GetWide()
    local ip_b = InputPanel:GetTall()
    local ip_d = 0.03 * math.min(a,b)

    local ip_x = (ip_a - 4 * ip_d) / 3
    local ip_y = (ip_b - 3 * ip_d) / 2

    local x = vgui.Create("DTextEntry",InputPanel)
    x:SetPlaceholderText("x")
    x:SetPos(ip_d, ip_d)
    x:SetSize(ip_x,ip_y)
    local y = vgui.Create("DTextEntry",InputPanel)
    y:SetPlaceholderText("y")
    y:SetPos(ip_x + 2 * ip_d, ip_d )
    y:SetSize(ip_x,ip_y)
    local z = vgui.Create("DTextEntry",InputPanel)
    z:SetPlaceholderText("z")
    z:SetPos(ip_x*2 + 3 * ip_d, ip_d)
    z:SetSize(ip_x,ip_y)

    local pitch = vgui.Create("DTextEntry",InputPanel)
    pitch:SetPlaceholderText("Pitch")
    pitch:SetPos(ip_d, ip_y + 2 * ip_d)
    pitch:SetSize(ip_x,ip_y)
    local yaw = vgui.Create("DTextEntry",InputPanel)
    yaw:SetPlaceholderText("Yaw")
    yaw:SetPos(ip_x + 2 * ip_d, ip_y + 2 * ip_d)
    yaw:SetSize(ip_x,ip_y)
    local roll = vgui.Create("DTextEntry",InputPanel)
    roll:SetPlaceholderText("Roll")
    roll:SetPos(ip_x*2 + 3 * ip_d, ip_y + 2 * ip_d)
    roll:SetSize(ip_x,ip_y)

    x:SetNumeric(true)
    y:SetNumeric(true)
    z:SetNumeric(true)
    pitch:SetNumeric(true)
    yaw:SetNumeric(true)
    roll:SetNumeric(true)


--[[    local DLabel = vgui.Create( "DLabel", DPanel )
    DLabel:SetPos( 10, 10 ) -- Set the position of the label
    DLabel:SetTexte label to a darker one( "I'm a DLabel inside a DPanel! :)" ) --  Set the text of the label
    DLabel:SizeToContents() -- Size the label to fit the text in it
    DLabel:SetDark( 1 ) -- Set the colour of the text inside th
]]

    local button=vgui.Create("DButton",frame)
    button:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.1 )
    button:SetPos(frame:GetWide()*0.86 - button:GetWide()*0.5,frame:GetTall()*0.08 - button:GetTall()*0.5)
    button:SetText(TARDIS:GetPhrase("Screens.Coordinates.SelectManually"))
    button:SetFont(TARDIS:GetScreenFont(screen, "Default"))
    button.DoClick = function()
        TARDIS:Control("destination", LocalPlayer())
        TARDIS:RemoveHUDScreen()
    end

    x:SetNumeric(true)
    y:SetNumeric(true)
    z:SetNumeric(true)
    pitch:SetNumeric(true)
    yaw:SetNumeric(true)
    roll:SetNumeric(true)

    local namebox = vgui.Create("DTextEntry", frame)
    namebox:SetPos(pitch:GetPos()+5,frame:GetTall()*0.33 - button:GetTall()*0.5)
    namebox:SetWide(frame:GetWide()*0.237)
    namebox:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Name"))

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


    local list = vgui.Create("DListView",frame)
    list:SetSize( (a-3*d)/2,(b-2*d) )
    list:SetPos( d,d )
    list:AddColumn("LOCATIONS LIST")

    local map = game.GetMap()
    local function updatelist()
        list:Clear()
        if TARDIS.Locations[map] ~= nil then
            for k,v in pairs(TARDIS.Locations[map]) do
                list:AddLine(v.name)
            end
        end
        list:AddLine(TARDIS:GetPhrase("Screens.Coordinates.RandomGround"))
        list:AddLine(TARDIS:GetPhrase("Screens.Coordinates.Random"))
    end
    updatelist()
    function list:OnRowSelected(i,row)
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
    list:SetMultiSelect(false)

    local gpos = vgui.Create("DButton", frame)
    gpos:SetSize( frame:GetWide()*0.247, frame:GetTall()*0.1 )
    gpos:SetPos(pitch:GetPos(),frame:GetTall()*0.4 - button:GetTall()*0.5)
    gpos:SetFont(TARDIS:GetScreenFont(screen, "Default"))
    gpos:SetText(TARDIS:GetPhrase("Screens.Coordinates.GetCurrentPosition"))

    function gpos:DoClick()
        updatetextinputs(ext:GetPos(), ext:GetAngles())
    end

    local new = vgui.Create("DButton", frame)
    new:SetSize( frame:GetWide()*0.08, frame:GetTall()*0.1 )
    new:SetPos(pitch:GetPos(),frame:GetTall()*0.9 - button:GetTall()*0.5)
    new:SetText(TARDIS:GetPhrase("Common.New"))
    new:SetFont(TARDIS:GetScreenFont(screen, "Default"))
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

    local remove = vgui.Create("DButton", frame)
    remove:SetSize( frame:GetWide()*0.08, frame:GetTall()*0.1 )
    remove:SetPos(roll:GetPos(),frame:GetTall()*0.52 - button:GetTall()*0.5)
    remove:SetText(TARDIS:GetPhrase("Common.Delete"))
    remove:SetFont(TARDIS:GetScreenFont(screen, "Default"))
    function remove:DoClick()
        local index = list:GetSelectedLine()
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
        if list:GetSelectedLine() ~= nil then
            if self:IsEnabled() then return end
            self:SetEnabled(true)
        elseif self:IsEnabled() then
            self:SetEnabled(false)
        end
    end

    local confirm = vgui.Create("DButton",frame)
    confirm:SetSize( frame:GetWide()*0.1, frame:GetTall()*0.1 )
    confirm:SetPos(yaw:GetPos()-15,frame:GetTall()*0.9 - button:GetTall()*0.5)
    confirm:SetText(TARDIS:GetPhrase("Common.Set"))
    confirm:SetFont(TARDIS:GetScreenFont(screen, "Default"))
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