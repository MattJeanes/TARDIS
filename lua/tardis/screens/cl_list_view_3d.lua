ListView3D = {}

function ListView3D:new(parent,screen,elem_height,col)
    local l = {
        parent = parent,
        screen = screen,
        font = TARDIS:GetScreenFont(screen, "Default"),
        pos = {0, 0},
        size = {100, 100},
        elem_h = elem_height or 17,
        lines = {},
        elements = {},
        line_elements = {},
        selected_line = nil,
        bgcolor = col or Color(255,255,255),
        scroll = 0,
    }

    l.panel = vgui.Create("DPanel", parent)
    l.panel:SetBackgroundColor(l.bgcolor)
    l.panel.Think = function()
        l:Think()
    end

    l.OnRowSelected = function(i,row) end
    l.DoDoubleClick = function(rowIndex, row) end
    l.Think = function() end

    setmetatable(l,self)
    self.__index = self

    l:UpdateLayout()

    return l
end

function ListView3D:CleanLayout()
    for k,v in ipairs(self.elements) do
        if IsValid(v) then
            v:Remove()
        end
    end
    self.elements = {}
    self.line_elements = {}
end
function ListView3D:UpdateLayout()
    self:CleanLayout()

    self.panel:SetSize(self.size[1], self.size[2])
    self.panel:SetBackgroundColor(self.bgcolor)

    local d = self.size[2] * 0.01
    local w = self.size[1] - 2 * d

    self.list_panel = vgui.Create("DPanel", self.panel)
    self.list_panel:SetPaintBackground(false)
    --self.list_panel:SetBackgroundColor(Color(255,0,0))
    self.list_panel:SetSize(w, self.size[2] - 2 * self.elem_h - 3 * d)
    self.list_panel:SetPos(d, 2 * d + self.elem_h)

    self.scroll_panel = vgui.Create("DPanel", self.list_panel)
    self.scroll_panel:SetPaintBackground(false)
    self.scroll_panel:SetPos(0,0)
    self.scroll_panel:SetSize(w, #self.lines * (self.elem_h + d))
    self.scroll = 0

    for i,v in ipairs(self.lines) do
        local b = vgui.Create("DButton", self.scroll_panel)
        b:SetPos(0, (i - 1) * (d + self.elem_h))
        b:SetSize(w, self.elem_h)
        b:SetText(v)
        b:SetTextColor(Color(0,0,0))
        b:SetBGColor(Color(255,255,255))
        b:SetFont(self.font)
        b:SetIsToggle(true)
        b.index = i

        b.OnToggled = function(this, state)
            if state then
                for k,another_line in pairs(self.line_elements) do
                    if another_line ~= this then
                        another_line:SetToggle(false)
                    end
                end
                self:OnRowSelected(this.index, this)
                self.selected_line = this.index
            else
                self.selected_line = nil
            end
        end

        b.DoDoubleClick = function(this)
            self:DoDoubleClick(this.index, this)
        end

        table.insert(self.elements, b)
        table.insert(self.line_elements, b)
    end

    local div_color = self.bgcolor
    div_color.a = 255

    local ubd = vgui.Create("DPanel", self.panel)
    ubd:SetBackgroundColor(div_color)
    ubd:SetSize(self.size[1], 2 * d)
    ubd:SetPos(0, self.elem_h - 0.5 * d)

    local dbd = vgui.Create("DPanel", self.panel)
    dbd:SetBackgroundColor(div_color)
    dbd:SetSize(self.size[1], 2 * d)
    dbd:SetPos(0, self.size[2] - self.elem_h - 0.5 * d)

    local ub = vgui.Create("DButton", self.panel)
    ub:SetPos(0,0)
    ub:SetSize(self.size[1], self.elem_h)
    ub:SetFont(self.font)
    ub:SetEnabled(false)
    ub:SetText("ʌ")

    local db = vgui.Create("DButton", self.panel)
    db:SetPos(0,self.size[2] - self.elem_h)
    db:SetSize(self.size[1], self.elem_h)
    db:SetFont(self.font)
    db:SetEnabled(true)
    db:SetText("V")

    table.insert(self.elements, db)
    table.insert(self.elements, ub)
    table.insert(self.elements, ubd)
    table.insert(self.elements, ubd)

    local max_scroll = self.elem_h * (#self.lines + 1) - self.size[2]
    local single_scroll = 0.5 * self.size[2]

    ub.DoClick = function()
        self.scroll = math.Clamp(self.scroll - single_scroll, 0, max_scroll)
        self.scroll_panel:SetPos(0, -self.scroll)
        ub:SetEnabled(self.scroll ~= 0)
        db:SetEnabled(self.scroll ~= max_scroll)
    end

    db.DoClick = function()
        self.scroll = math.Clamp(self.scroll + single_scroll, 0, max_scroll)
        self.scroll_panel:SetPos(0, -self.scroll)
        ub:SetEnabled(self.scroll ~= 0)
        db:SetEnabled(self.scroll ~= max_scroll)
    end

end

function ListView3D:SetSize(sizeX, sizeY)
    self.size = {sizeX, sizeY}
    self:UpdateLayout()
end
function ListView3D:SetTall(sizeY)
    self:SetSize(self.size[1], sizeY)
end
function ListView3D:SetWide(sizeX)
    self:SetSize(sizeX, self.size[2])
end

function ListView3D:SetPos(posX, posY)
    self.pos = {posX, posY}
    self.panel:SetPos(self.pos[1], self.pos[2])
end

function ListView3D:SetFont(font)
    self.font = font
end

function ListView3D:GetPos()
    return self.pos
end
function ListView3D:GetPosX()
    return self.pos[1]
end
function ListView3D:GetPosY()
    return self.pos[2]
end
function ListView3D:GetWide()
    return self.size[1]
end
function ListView3D:GetTall()
    return self.size[2]
end
function ListView3D:GetSize()
    return self.size[1], self.size[2]
end

function ListView3D:SetElementHeight(h)
    self.elem_h = h
    self:UpdateLayout()
end


function ListView3D:Clear()
    self.lines = {}
end
function ListView3D:AddLine(text)
    table.insert(self.lines, text)
    self:UpdateLayout()
end
function ListView3D:GetSelectedLine()
    return self.selected_line
end
function ListView3D:ClearSelection()
    for k,v in pairs(self.line_elements) do
        v:SetToggle(false)
    end
    self.selected_line = nil
end


-- interface / placeholder / compatibility functions

function ListView3D:AddColumn(name)

end
function ListView3D:SetMultiSelect(b)
    -- multiselect is neither required nor implemented
end


