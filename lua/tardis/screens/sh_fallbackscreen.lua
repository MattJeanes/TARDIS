
TARDIS:AddControl("fastreturn",{
	func=function(self,ply)
		self:FastReturn()
	end,
	exterior=true,
	serveronly=true
})

TARDIS:AddControl("fastremat",{
	func=function(self,ply)
		self:ToggleFastRemat()
	end,
	exterior=true,
	serveronly=true
})

TARDIS:AddControl("power",{
	func=function(self,ply)
		self:TogglePower()
	end,
	interior=true,
	serveronly=true
})

if SERVER then return end

TARDIS:AddScreen("New Features Fallback", {menu=false}, function(self,ext,int,frame,screen)

    local power=vgui.Create("DButton",frame)
    power:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
    power:SetPos(frame:GetWide()*0.13 - power:GetWide()*0.5,frame:GetTall()*0.15 - power:GetTall()*0.5)
    power:SetText("Toggle Power")
    power:SetFont("TARDIS-Default")
    power.DoClick = function()
        TARDIS:Control("power")
    end

    local fastremat=vgui.Create("DButton",frame)
    fastremat:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
    fastremat:SetPos(frame:GetWide()*0.13 - fastremat:GetWide()*0.5,frame:GetTall()*0.4 - fastremat:GetTall()*0.5)
    fastremat:SetText("Toggle Fast Remat")
    fastremat:SetFont("TARDIS-Default")
    fastremat.DoClick = function()
        TARDIS:Control("fastremat")
    end
    
    local fastrematlbl = vgui.Create("DLabel",frame)
    fastrematlbl:SetTextColor(Color(0,0,0))
    fastrematlbl:SetFont("TARDIS-Med")
    fastrematlbl.DoLayout = function(self)
        fastrematlbl:SizeToContents()
        fastrematlbl:SetPos((frame:GetWide()*0.55)-(fastrematlbl:GetWide()*0.5),(frame:GetTall()*0.4)-(fastrematlbl:GetTall()*0.5))
    end
    fastrematlbl:SetText("Fast Remat is PLACEHOLDER")
    fastrematlbl:DoLayout()
    function fastrematlbl:Think()
        local on = ext:GetData("demat-fast")
        if on then
            self:SetText("Fast Remat is on")
        else
            self:SetText("Fast Remat is off")
        end
    end

    local fastreturn=vgui.Create("DButton",frame)
    fastreturn:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
    fastreturn:SetPos(frame:GetWide()*0.13 - fastreturn:GetWide()*0.5,frame:GetTall()*0.65 - fastreturn:GetTall()*0.5)
    fastreturn:SetText("Fast Return")
    fastreturn:SetFont("TARDIS-Default")
    fastreturn.DoClick = function()
        TARDIS:Control("fastreturn")
    end
    
end)