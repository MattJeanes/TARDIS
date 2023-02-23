-- VGUI overrides

local function number_ok(pnl, text)
    return (not pnl:GetNumeric()) or (text == "") or (tonumber(text) ~= nil)
end

local textpnl
local function RequestInput( pnl )
    if not textpnl then
        textpnl=pnl
        local old_text = pnl:GetText()
        Derma_StringRequest(TARDIS:GetPhrase("Common.Interface"),
            pnl.sub3D2D or pnl.strTooltipText or TARDIS:GetPhrase("Common.EnterTextInput"),
            pnl:GetText(),
            function(text)
                if text ~= old_text and number_ok(pnl, text) then
                    pnl:SetText(text)
                    pnl:OnTextChanged()
                    pnl:OnChange()
                end
                pnl:SetCaretPos(0)
                pnl:OnEnter()
                textpnl=nil
            end,
            function()
                textpnl=nil
            end
        )
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
