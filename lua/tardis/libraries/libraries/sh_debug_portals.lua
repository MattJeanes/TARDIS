
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
        elseif update_type == "3d" then
            portal:SetThickness(net.ReadFloat())
            portal:SetInverted(net.ReadBool())
        end
    end)
else
    net.Receive("TARDIS-Debug-Portals", function()
        local p = net.ReadEntity()

        if IsValid(p.debug_window) then
            p.debug_window:Center()
            return
        end

        local x = 300
        local y = 600

        g_ContextMenu:Open()
        local frame=g_ContextMenu:Add( "DFrame" )
        frame:SetTitle("Portals Debug")
        frame:SetSize( x + 50, y + 50 )
        frame:SetSizable(true)
        frame:Center()
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
        local ang_p, ang_y, ang_r = ent:GetAngles():Unpack()
        local thickness = p:GetThickness()
        local inverted = p:GetInverted()
        local width = p:GetWidth()
        local height = p:GetHeight()

        local orig_px, orig_py, orig_pz = px, py, pz
        local orig_ang_p, orig_ang_y, orig_ang_r = ang_p, ang_y, ang_r
        local orig_thickness = thickness
        local orig_inverted = inverted
        local orig_width = width
        local orig_height = height

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
                net.WriteAngle(Angle(ang_p, ang_y, ang_r))
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

            local c = pr:CreateRow( category, name )
            local cpr = pr:CreateRow( category, name .. " (precise)" )

            c:Setup( vtype, { min = vmin, max = vmax } )
            c:SetValue(value)
            c.DataChanged = function( _, val )
                cpr:SetValue(val)
                update_func(val)
            end

            cpr:Setup( "Generic" )
            cpr:SetValue(value)
            cpr.DataChanged = function( _, val )
                if tonumber(val) == nil then return end
                c:SetValue(val)
                update_func(val)
            end

            return c, cpr
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

        local thick = SetupProperty( "3D", "Thickness", thickness, 150, function(val)
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

        local inv = pr:CreateRow( "Actions", "Reset" )
        inv:Setup( "Bool" )
        inv:SetValue(false)
        inv.DataChanged = function( _, val )
            inv:SetValue(false)

            px, py, pz = orig_px, orig_py, orig_pz
            ang_p, ang_y, ang_r = orig_ang_p, orig_ang_y, orig_ang_r
            thickness = orig_thickness
            inverted = orig_inverted
            width = orig_width
            height = orig_height

            UpdatePortalPos()
            UpdatePortalAng()
            UpdatePortalSize()
            UpdatePortal3D()
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