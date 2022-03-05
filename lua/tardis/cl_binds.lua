-- Binds

function TARDIS:ChangeKeyBind(id,data)
    local frame = vgui.Create("DFrame")
    frame:SetSkin("TARDIS")
    frame:SetTitle("TARDIS Interface")
    frame:SetSize(250,125)
    frame:SetDraggable(false)
    frame:SetBackgroundBlur(true)
    frame:SetDrawOnTop(true)
    frame:Center()
    frame:MakePopup()
    
    local text = vgui.Create("DLabel",frame)
    text:SetAutoStretchVertical(true)
    text:SetMultiline(true)
    text:SetWrap(true)
    text:SetText((data.section and "["..data.section.."]" or "").." "..(data.name or id)..(data.desc and ": "..data.desc or ""))
    text:SetWide(frame:GetWide()-20)
    text:SetPos(10,30)
    text:SetTextColor( color_white )
    
    local keybutton = vgui.Create("DButton", frame)
    keybutton:SetSize(frame:GetWide()*0.6-30, 40)
    keybutton:SetPos((frame:GetWide()*0.5)-(keybutton:GetWide()*0.5),frame:GetTall()-keybutton:GetTall()-10)
    keybutton.key=TARDIS:GetBindKey(id)
    keybutton.Update = function(s)
        s:SetText("Key: "..(TARDIS:GetKeyName(s.key) or "Invalid"))
    end
    keybutton.DoClick = function(s)
        s.keytrap=true
        input.StartKeyTrapping()
        s:SetText("[Press any key]")
    end
    keybutton.Think = function(s)
        if s.keytrap then
            local key=input.CheckKeyTrapping()
            if key then
                s.key=key
                s:Update()
            end
        end
    end
    keybutton:Update()

    local button = vgui.Create("DButton",frame)
    button:SetText("Save")
    button:SetSize(frame:GetWide()*0.2, 40)
    button:SetPos(10,frame:GetTall()-button:GetTall()-10)
    button.DoClick = function() TARDIS:SetKeyBind(id,keybutton.key) frame:Close() end

    local reset = vgui.Create("DButton",frame)
    reset:SetText("Reset")
    reset:SetSize(frame:GetWide()*0.2, 40)
    reset:SetPos(frame:GetWide()-reset:GetWide()-10,frame:GetTall()-reset:GetTall()-10)
    reset.DoClick = function() keybutton.key=TARDIS:GetBind(id).key keybutton:Update() end
end
