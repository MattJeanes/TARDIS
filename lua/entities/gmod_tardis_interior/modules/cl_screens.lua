-- Adds screens
	
ENT:AddHook("Draw", "screens", function(self)
	local text="TARDIS Rewrite\nWork in Progress"
	local col=HSVToColor(180+math.sin(CurTime()*0.1)*180,0.5,1)
	cam.Start3D2D(self:LocalToWorld(Vector(31.7,-30,162.6)),self:LocalToWorldAngles(Angle(0,58.8,90)),0.1)
		draw.RoundedBox(0,0,0,291,150,col)
		draw.DrawText(text,"DermaLarge",145,45,Color(0,0,0,255),TEXT_ALIGN_CENTER)
	cam.End3D2D()
	
	cam.Start3D2D(self:LocalToWorld(Vector(-32.6,37.4,163.55)),self:LocalToWorldAngles(Angle(0,-120,90)),0.1)
		draw.RoundedBox(0,0,0,291,150,col)
		draw.DrawText(text,"DermaLarge",145,45,Color(0,0,0,255),TEXT_ALIGN_CENTER)
	cam.End3D2D()
end)