if SERVER then
	ENT:AddHook("PostInitialize", "redecorate_child", function(self)
		local int_saved_data = self.exterior:GetData("redecorate_parent_int_data")
		if not int_saved_data then return end

		for name,value in pairs(int_saved_data) do
			self:SetData(name, value, true)
		end

		self.exterior:SetData("redecorate_parent_int_data", nil, true)

	end)
end