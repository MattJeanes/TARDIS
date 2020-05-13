
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

TARDIS:AddControl("hads",{
    func=function(self,ply)
        self:ToggleHADS()
	end,
	exterior=true,
	serveronly=true,
})
TARDIS:AddControl("repair",{
	func=function(self,ply)
        self:ToggleRepair()
	end,
	exterior=true,
	serveronly=true
})
TARDIS:AddControl("physbrake",{
	func=function(self,ply)
        self:TogglePhyslock()
	end,
	exterior=true,
	serveronly=true
})

if SERVER then return end

TARDIS:AddScreen("Virtual Console", {menu=false}, function(self,ext,int,frame,screen)

    local power=vgui.Create("DButton",frame)
    power:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
    power:SetPos(frame:GetWide()*0.13 - power:GetWide()*0.5,frame:GetTall()*0.15 - power:GetTall()*0.5)
    power:SetText("Toggle Power")
    power:SetFont("TARDIS-Default")
    power.DoClick = function()
        TARDIS:Control("power")
    end    
    
    local repair=vgui.Create("DButton",frame)
    repair:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
    repair:SetPos(frame:GetWide()*0.35 - repair:GetWide()*0.5,frame:GetTall()*0.15 - repair:GetTall()*0.5)
    repair:SetText("Repair TARDIS")
    repair:SetFont("TARDIS-Default")
    repair.DoClick = function()
        TARDIS:Control("repair")
    end

    local fastremat=vgui.Create("DButton",frame)
    fastremat:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
    fastremat:SetPos(frame:GetWide()*0.13 - fastremat:GetWide()*0.5,frame:GetTall()*0.4 - fastremat:GetTall()*0.5)
    fastremat:SetText("Fast Remat "..(ext:GetData("demat-fast") and "on" or "off"))
    fastremat:SetFont("TARDIS-Default")
    fastremat.DoClick = function(self)
        TARDIS:Control("fastremat")
    end
    fastremat.oldon = ext:GetData("demat-fast")
    function fastremat:Think()
        local on = ext:GetData("demat-fast")
        if self.oldon == on then return end
        if on then
            self:SetText("Fast Remat on")
        else
            self:SetText("Fast Remat off")
        end
        self.oldon = on
    end
    
    local physbrake = vgui.Create("DButton",frame)
    physbrake:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2)
    physbrake:SetFont("TARDIS-Default")
    physbrake:SetPos((frame:GetWide()*0.35)-(physbrake:GetWide()*0.5),(frame:GetTall()*0.4)-(physbrake:GetTall()*0.5))
    physbrake:SetText("Physlock "..(ext:GetData("physlock") and "on" or "off"))
    physbrake.DoClick = function()
        TARDIS:Control("physbrake")
    end
    physbrake.oldon = ext:GetData("physlock")
    function physbrake:Think()
        local on = ext:GetData("physlock", false)
        if self.oldon == on then return end
        if on then
            self:SetText("Physlock on")
        else
            self:SetText("Physlock off")
        end
        self.oldon = on
    end

    local fastreturn=vgui.Create("DButton",frame)
    fastreturn:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
    fastreturn:SetPos(frame:GetWide()*0.13 - fastreturn:GetWide()*0.5,frame:GetTall()*0.65 - fastreturn:GetTall()*0.5)
    fastreturn:SetText("Fast Return")
    fastreturn:SetFont("TARDIS-Default")
    fastreturn.DoClick = function()
        TARDIS:Control("fastreturn")
    end

	local hads=vgui.Create("DButton",frame)
	hads:SetSize( frame:GetWide()*0.2, frame:GetTall()*0.2 )
	hads:SetPos(frame:GetWide()*0.35 - power:GetWide()*0.5,frame:GetTall()*0.65 - power:GetTall()*0.5)
	hads:SetText("HADS "..(ext:GetData("hads") and "on" or "off"))
	hads:SetFont("TARDIS-Default")
	hads.DoClick = function()
		TARDIS:Control("hads")
    end
    hads.oldon = ext:GetData("hads")
    function hads:Think()
        local on = ext:GetData("hads", false)
        if self.oldon == on then return end
        if on then
            self:SetText("HADS on")
        else
            self:SetText("HADS off")
        end
        self.oldon = on
    end
    
end)
