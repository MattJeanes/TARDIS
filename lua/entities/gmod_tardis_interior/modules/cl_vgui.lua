-- VGUI overrides

local textpnl
local function RequestInput( pnl )
    if not textpnl then
        textpnl=pnl
        Derma_StringRequest("TARDIS Interface",pnl.sub3D2D or pnl.strTooltipText or "Enter text input",pnl:GetText(),function(text)
            pnl:SetText( text )
            pnl:SetCaretPos( text:len() )
            pnl:OnTextChanged()
            pnl:OnEnter()
            textpnl=nil
        end,function() textpnl=nil end)
    end
end

local old=vgui.GetControlTable("DTextEntry")
local tbl={}
tbl.Init = function(self,...)
    old.Init(self,...)
    self.OldOnMousePressed = self.OnMousePressed
    self.OnMousePressed = function(self,key)
        if self.is3D2D then
            RequestInput(self)
        end
        self:OldOnMousePressed(key)
    end
end
vgui.Register( "DTextEntry3D2D", tbl, "DTextEntry" )
