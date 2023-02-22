-- Destination

TARDIS:AddScreen("Destination", {id="coordinates", text="Screens.Coordinates", menu=false, order=2, popuponly=false}, function(self,ext,int,frame,screen)
    local w = frame:GetWide()
    local h = frame:GetTall()
    local d = 0.05 * math.min( w,h )
    local round_digits = 4
    local font = TARDIS:GetScreenFont(screen, "Default")
    local bgcolor = Color(148,195,255,150)

    local background=vgui.Create("DImage", frame)

    local theme = TARDIS:GetScreenGUITheme(screen)
    local background_img = TARDIS:GetGUIThemeElement(theme, "backgrounds", "coordinates")
    background:SetImage(background_img)
    background:SetSize(w, h)

    local function randomize_coordinate(self)
        self:SetText(math.random(-99999999, 99999999) * 0.0001)
    end

    local llist
    if screen.is3D2D then
        llist = ListView3D:new(frame,screen,34,bgcolor)
    else
        llist = vgui.Create("DListView",frame)
    end
    llist:SetSize( (w - 3 * d) / 2,(h - 2 * d) )
    llist:SetPos( d,d )
    llist:AddColumn("LOCATIONS LIST")

    local panel_w = (w - 3 * d) / 2
    local panel_h = (h - 4 * d) / 3
    local panel_d = (screen.is3D2D and 0.01 or 0.02) * math.min(w,h)
    local panel_left = 0.5 * w + 0.5 * d

    local PositionPanel = vgui.Create( "DPanel",frame )
    PositionPanel:SetPos(panel_left, d)
    PositionPanel:SetSize(panel_w, panel_h)
    PositionPanel:SetBackgroundColor( bgcolor)

    local pos_elem_w = (panel_w - 5 * panel_d) / 4
    local pos_elem_h = (panel_h - 4 * panel_d) / 3

    local pos_title = vgui.Create("DLabel",PositionPanel)
    pos_title:SetText("Current position:")
    pos_title:SetPos(panel_d, panel_d)
    pos_title:SetSize(panel_w - 2 * panel_d, pos_elem_h)
    pos_title:SetDark(true)
    pos_title:SetFont(font)

    local pos_x = vgui.Create("DTextEntry",PositionPanel)
    pos_x:SetPlaceholderText("")
    pos_x:SetPos(panel_d, pos_elem_h + 2 * panel_d)
    pos_x:SetSize(pos_elem_w,pos_elem_h)
    pos_x:SetNumeric(true)
    pos_x:SetEnabled(false)
    pos_x:SetFont(font)
    pos_x.Think = function(self)
        if IsValid(ext) then
            if ext:GetData("vortex") then
                randomize_coordinate(self)
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
    pos_y:SetFont(font)
    pos_y.Think = function(self)
        if IsValid(ext) then
            if ext:GetData("vortex") then
                randomize_coordinate(self)
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
    pos_z:SetFont(font)
    pos_z.Think = function(self)
        if IsValid(ext) then
            if ext:GetData("vortex") then
                randomize_coordinate(self)
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
    pos_pitch:SetFont(font)
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
    pos_yaw:SetFont(font)
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
    pos_roll:SetFont(font)
    pos_roll.Think = function(self)
        if IsValid(ext) then
            self:SetText(math.Round(ext:GetAngles().r, round_digits))
        end
    end

    local pos_save = vgui.Create("DButton", PositionPanel)
    pos_save:SetSize(pos_elem_w,pos_elem_h)
    pos_save:SetPos(pos_elem_w * 3 + 4 * panel_d, pos_elem_h + 2 * panel_d)
    pos_save:SetText("Save") -- TODO
    pos_save:SetFont(font)
    pos_save.Think = function(self)
        if not IsValid(ext) then return end
        if self:IsEnabled() == ext:GetData("vortex") then
            self:SetEnabled(not ext:GetData("vortex"))
        end
    end

    local pos_copy = vgui.Create("DButton", PositionPanel)
    pos_copy:SetSize(pos_elem_w,pos_elem_h)
    pos_copy:SetPos(pos_elem_w * 3 + 4 * panel_d, 2 * pos_elem_h + 3 * panel_d)
    pos_copy:SetText("Copy")  -- TODO
    pos_copy:SetFont(font)
    pos_copy.Think = function(self)
        if not IsValid(ext) then return end
        if self:IsEnabled() == ext:GetData("vortex") then
            self:SetEnabled(not ext:GetData("vortex"))
        end
    end



    local DestinationPanel = vgui.Create( "DPanel",frame )
    DestinationPanel:SetPos(panel_left, 2 * d + panel_h)
    DestinationPanel:SetSize(panel_w, panel_h)
    DestinationPanel:SetBackgroundColor( bgcolor)

    local dst_elem_w = (panel_w - 5 * panel_d) / 4
    local dst_elem_h = (panel_h - 4 * panel_d) / 3

    local dst_title = vgui.Create("DLabel",DestinationPanel)
    dst_title:SetText("Destination:")
    dst_title:SetPos(panel_d, panel_d)
    dst_title:SetSize(panel_w - 2 * panel_d, dst_elem_h)
    dst_title:SetDark(true)
    dst_title:SetFont(font)

    local dst_progress = vgui.Create("DProgress", DestinationPanel)
    dst_progress:SetSize(dst_elem_w * 2 + panel_d, dst_elem_h / 3)
    dst_progress:SetPos(dst_elem_w + 2 * panel_d, panel_d + dst_elem_h / 3)

    dst_title.Think = function(self)
        if not IsValid(ext) then return end

        if not ext:GetData("teleport") and not ext:GetData("vortex") then
            if dst_progress:IsVisible() then
                dst_progress:SetVisible(false)
                dst_progress:SetFraction(0)
            end
            return
        end
        dst_progress:SetVisible(true)

        local tp_metadata = ext.metadata.Exterior.Teleport
        local fast = ext:GetData("demat-fast")

        if ext:GetData("demat") then
            local steps = #tp_metadata.DematSequence - 1
            local step = ext:GetData("step") - 1
            if step >= steps then return end

            local a_target = tp_metadata.DematSequence[step + 1]
            local a_prev = tp_metadata.DematSequence[step]
            if a_prev == nil then a_prev = 255 end

            local a = ext:GetData("alpha",255)
            if a_prev == a_target then return end


            local progress = step / steps
            progress = progress + (1 - math.abs((a - a_target) / (a_prev - a_target))) / steps

            dst_progress:SetFraction((fast and 0.55 or 0.45) * progress)
            return
        end

        if ext:GetData("mat") then
            local steps = #tp_metadata.MatSequence - 1
            local step = ext:GetData("step") - 1
            if step >= steps then return end

            local a_target = tp_metadata.MatSequence[step + 1]
            local a_prev = tp_metadata.MatSequence[step]
            if a_prev == nil then a_prev = 0 end

            local a = ext:GetData("alpha",255)
            if a_prev == a_target then return end

            local progress = step / steps
            progress = progress + (1 - math.abs((a - a_target) / (a_prev - a_target))) / steps

            dst_progress:SetFraction(0.7 + 0.3 * progress)
            return
        end

        if ext:GetData("vortex") and not ext:GetData("teleport") then
            if fast then
                dst_progress:SetFraction(0.55)
            else
                local progress = (CurTime() % 4) / 4
                dst_progress:SetFraction(0.45 + 0.1 * progress)
            end
            return
        end

        if ext:GetData("teleport") and not ext:GetData("mat") then -- premat
            local delay = (ext:GetData("demat-fast",false) and 1.9 or 8.5)
            local time_passed = CurTime() - ext:GetData("premat_start_time")
            local progress = time_passed / delay

            dst_progress:SetFraction(0.55 + 0.15 * progress)
            return
        end
    end

    local dst_x = vgui.Create("DTextEntry",DestinationPanel)
    dst_x:SetPlaceholderText("")
    dst_x:SetPos(panel_d, dst_elem_h + 2 * panel_d)
    dst_x:SetSize(dst_elem_w,dst_elem_h)
    dst_x:SetNumeric(true)
    dst_x:SetEnabled(false)
    dst_x:SetFont(font)
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
    dst_y:SetFont(font)
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
    dst_z:SetFont(font)
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
    dst_pitch:SetFont(font)
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
    dst_yaw:SetFont(font)
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
    dst_roll:SetFont(font)
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
    dst_save:SetFont(font)

    local dst_copy = vgui.Create("DButton", DestinationPanel)
    dst_copy:SetSize(dst_elem_w,dst_elem_h)
    dst_copy:SetPos(dst_elem_w * 3 + 4 * panel_d, 2 * dst_elem_h + 3 * panel_d)
    dst_copy:SetText("Copy")  -- TODO
    dst_copy:SetFont(TARDIS:GetScreenFont(screen, "Default"))
    dst_copy.Think = function(self)
        if not IsValid(ext) then return end
        local dst = ext:GetDestAng()
        self:SetEnabled(dst ~= nil)
    end
    dst_copy:SetFont(font)

    local button=vgui.Create("DButton", DestinationPanel)
    button:SetSize(dst_elem_w,dst_elem_h)
    button:SetPos(dst_elem_w * 3 + 4 * panel_d, panel_d)
    button:SetText("Select")
    button:SetFont(font)
    button.DoClick = function()
        TARDIS:Control("destination", LocalPlayer())
        TARDIS:RemoveHUDScreen()
    end




    local InputPanel = vgui.Create( "DPanel",frame )
    InputPanel:SetPos(panel_left, 3 * d + 2 * panel_h)
    InputPanel:SetSize(panel_w, panel_h)
    InputPanel:SetBackgroundColor( bgcolor)

    local inp_elem_w = (panel_w - 5 * panel_d) / 4
    local inp_elem_h = (panel_h - 4 * panel_d) / 3

    local namebox = vgui.Create("DTextEntry3D2D", InputPanel)
    namebox.is3D2D = screen.is3D2D
    namebox:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Name"))
    namebox:SetPos(panel_d, panel_d)
    namebox:SetSize(panel_w - 3 * panel_d - inp_elem_w, inp_elem_h)
    namebox:SetFont(font)

    local x = vgui.Create("DTextEntry3D2D",InputPanel)
    x.is3D2D = screen.is3D2D
    x:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.X"))
    x:SetPos(panel_d, inp_elem_h + 2 * panel_d)
    x:SetSize(inp_elem_w,inp_elem_h)
    x:SetNumeric(true)
    x:SetFont(font)
    local y = vgui.Create("DTextEntry3D2D",InputPanel)
    y.is3D2D = screen.is3D2D
    y:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Y"))
    y:SetPos(inp_elem_w + 2 * panel_d, inp_elem_h + 2 * panel_d)
    y:SetSize(inp_elem_w,inp_elem_h)
    y:SetNumeric(true)
    y:SetFont(font)
    local z = vgui.Create("DTextEntry3D2D",InputPanel)
    z.is3D2D = screen.is3D2D
    z:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Z"))
    z:SetPos(inp_elem_w*2 + 3 * panel_d, inp_elem_h + 2 * panel_d)
    z:SetSize(inp_elem_w,inp_elem_h)
    z:SetNumeric(true)
    z:SetFont(font)

    local pitch = vgui.Create("DTextEntry3D2D",InputPanel)
    pitch:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Pitch"))
    pitch:SetPos(panel_d, 2 * inp_elem_h + 3 * panel_d)
    pitch:SetSize(inp_elem_w,inp_elem_h)
    pitch:SetNumeric(true)
    pitch:SetFont(font)
    local yaw = vgui.Create("DTextEntry3D2D",InputPanel)
    yaw:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Yaw"))
    yaw:SetPos(inp_elem_w + 2 * panel_d, 2 * inp_elem_h + 3 * panel_d)
    yaw:SetSize(inp_elem_w,inp_elem_h)
    yaw:SetNumeric(true)
    yaw:SetFont(font)
    local roll = vgui.Create("DTextEntry3D2D",InputPanel)
    roll:SetPlaceholderText(TARDIS:GetPhrase("Screens.Coordinates.Roll"))
    roll:SetPos(inp_elem_w * 2 + 3 * panel_d, 2 * inp_elem_h + 3 * panel_d)
    roll:SetSize(inp_elem_w,inp_elem_h)
    roll:SetNumeric(true)
    roll:SetFont(font)




    local input_save = vgui.Create("DButton", InputPanel)
    input_save:SetSize(inp_elem_w,inp_elem_h)
    input_save:SetPos( inp_elem_w * 3 + 4 * panel_d, panel_d )
    input_save:SetText("Save") -- TODO
    input_save:SetFont(font)

    local input_delete = vgui.Create("DButton", InputPanel)
    input_delete:SetSize(inp_elem_w,inp_elem_h)
    input_delete:SetPos(inp_elem_w * 3 + 4 * panel_d, inp_elem_h + 2 * panel_d)
    input_delete:SetText("Delete")  -- TODO
    input_delete:SetFont(font)

    local input_set = vgui.Create("DButton", InputPanel)
    input_set:SetSize(inp_elem_w,inp_elem_h)
    input_set:SetPos(inp_elem_w * 3 + 4 * panel_d, 2 * inp_elem_h + 3 * panel_d)
    input_set:SetText("Set")  -- TODO
    input_set:SetFont(font)




    local map = game.GetMap()

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

        local n_x = tonumber(x:GetText()) or 0
        local n_y = tonumber(y:GetText()) or 0
        local n_z = tonumber(z:GetText()) or 0
        local n_pitch = tonumber(pitch:GetText()) or 0
        local n_yaw = tonumber(yaw:GetText()) or 0
        local n_roll = tonumber(roll:GetText()) or 0

        if x:GetText() ~= "" and y:GetText() ~= "" and z:GetText() ~= "" then
            pos = Vector(n_x, n_y, n_z)
        end

        ang = Angle(n_pitch, n_yaw, n_roll)

        if namebox:GetText() ~= "" then
            name = namebox:GetText()
        end
        if name == "" then name = TARDIS:GetPhrase("Screens.Coordinates.Unnamed") end
        return pos,ang,name
    end

    local function cleartextinputs()
        llist:ClearSelection()
        namebox:SetText("")
        x:SetText("")
        y:SetText("")
        z:SetText("")
        pitch:SetText("")
        yaw:SetText("")
        roll:SetText("")
    end

    local function updatelist()
        local scr
        if screen.is3D2D then
            scr = llist:GetScroll()
        end
        llist:Clear()
        if TARDIS.Locations[map] ~= nil then
            for k,v in pairs(TARDIS.Locations[map]) do
                llist:AddLine(v.name)
            end
        end
        llist:AddLine(TARDIS:GetPhrase("Screens.Coordinates.RandomGround"))
        llist:AddLine(TARDIS:GetPhrase("Screens.Coordinates.Random"))
        if screen.is3D2D and scr then
            llist:SetScroll(scr)
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
    end
    function llist:OnRowSelectionRemoved(i,row)
        cleartextinputs()
    end
    llist:SetMultiSelect(false)

    function pos_copy:DoClick()
        llist:ClearSelection()
        updatetextinputs(ext:GetPos(), ext:GetAngles(), "")
    end

    function dst_copy:DoClick()
        llist:ClearSelection()
        x:SetText(dst_x:GetText())
        y:SetText(dst_y:GetText())
        z:SetText(dst_z:GetText())
        pitch:SetText(dst_pitch:GetText())
        yaw:SetText(dst_yaw:GetText())
        roll:SetText(dst_roll:GetText())
        namebox:SetText("")
    end

    function pos_save:DoClick()
        Derma_StringRequest(
            TARDIS:GetPhrase("Screens.Coordinates.NewLocation"),
            TARDIS:GetPhrase("Screens.Coordinates.NameNewLocation"),
            TARDIS:GetPhrase("Screens.Coordinates.NewLocation"),
            function(name)
                pos = ext:GetPos()
                ang = ext:GetAngles()
                if name == "" then name = TARDIS:GetPhrase("Screens.Coordinates.Unnamed") end
                TARDIS:AddLocation(pos,ang,name,map)
                updatelist()
            end
        )
    end

    function dst_save:DoClick()
        Derma_StringRequest(
            TARDIS:GetPhrase("Screens.Coordinates.NewLocation"),
            TARDIS:GetPhrase("Screens.Coordinates.NameNewLocation"),
            TARDIS:GetPhrase("Screens.Coordinates.NewLocation"),
            function(name)

                local n_x = tonumber(dst_x:GetText()) or 0
                local n_y = tonumber(dst_y:GetText()) or 0
                local n_z = tonumber(dst_z:GetText()) or 0
                local n_pitch = tonumber(dst_pitch:GetText()) or 0
                local n_yaw = tonumber(dst_yaw:GetText()) or 0
                local n_roll = tonumber(dst_roll:GetText()) or 0

                pos = Vector(n_x, n_y, n_z)
                ang = Angle(n_pitch, n_yaw, n_roll)
                if name == "" then name = TARDIS:GetPhrase("Screens.Coordinates.Unnamed") end
                TARDIS:AddLocation(pos,ang,name,map)
                updatelist()
            end
        )
    end

    function input_save:DoClick()
        local vortex = ext:GetData("vortex", false)
        local request = vortex and "Screens.Coordinates.NameNewLocationFromInputs" or "Screens.Coordinates.NameNewLocation"
        local pos, ang, name = fetchtextinputs()

        if name == "" then name = TARDIS:GetPhrase("Screens.Coordinates.Unnamed") end
        TARDIS:AddLocation(pos,ang,name,map)
        updatelist()
        cleartextinputs()
    end

    function input_save:Think()
        local empty = (namebox:GetText() == "")
        empty = empty or (x:GetText() == "")
        empty = empty or (y:GetText() == "")
        empty = empty or (z:GetText() == "")
        -- angles can just be 0 by default so we don't have to check for them

        if self:IsEnabled() == empty then
            self:SetEnabled(not empty)
        end
    end

    function input_delete:DoClick()
        local index = llist:GetSelectedLine()
        if not index then return end
        if not TARDIS.Locations[map] then return end
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

    function input_delete:Think()
        local line = llist:GetSelectedLine()
        if line ~= nil and TARDIS.Locations[map] and line <= #TARDIS.Locations[map] then
            if self:IsEnabled() then return end
            self:SetEnabled(true)
        elseif self:IsEnabled() then
            self:SetEnabled(false)
        end
    end

    function input_set:Think()
        local empty = (x:GetText() == "")
        empty = empty or (y:GetText() == "")
        empty = empty or (z:GetText() == "")
        -- angles can just be 0 by default so we don't have to check for them

        if self:IsEnabled() == empty then
            self:SetEnabled(not empty)
        end
    end

    function input_set:DoClick()
        local pos,ang = fetchtextinputs()

        ext:SendMessage("destination-demat", { pos, ang } )
        if TARDIS:GetSetting("dest-onsetdemat") then
            TARDIS:RemoveHUDScreen()
        end
        cleartextinputs()
    end

    local clr = function(self)
        llist:ClearSelection()
    end

    namebox.OnChange = clr
    x.OnChange = clr
    y.OnChange = clr
    z.OnChange = clr
    pitch.OnChange = clr
    yaw.OnChange = clr
    roll.OnChange = clr

end)