HexagonalLayout = {}

local v3 = math.sqrt(3) -- sqrt(3)

function HexagonalLayout:new(screen, n_rows, gap_scale)
	local layout = {}

	-- n = n_rows, m = n_cols
	-- k = gap_scale, x = button_side_length, w = screen_width, h = screen_height
	layout.screen = screen
	layout.screen_width = screen:GetWide()
	layout.screen_height = screen:GetTall()
	layout.n_rows = math.floor(n_rows)
	layout.gap_scale = gap_scale
	layout.x_offset = 0

	layout.button_side_length = 2 * layout.screen_height / (2 * gap_scale + (1 + n_rows) * (v3 + gap_scale))
	layout.n_cols = 2 * (layout.screen_width + layout.button_side_length) / (layout.button_side_length * (3 + v3 * gap_scale)) - 2
	layout.n_cols = math.floor(layout.n_cols)

	layout.dh = (v3 + gap_scale) * layout.button_side_length / 2
	layout.dw = (3 + v3 * gap_scale) * layout.button_side_length / 2

	layout.button_size = {2 * layout.button_side_length, v3 * layout.button_side_length}

	layout.buttons = {}

	setmetatable(layout,self)
	self.__index = self
	return layout
end

function HexagonalLayout:GetButtonPos(i, j)
	local px = v3 * self.gap_scale * self.button_side_length / 2
	px = px + self.dw * ((i + 1) % 2 + 2 * (j - 1))
	px = px + self.x_offset
	local py = self.gap_scale * self.button_side_length + (i - 1) * self.dh
	return px,py
end

function HexagonalLayout:GetButtonSize()
	return self.button_size[1], self.button_size[2]
end

function HexagonalLayout:SetOffsetX(x)
	self.x_offset = x
end
function HexagonalLayout:GetOffsetX()
	return self.x_offset
end

function HexagonalLayout:ScrollButtons(x)
	self.x_offset = self.x_offset + x * self.button_size[1]
end

function HexagonalLayout:AddNewButton(screen_button)
	screen_button:SetVisible(false)
	table.insert(self.buttons, screen_button)
end

function HexagonalLayout:DrawButtons()
	local m = self.n_cols
	local n = self.n_rows
	local i = 0
	local j = 1
	for k,button in ipairs(self.buttons) do
		i = i + 1
		if i > n then i = 1; j = j + 1; end
		button:SetVisible(not (j > m))
		button:SetSize(self:GetButtonSize())
		button:SetPos(self:GetButtonPos(i, j))
	end
end
