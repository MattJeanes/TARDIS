if SERVER then
	ENT:AddHook("PostInitialize", "redecorate_child", function(self)
		local int_saved_data = self.exterior:GetData("redecorate_parent_int_data")
		if not int_saved_data then return end

		TARDIS:apply_redecoration_data(self, int_saved_data)
		self.exterior:SetData("redecorate_parent_int_data", nil, true)

	end)
end