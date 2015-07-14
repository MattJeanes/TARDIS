-- Legacy

local INT={}
INT.Name="Legacy"
INT.ID="legacy"
INT.Model="models/drmatt/tardis/interior.mdl"
INT.Light={
	color=Color(255,50,0),
	pos=Vector(0,0,120),
	brightness=5
}
INT.ScreenX=443
INT.ScreenY=335
INT.Portal={
	pos=Vector(316.7,334.9,-36.5),
	ang=Angle(0,230,0),
	width=45,
	height=91
}
INT.Fallback={
	pos=Vector(291,305,-75),
	ang=Angle(0,50,0)
}
INT.Screens={
	{
		pos=Vector(41.1,-13,47),
		ang=Angle(0,84.5,90)
	}
}
INT.Parts={
	door={
		pos=Vector(300,315,-88.1),
		ang=Angle(0,50,0)
	},
}

ENT:AddInterior(INT)