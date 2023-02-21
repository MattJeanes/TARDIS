ListView3D = {}


function ListView3D:new(parent,screen)
    local l = {
        visible = true,
        parent = parent,
        header_text = "List",
        font = TARDIS:GetScreenFont(screen, "Default"),
        pos = {0, 0},
        size = {100, 100},
        elem_h = 17,
        lines = {},
        selected_line = nil,
    }

    l.frame = vgui.Create("DFrame", parent)
    l.frame.Think = function()
        l:Think()
    end

    l.OnRowSelected = function(i,row) end
    l.DoDoubleClick = function(i,row) end

    setmetatable(l,self)
    self.__index = self
    return l
end

function ListView3D:UpdatePosition()
    self.frame:SetPos(l.pos[1], l.pos[2])
    self.frame:SetSize(l.size[1], l.size[2])
end

function ListView3D:SetSize(sizeX, sizeY)
    self.size = {sizeX, sizeY}
    self:UpdatePosition()
end
function ListView3D:SetTall(sizeY)
    self.size[2] = sizeY
    self:UpdatePosition()
end
function ListView3D:SetWide(sizeX)
    self.size[1] = sizeX
    self:UpdatePosition()
end

function ListView3D:SetPos(posX, posY)
    self.pos = {posX, posY}
    self:UpdatePosition()
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

function ListView3D:SetVisible(visible)
    self.visible = visible
end
function ListView3D:IsVisible()
    return self.visible
end

function ListView3D:SetHeaderText(txt)
    self.header_text = txt
end

function ListView3D:Clear()
    self.lines = {}
end
function ListView3D:AddLine(text)
    table.insert(self.lines, text)
end
function ListView3D:GetSelectedLine()
    return self.selected_line
end
function ListView3D:ClearSelection()
    self.selected_line = nil
end


-- interface / placeholder / compatibility functions

function ListView3D:AddColumn(name)
    self:SetHeaderText(name)
end
function ListView3D:SetMultiSelect(b)
    -- multiselect is neither required nor implemented
end


