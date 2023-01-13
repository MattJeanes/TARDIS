
if SERVER then
    util.AddNetworkString("TARDIS-Debug-Portals")
    util.AddNetworkString("TARDIS-Debug-Portals-Update")

    net.Receive("TARDIS-Debug-Portals-Update",function(len,ply)
        if not ply:IsAdmin() then return end

        local portal = net.ReadEntity()
        local update_type = net.ReadString()

        if update_type == "pos" then
            portal:SetPos(net.ReadVector())
        elseif update_type == "ang" then
            portal:SetAngles(net.ReadAngle())
        elseif update_type == "size" then
            portal:SetWidth(net.ReadFloat())
            portal:SetHeight(net.ReadFloat())
		elseif update_type == "exit_offset" then
            portal:SetExitPosOffset(net.ReadVector())
            portal:SetExitAngOffset(net.ReadAngle())
        elseif update_type == "3d" then
            portal:SetThickness(net.ReadFloat())
            portal:SetInverted(net.ReadBool())
        end
    end)
else
    local function ShowPortalDebugMenu(p)
        if IsValid(p.debug_window) then
            if not g_ContextMenu:IsVisible() then
                g_ContextMenu:Open()
            end
            --p.debug_window:Center()
            local w = p.debug_window
            w:SetPos(ScrW() * 0.25 - w:GetWide() * 0.5, ScrH() * 0.5 - w:GetTall() * 0.5)
            return
        end

        local x = ScrW() * 0.2;
        local y = ScrH() * 0.8;

        g_ContextMenu:Open()
        local frame=g_ContextMenu:Add( "DFrame" )
        frame:SetTitle("Portals Debug")
        frame:SetSizable(true)
        frame:SetSize(x + 50, y + 50)
        frame:SetPos(ScrW() * 0.25 - frame:GetWide() * 0.5, ScrH() * 0.5 - frame:GetTall() * 0.5)
        frame:ShowCloseButton(true)
        frame:RequestFocus()

        p.debug_window = frame

        local pr = vgui.Create( "DProperties", frame )
        pr:SetSize(x, y)
        pr:Center()

        function pr:Think()
            if not IsValid(p) then
                frame:Close()
            end
        end

        local ent = p:GetParent()
        local px, py, pz = ent:WorldToLocal(p:GetPos()):Unpack()
        local ang_p, ang_y, ang_r = ent:WorldToLocalAngles(p:GetAngles()):Unpack()
        local thickness = p:GetThickness()
        local inverted = p:GetInverted()
        local width = p:GetWidth()
        local height = p:GetHeight()

        -- exit pos offset, exit ang offset
        local epo_x, epo_y, epo_z = p:GetExitPosOffset():Unpack()
        local eao_p, eao_y, eao_r = p:GetExitAngOffset():Unpack()

        local orig_px, orig_py, orig_pz = px, py, pz
        local orig_ang_p, orig_ang_y, orig_ang_r = ang_p, ang_y, ang_r
        local orig_thickness = thickness
        local orig_inverted = inverted
        local orig_width = width
        local orig_height = height
        local orig_epo_x, orig_epo_y, orig_epo_z = epo_x, epo_y, epo_z
        local orig_eao_p, orig_eao_y, orig_eao_r = eao_p, eao_y, eao_r

        local function UpdatePortalPos()
            net.Start("TARDIS-Debug-Portals-Update")
                net.WriteEntity(p)
                net.WriteString("pos")
                net.WriteVector(ent:LocalToWorld(Vector(px, py, pz)))
            net.SendToServer()
        end

        local function UpdatePortalAng()
            net.Start("TARDIS-Debug-Portals-Update")
                net.WriteEntity(p)
                net.WriteString("ang")
                net.WriteAngle(ent:LocalToWorldAngles(Angle(ang_p, ang_y, ang_r)))
            net.SendToServer()
        end

        local function UpdatePortalSize()
            net.Start("TARDIS-Debug-Portals-Update")
                net.WriteEntity(p)
                net.WriteString("size")
                net.WriteFloat(width)
                net.WriteFloat(height)
            net.SendToServer()
        end

        local function UpdatePortal3D()
            net.Start("TARDIS-Debug-Portals-Update")
                net.WriteEntity(p)
                net.WriteString("3d")
                net.WriteFloat(thickness)
                net.WriteBool(inverted)
            net.SendToServer()
        end

		local function UpdatePortalExitOffset()
            net.Start("TARDIS-Debug-Portals-Update")
                net.WriteEntity(p)
                net.WriteString("exit_offset")
                net.WriteVector(Vector(epo_x, epo_y, epo_z))
                net.WriteAngle(Angle(eao_p, eao_y, eao_r))
            net.SendToServer()
        end

        local function SetupProperty(category, name, value, a, b, c, d)
            local vmin, vmax, update_func
            local vtype = "Float"
            if isnumber(b) then
                vmin = a
                vmax = b
                update_func = c
            else
                vmin = value - a
                vmax = value + a
                update_func = b
            end

            if d then
                vtype = d
            end

            local row1 = pr:CreateRow( category, name )
            local row2 = pr:CreateRow( category, name .. " (precise)" )

            row1:Setup( vtype, { min = vmin, max = vmax } )
            row1:SetValue(value)
            row1.DataChanged = function( _, val )
                row2:SetValue(val)
                update_func(val)
            end

            row2:Setup( "Generic" )
            row2:SetValue(value)
            row2.DataChanged = function( _, val )
                if tonumber(val) == nil then return end
                row1:SetValue(val)
                update_func(val)
            end

            return row1, row2
        end


        local x, x2 = SetupProperty("Position", "X", px, 100, function(val)
            px = val
            UpdatePortalPos()
        end)
        local y, y2 = SetupProperty("Position", "Y", py, 100, function(val)
            py = val
            UpdatePortalPos()
        end)
        local z, z2 = SetupProperty("Position", "Z", pz, 100, function(val)
            pz = val
            UpdatePortalPos()
        end)

        local ap, ap2 = SetupProperty( "Angle", "Pitch", ang_p, 360, function(val)
            ang_p = val
            UpdatePortalAng()
        end)
        local ay, ay2 = SetupProperty( "Angle", "Yaw", ang_y, 360, function(val)
            ang_y = val
            UpdatePortalAng()
        end)
        local ar, ar2 = SetupProperty( "Angle", "Roll", ang_r, 360, function(val)
            ang_r = val
            UpdatePortalAng()
        end)

        local w, w2 = SetupProperty("Size", "Width", width, 0, 300, function(val)
            width = val
            UpdatePortalSize()
        end)
        local h, h2 = SetupProperty("Size", "Height", height, 0, 300, function(val)
            height = val
            UpdatePortalSize()
        end)

        local thick, thick2 = SetupProperty( "3D", "Thickness", thickness, 150, function(val)
            thickness = val
            UpdatePortal3D()
        end)

        local inv = pr:CreateRow( "3D", "Inverted" )
        inv:Setup( "Bool" )
        inv:SetValue(inverted)
        inv.DataChanged = function( _, val )
            inverted = val
            UpdatePortal3D()
        end


        local epox, epox2 = SetupProperty("Exit Point", "X", epo_x, 300, function(val)
            epo_x = val
            UpdatePortalExitOffset()
        end)
        local epoy, epoy2 = SetupProperty("Exit Point", "Y", epo_y, 300, function(val)
            epo_y = val
            UpdatePortalExitOffset()
        end)
        local epoz, epoz2 = SetupProperty("Exit Point", "Z", epo_z, 300, function(val)
            epo_z = val
            UpdatePortalExitOffset()
        end)

        local eaop, eaop2 = SetupProperty( "Exit Point", "Pitch", eao_p, 360, function(val)
            eao_p = val
            UpdatePortalExitOffset()
        end)
        local eaoy, eaoy2 = SetupProperty( "Exit Point", "Yaw", eao_y, 360, function(val)
            eao_y = val
            UpdatePortalExitOffset()
        end)
        local eaor, eaor2 = SetupProperty( "Exit Point", "Roll", eao_r, 360, function(val)
            eao_r = val
            UpdatePortalExitOffset()
        end)


        local ep_category = pr:GetCategory("Exit Point")

        ep_category.Container:SetVisible(false)
        ep_category.Expand:SetExpanded(false)
        ep_category:InvalidateLayout()

        local reset = pr:CreateRow( "Actions", "Reset" )
        reset:Setup( "Bool" )
        reset:SetValue(false)
        reset.DataChanged = function( _, val )
            reset:SetValue(false)

            px, py, pz = orig_px, orig_py, orig_pz
            ang_p, ang_y, ang_r = orig_ang_p, orig_ang_y, orig_ang_r
            thickness = orig_thickness
            inverted = orig_inverted
            width = orig_width
            height = orig_height

            epo_x, epo_y, epo_z = orig_epo_x, orig_epo_y, orig_epo_z
            eao_p, eao_y, eao_r = orig_eao_p, orig_eao_y, orig_eao_r

            UpdatePortalPos()
            UpdatePortalAng()
            UpdatePortalSize()
            UpdatePortal3D()
            UpdatePortalExitOffset()

            frame:SetDeleteOnClose(true)
            frame:Close()
            frame:Remove()
            ShowPortalDebugMenu(p)
        end

        local inv = pr:CreateRow( "Actions", "Print to console" )
        inv:Setup( "Bool" )
        inv:SetValue(false)
        inv.DataChanged = function( _, val )
            inv:SetValue(false)

            print("Portal = {")
            print("\t-- Generated by portals debug tool")
            print("\tpos = Vector(" .. px .. ", " .. py .. ", " .. pz .. "),")
            print("\tang = Angle(" .. ang_p .. ", " .. ang_y .. ", " .. ang_r .. "),")
            print("\twidth = " .. width .. ",")
            print("\theight = " .. height .. ",")

            if thickness and thickness ~= 0 then
                print("\tthickness = " .. thickness .. ",")
            end
            if inverted then
                print("\tinverted = " .. tostring(inverted) .. ",")
            end

            print("),")
        end
    end

    net.Receive("TARDIS-Debug-Portals", function()
        local p = net.ReadEntity()
        ShowPortalDebugMenu(p)
    end)
end

concommand.Add("tardis2_debug_portals", function(ply,cmd,args)
    if not ply:IsAdmin() then return end

    local portal = wp.GetFirstPortalHit(ply:EyePos(), ply:EyeAngles():Forward())

    if IsValid(portal.Entity) then
        net.Start("TARDIS-Debug-Portals")
            net.WriteEntity(portal.Entity)
        net.Send(ply)
    end
end)