-- Destination

TARDIS:AddScreen("Destination", {id="coordinates", text="Screens.Coordinates", menu=false, order=2, popuponly=true}, function(self,ext,int,frame,screen)
    local button=vgui.Create("DButton",frame)
    button:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.1 )
    button:SetPos(frame:GetWide()*0.86 - button:GetWide()*0.5,frame:GetTall()*0.08 - button:GetTall()*0.5)
    button:SetText(TARDIS:GetPhrase("Screens.Coordinates.SelectManually"))
    button:SetFont(TARDIS:GetScreenFont(screen, "Default"))
    button.DoClick = function()
        TARDIS:Control("destination", LocalPlayer())
        TARDIS:RemoveHUDScreen()
    end

    local btnx,btny = button:GetPos()
    local x = vgui.Create("DTextEntry",frame)
    x:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.X"))
    x:SetPos(btnx*0.97,btny*5)
    local y = vgui.Create("DTextEntry",frame)
    y:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Y"))
    y:SetPos(btnx*1.08,btny*5)
    local z = vgui.Create("DTextEntry",frame)
    z:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Z"))
    z:SetPos(btnx*1.19,btny*5)


    local pitch = vgui.Create("DTextEntry",frame)
    pitch:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Pitch"))
    pitch:SetPos(btnx*0.97,btny*7)
    local yaw = vgui.Create("DTextEntry",frame)
    yaw:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Yaw"))
    yaw:SetPos(btnx*1.08,btny*7)
    local roll = vgui.Create("DTextEntry",frame)
    roll:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Roll"))
    roll:SetPos(btnx*1.19,btny*7)

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
    list:SetSize( frame:GetWide()*0.7, frame:GetTall()*0.95 )
    list:SetPos( frame:GetWide()*0.26 - list:GetWide()*0.35, frame:GetTall()*0.5 - list:GetTall()*0.5 )
    list:AddColumn("Name")

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
    new:SetPos(pitch:GetPos(),frame:GetTall()*0.52 - button:GetTall()*0.5)
    new:SetText(TARDIS:GetPhrase("Common.New"))
    new:SetFont(TARDIS:GetScreenFont(screen, "Default"))
    function new:DoClick()
        local name = ""
        local pos = Vector(0,0,0)
        local ang = Angle(0,0,0)
        local vortex = ext:GetData("vortex", false)

        local request = vortex and "Screens.Coordinates.NameNewLocationFromInputs" or "Screens.Coordinates.NameNewLocation"

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

    local edit = vgui.Create("DButton", frame)
    edit:SetSize( frame:GetWide()*0.08, frame:GetTall()*0.1 )
    edit:SetPos(yaw:GetPos(),frame:GetTall()*0.52 - button:GetTall()*0.5)
    edit:SetText(TARDIS:GetPhrase("Common.Update"))
    edit:SetFont(TARDIS:GetScreenFont(screen, "Default"))
    edit:SetEnabled(false)
    function edit:DoClick()
        pendingchanges = true
        local pos,ang,name = fetchtextinputs()
        local index = list:GetSelectedLine()
        if not index then return end
        TARDIS:UpdateLocation(pos,ang,name,map,index)
        updatelist()
    end
    function edit:Think()
        if list:GetSelectedLine() ~= nil then
            if self:IsEnabled() then return end
            self:SetEnabled(true)
        elseif self:IsEnabled() then
            self:SetEnabled(false)
        end
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

    local save = vgui.Create("DButton", frame)
    save:SetSize( frame:GetWide()*0.07, frame:GetTall()*0.1 )
    save:SetPos(frame:GetWide()*0.82 - save:GetWide()*0.5, frame:GetTall()*0.64 - save:GetTall()*0.5)
    save:SetText(TARDIS:GetPhrase("Common.Save"))
    save:SetFont(TARDIS:GetScreenFont(screen, "Default"))
    function save:DoClick()
        TARDIS:SaveLocations()
        pendingchanges = false
        TARDIS:Message(LocalPlayer(), "Screens.Coordinates.Saved")
    end
    function save:Think()
        if pendingchanges then
            self:SetText(TARDIS:GetPhrase("Common.Save").."*")
        else
            self:SetText(TARDIS:GetPhrase("Common.Save"))
        end
    end
    local load = vgui.Create("DButton", frame)
    load:SetSize( frame:GetWide()*0.07, frame:GetTall()*0.1 )
    load:SetPos(frame:GetWide()*0.9 - load:GetWide()*0.5, frame:GetTall()*0.64 - load:GetTall()*0.5)
    load:SetText(TARDIS:GetPhrase("Common.Load"))
    load:SetFont(TARDIS:GetScreenFont(screen, "Default"))
    function load:DoClick()
        TARDIS:LoadLocations()
        updatelist()
        pendingchanges = false
        TARDIS:Message(LocalPlayer(), "Screens.Coordinates.Loaded")
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