-- Destination

local function make_list_line_clickable(line, frame)
    local l = vgui.Create("DLabel", line:GetParent():GetParent())
    l:SetTall(34)
    l:SetBGColor(Color(0,0,0,0))
    l:SetColor(Color(0,0,0,0))
    --l:SetText("AAAAAAAAAAAAAAAAAAAAAA")
    --l:SetDark(true)
    --l:SetVisible(false)

    line.Columns[1]:SetFont("DermaLarge")

    local scrollbar = line:GetParent():GetParent().VBar

    l.Think = function()
        if not IsValid(line) then
            l:Remove()
            return
        end
        line:PerformLayout()
        line:DataLayout(line:GetParent():GetParent())
        local sb_wide = scrollbar:GetWide()
        if l:GetWide() ~= line:GetWide() - sb_wide then
            l:SetWide(line:GetWide() - sb_wide)
        end

        if l.scrollbar_pos == scrollbar:GetOffset() then return end

        l.scrollbar_pos = scrollbar:GetOffset()
        local pos1x, pos1y = line:GetPos()
        local pos2x, pos2y = line:GetParent():GetPos()
        --local pos3x, pos3y = line:GetParent():GetParent():GetPos()
        --local pos4x, pos4y = line:GetParent():GetParent():GetParent():GetPos()
        local posx = pos1x + pos2x --+ pos3x + pos4x
        local posy = pos1y + pos2y --+ pos3y + pos4y
        l:SetPos(posx, posy)
    end
    l.DoClick = function()
        line:GetParent():GetParent():OnClickLine(line, true)
    end
end

TARDIS:AddScreen("Destination", {id="coordinates", text="Screens.Coordinates", menu=false, order=2, popuponly=false}, function(self,ext,int,frame,screen)
    local w = frame:GetWide()
    local h = frame:GetTall()
    local d = 0.05 * math.min( w,h )
    local round_digits = 4

    local llist = vgui.Create("DListView",frame)
    llist:SetSize( (w - 3 * d) / 2,(h - 2 * d) )
    llist:SetPos( d,d )
    llist:AddColumn("LOCATIONS LIST")

    local panel_w = (w - 3 * d) / 2
    local panel_h = (h - 4 * d) / 3
    local panel_d = 0.02 * math.min(w,h)
    local panel_left = 0.5 * w + 0.5 * d

    local PositionPanel = vgui.Create( "DPanel",frame )
    PositionPanel:SetPos(panel_left, d)
    PositionPanel:SetSize(panel_w, panel_h)
    PositionPanel:SetBackgroundColor( Color(148,195,255))

    local pos_elem_w = (panel_w - 5 * panel_d) / 4
    local pos_elem_h = (panel_h - 4 * panel_d) / 3

    local pos_title = vgui.Create("DLabel",PositionPanel)
    pos_title:SetText("Current position:")
    pos_title:SetPos(panel_d, panel_d)
    pos_title:SetSize(panel_w - 2 * panel_d, pos_elem_h)
    pos_title:SetDark(true)
    pos_title:SetFont("DermaDefaultBold")

    local pos_x = vgui.Create("DTextEntry",PositionPanel)
    pos_x:SetPlaceholderText("")
    pos_x:SetPos(panel_d, pos_elem_h + 2 * panel_d)
    pos_x:SetSize(pos_elem_w,pos_elem_h)
    pos_x:SetNumeric(true)
    pos_x:SetEnabled(false)
    pos_x.Think = function(self) 
        if IsValid(ext) then
            if ext:GetData("vortex") then
                self:SetText(math.random(-99999999, 99999999) * 0.0001)
            else
                self:SetText(math.Round(ext:GetPos().x, round_digits))
            end
        end
    end

    local pos_y = vgui.Create("DTextEntry",PositionPanel)
    pos_y:SetPlaceholderText("")
    pos_y:SetPos(pos_elem_w + 2 * panel_d, pos_elem_h + 2 * panel_d)
    pos_y:SetSize(pos_elem_w,pos_elem_h)
    pos_y:SetNumeric(true)
    pos_y:SetEnabled(false)
    pos_y.Think = function(self) 
        if IsValid(ext) then
            if ext:GetData("vortex") then
                self:SetText(math.random(-99999999, 99999999) * 0.0001)
            else
                self:SetText(math.Round(ext:GetPos().y, round_digits))
            end
        end
    end

    local pos_z = vgui.Create("DTextEntry",PositionPanel)
    pos_z:SetPlaceholderText("")
    pos_z:SetPos(pos_elem_w*2 + 3 * panel_d, pos_elem_h + 2 * panel_d)
    pos_z:SetSize(pos_elem_w,pos_elem_h)
    pos_z:SetNumeric(true)
    pos_z:SetEnabled(false)
    pos_z.Think = function(self) 
        if IsValid(ext) then
            if ext:GetData("vortex") then
                self:SetText(math.random(-99999999, 99999999) * 0.0001)
            else
                self:SetText(math.Round(ext:GetPos().z, round_digits))
            end
        end
    end

    local pos_pitch = vgui.Create("DTextEntry",PositionPanel)
    pos_pitch:SetPlaceholderText("")
    pos_pitch:SetPos(panel_d, 2 * pos_elem_h + 3 * panel_d)
    pos_pitch:SetSize(pos_elem_w,pos_elem_h)
    pos_pitch:SetNumeric(true)
    pos_pitch:SetEnabled(false)
    pos_pitch.Think = function(self) 
        if IsValid(ext) then
            self:SetText(math.Round(ext:GetAngles().p, round_digits))
        end
    end

    local pos_yaw = vgui.Create("DTextEntry",PositionPanel)
    pos_yaw:SetPlaceholderText("")
    pos_yaw:SetPos(pos_elem_w + 2 * panel_d, 2 * pos_elem_h + 3 * panel_d)
    pos_yaw:SetSize(pos_elem_w,pos_elem_h)
    pos_yaw:SetNumeric(true)
    pos_yaw:SetEnabled(false)
    pos_yaw.Think = function(self) 
        if IsValid(ext) then
            self:SetText(math.Round(ext:GetAngles().y, round_digits))
        end
    end

    local pos_roll = vgui.Create("DTextEntry",PositionPanel)
    pos_roll:SetPlaceholderText("")
    pos_roll:SetPos(pos_elem_w * 2 + 3 * panel_d, 2 * pos_elem_h + 3 * panel_d)
    pos_roll:SetSize(pos_elem_w,pos_elem_h)
    pos_roll:SetNumeric(true)
    pos_roll:SetEnabled(false)
    pos_roll.Think = function(self) 
        if IsValid(ext) then
            self:SetText(math.Round(ext:GetAngles().r, round_digits))
        end
    end

    local pos_save = vgui.Create("DButton", PositionPanel)
    pos_save:SetSize(pos_elem_w,pos_elem_h)
    pos_save:SetPos(pos_elem_w * 3 + 4 * panel_d, pos_elem_h + 2 * panel_d)
    pos_save:SetText("Save") -- TODO
    pos_save:SetFont(TARDIS:GetScreenFont(screen, "Default"))

    local pos_copy = vgui.Create("DButton", PositionPanel)
    pos_copy:SetSize(pos_elem_w,pos_elem_h)
    pos_copy:SetPos(pos_elem_w * 3 + 4 * panel_d, 2 * pos_elem_h + 3 * panel_d)
    pos_copy:SetText("Edit")  -- TODO
    pos_copy:SetFont(TARDIS:GetScreenFont(screen, "Default"))





    local DestinationPanel = vgui.Create( "DPanel",frame )
    DestinationPanel:SetPos(panel_left, 2 * d + panel_h)
    DestinationPanel:SetSize(panel_w, panel_h)
    DestinationPanel:SetBackgroundColor( Color(148,195,255))

    local dst_elem_w = (panel_w - 5 * panel_d) / 4
    local dst_elem_h = (panel_h - 4 * panel_d) / 3

    local dst_title = vgui.Create("DLabel",DestinationPanel)
    dst_title:SetText("Destination:")
    dst_title:SetPos(panel_d, panel_d)
    dst_title:SetSize(panel_w - 2 * panel_d, dst_elem_h)
    dst_title:SetDark(true)
    dst_title:SetFont("DermaDefaultBold")

    local dst_x = vgui.Create("DTextEntry",DestinationPanel)
    dst_x:SetPlaceholderText("")
    dst_x:SetPos(panel_d, dst_elem_h + 2 * panel_d)
    dst_x:SetSize(dst_elem_w,dst_elem_h)
    dst_x:SetNumeric(true)
    dst_x:SetEnabled(false)
    dst_x.Think = function(self)
        if not IsValid(ext) then return end
        local dst = ext:GetDestPos()
        if not dst then return self:SetText("") end
        self:SetText(math.Round(dst.x, round_digits))
    end

    local dst_y = vgui.Create("DTextEntry",DestinationPanel)
    dst_y:SetPlaceholderText("")
    dst_y:SetPos(dst_elem_w + 2 * panel_d, dst_elem_h + 2 * panel_d)
    dst_y:SetSize(dst_elem_w,dst_elem_h)
    dst_y:SetNumeric(true)
    dst_y:SetEnabled(false)
    dst_y.Think = function(self)
        if not IsValid(ext) then return end
        local dst = ext:GetDestPos()
        if not dst then return self:SetText("") end
        self:SetText(math.Round(dst.y, round_digits))
    end

    local dst_z = vgui.Create("DTextEntry",DestinationPanel)
    dst_z:SetPlaceholderText("")
    dst_z:SetPos(dst_elem_w*2 + 3 * panel_d, dst_elem_h + 2 * panel_d)
    dst_z:SetSize(dst_elem_w,dst_elem_h)
    dst_z:SetNumeric(true)
    dst_z:SetEnabled(false)
    dst_z.Think = function(self)
        if not IsValid(ext) then return end
        local dst = ext:GetDestPos()
        if not dst then return self:SetText("") end
        self:SetText(math.Round(dst.z, round_digits))
    end

    local dst_pitch = vgui.Create("DTextEntry",DestinationPanel)
    dst_pitch:SetPlaceholderText("")
    dst_pitch:SetPos(panel_d, 2 * dst_elem_h + 3 * panel_d)
    dst_pitch:SetSize(dst_elem_w,dst_elem_h)
    dst_pitch:SetNumeric(true)
    dst_pitch:SetEnabled(false)
    dst_pitch.Think = function(self)
        if not IsValid(ext) then return end
        local dst = ext:GetDestAng()
        if not dst then return self:SetText("") end
        self:SetText(math.Round(dst.p, round_digits))
    end

    local dst_yaw = vgui.Create("DTextEntry",DestinationPanel)
    dst_yaw:SetPlaceholderText("")
    dst_yaw:SetPos(dst_elem_w + 2 * panel_d, 2 * dst_elem_h + 3 * panel_d)
    dst_yaw:SetSize(dst_elem_w,dst_elem_h)
    dst_yaw:SetNumeric(true)
    dst_yaw:SetEnabled(false)
    dst_yaw.Think = function(self)
        if not IsValid(ext) then return end
        local dst = ext:GetDestAng()
        if not dst then return self:SetText("") end
        self:SetText(math.Round(dst.y, round_digits))
    end

    local dst_roll = vgui.Create("DTextEntry",DestinationPanel)
    dst_roll:SetPlaceholderText("")
    dst_roll:SetPos(dst_elem_w * 2 + 3 * panel_d, 2 * dst_elem_h + 3 * panel_d)
    dst_roll:SetSize(dst_elem_w,dst_elem_h)
    dst_roll:SetNumeric(true)
    dst_roll:SetEnabled(false)
    dst_roll.Think = function(self)
        if not IsValid(ext) then return end
        local dst = ext:GetDestAng()
        if not dst then return self:SetText("") end
        self:SetText(math.Round(dst.r, round_digits))
    end

    local dst_save = vgui.Create("DButton", DestinationPanel)
    dst_save:SetSize(dst_elem_w,dst_elem_h)
    dst_save:SetPos(dst_elem_w * 3 + 4 * panel_d, dst_elem_h + 2 * panel_d)
    dst_save:SetText("Save") -- TODO
    dst_save:SetFont(TARDIS:GetScreenFont(screen, "Default"))
    dst_save.Think = function(self)
        if not IsValid(ext) then return end
        local dst = ext:GetDestAng()
        self:SetEnabled(dst ~= nil)
    end

    local dst_copy = vgui.Create("DButton", DestinationPanel)
    dst_copy:SetSize(dst_elem_w,dst_elem_h)
    dst_copy:SetPos(dst_elem_w * 3 + 4 * panel_d, 2 * dst_elem_h + 3 * panel_d)
    dst_copy:SetText("Edit")  -- TODO
    dst_copy:SetFont(TARDIS:GetScreenFont(screen, "Default"))
    dst_copy.Think = function(self)
        if not IsValid(ext) then return end
        local dst = ext:GetDestAng()
        self:SetEnabled(dst ~= nil)
    end




    local InputPanel = vgui.Create( "DPanel",frame )
    InputPanel:SetPos(panel_left, 3 * d + 2 * panel_h)
    InputPanel:SetSize(panel_w, panel_h)
    InputPanel:SetBackgroundColor( Color(148,195,255))

    local inp_elem_w = (panel_w - 5 * panel_d) / 4
    local inp_elem_h = (panel_h - 4 * panel_d) / 3

    local x = vgui.Create("DTextEntry",InputPanel)
    x:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.X"))
    x:SetPos(panel_d, panel_d)
    x:SetSize(inp_elem_w,inp_elem_h)
    x:SetNumeric(true)
    local y = vgui.Create("DTextEntry",InputPanel)
    y:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Y"))
    y:SetPos(inp_elem_w + 2 * panel_d, panel_d )
    y:SetSize(inp_elem_w,inp_elem_h)
    y:SetNumeric(true)
    local z = vgui.Create("DTextEntry",InputPanel)
    z:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Z"))
    z:SetPos(inp_elem_w*2 + 3 * panel_d, panel_d)
    z:SetSize(inp_elem_w,inp_elem_h)
    z:SetNumeric(true)

    local pitch = vgui.Create("DTextEntry",InputPanel)
    pitch:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Pitch"))
    pitch:SetPos(panel_d, inp_elem_h + 2 * panel_d)
    pitch:SetSize(inp_elem_w,inp_elem_h)
    pitch:SetNumeric(true)
    local yaw = vgui.Create("DTextEntry",InputPanel)
    yaw:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Yaw"))
    yaw:SetPos(inp_elem_w + 2 * panel_d, inp_elem_h + 2 * panel_d)
    yaw:SetSize(inp_elem_w,inp_elem_h)
    yaw:SetNumeric(true)
    local roll = vgui.Create("DTextEntry",InputPanel)
    roll:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Roll"))
    roll:SetPos(inp_elem_w * 2 + 3 * panel_d, inp_elem_h + 2 * panel_d)
    roll:SetSize(inp_elem_w,inp_elem_h)
    roll:SetNumeric(true)

    local namebox = vgui.Create("DTextEntry", InputPanel)
    namebox:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Name"))
    namebox:SetPos(panel_d, 2 * inp_elem_h + 3 * panel_d)
    namebox:SetSize(panel_w - 3 * panel_d - inp_elem_w, inp_elem_h)


    local new = vgui.Create("DButton", InputPanel)
    new:SetSize(inp_elem_w,inp_elem_h)
    new:SetPos( inp_elem_w * 3 + 4 * panel_d, panel_d )
    new:SetText("Save") -- TODO
    new:SetFont(TARDIS:GetScreenFont(screen, "Default"))

    local remove = vgui.Create("DButton", InputPanel)
    remove:SetSize(inp_elem_w,inp_elem_h)
    remove:SetPos(inp_elem_w * 3 + 4 * panel_d, inp_elem_h + 2 * panel_d)
    remove:SetText("Delete")  -- TODO
    remove:SetFont(TARDIS:GetScreenFont(screen, "Default"))

    local confirm = vgui.Create("DButton", InputPanel)
    confirm:SetSize(inp_elem_w,inp_elem_h)
    confirm:SetPos(inp_elem_w * 3 + 4 * panel_d, 2 * inp_elem_h + 3 * panel_d)
    confirm:SetText("Set")  -- TODO
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

        if screen.is3D2D then
            llist:SetDataHeight(34)
            llist:SetHeaderHeight(0)
            llist:SetHideHeaders(true)
            llist:SetDirty( true )
            llist:PerformLayout()

            for k,v in pairs(llist:GetLines()) do
                make_list_line_clickable(v, frame)
            end
        end
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

    --[[
    local gpos = vgui.Create("DButton", frame)
    gpos:SetSize( frame:GetWide()*0.247, frame:GetTall()*0.1 )
    gpos:SetPos(pitch:GetPos(),frame:GetTall()*0.4 - frame:GetTall() * 0.1*0.5)
    gpos:SetFont(TARDIS:GetScreenFont(screen, "Default"))
    gpos:SetText(TARDIS:GetPhrase("Screens.Coordinates.GetCurrentPosition"))

    function gpos:DoClick()
        updatetextinputs(ext:GetPos(), ext:GetAngles())
    end]]

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
        if index > #TARDIS.Locations[map] then return end
        Derma_Query(
            TARDIS:GetPhrase("Screens.Coordinates.ConfirmRemoveLocation"),
            TARDIS:GetPhrase("Screens.Coordinates.RemoveLocation"),
            TARDIS:GetPhrase("Common.Yes"),
            function()
                TARDIS:RemoveLocation(map,index)
                updatelist()
            end,
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


end)