HexagonalLayout = {}

local v3 = math.sqrt(3) -- sqrt(3)

function HexagonalLayout:new(screen, n_rows, gap_scale)
	local layout = {}

	-- From calculations:
	-- n = n_rows, m = n_cols
	-- k = gap_scale, x = button_side_length, w = screen_width, h = screen_height

	layout.screen = screen
	layout.screen_width = screen:GetWide()
	layout.screen_height = screen:GetTall()
	layout.n_rows = math.floor(n_rows)
	layout.gap_scale = gap_scale

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
	local py = self.gap_scale * self.button_side_length + (i - 1) * self.dh
	return px,py
end

function HexagonalLayout:GetButtonSize(x)
	if x then return self.button_size[x] end
	return self.button_size[1], self.button_size[2]
end

function HexagonalLayout:GetRows()
	return self.n_rows
end
function HexagonalLayout:GetCols()
	return self.n_cols
end


function HexagonalLayout:AddNewButton(screen_button)
	screen_button:SetVisible(false)
	table.insert(self.buttons, screen_button)
end

function HexagonalLayout:DrawButtons(x)
	local m = self.n_cols
	local n = self.n_rows
	local offsetX = x or 0
	local i = -1
	local j = 1
	for k,button in ipairs(self.buttons) do
		i = i + 2
		if i > n
		then
			if (i % 2) == 0
			then
				j = j + 1
				i = 1
			else
				i = 2
			end
		end

		button:SetSize(self:GetButtonSize())
		button:SetPos(self:GetButtonPos(i, j))
		button:SetVisible(true)
		button:Think()
		button:SlowMove(offsetX, 0, true, 100)
	end
end

function HexagonalLayout:ScrollButtons(x)
	for k,button in ipairs(self.buttons) do
		button:SlowMove(x * self.dw, 0, true, 25)
	end
end

