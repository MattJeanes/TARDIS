-- Adds screens
	
ENT:AddHook("Draw", "screens", function(self)
	local text="TARDIS Rewrite\nWork in Progress"
	cam.Start3D2D(self:LocalToWorld(Vector(35,-41,164.5)),self:LocalToWorldAngles(Angle(0,60,90)),0.1)
		draw.RoundedBox(0,0,0,325,170,Color(255,255,255,255))
		draw.DrawText(text,"DermaLarge",162.5,55,Color(0,0,0,255),TEXT_ALIGN_CENTER)
	cam.End3D2D()
	
	cam.Start3D2D(self:LocalToWorld(Vector(-35.2,40.2,164.5)),self:LocalToWorldAngles(Angle(0,-120,90)),0.1)
		draw.RoundedBox(0,0,0,325,170,Color(255,255,255,255))
		draw.DrawText(text,"DermaLarge",162.5,55,Color(0,0,0,255),TEXT_ALIGN_CENTER)
	cam.End3D2D()
end)