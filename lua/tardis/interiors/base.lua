-- Base

local T={}
T.Base=true
T.Name="Base"
T.ID="base"
T.Interior={
	Model="models/drmatt/tardis/2012interior/interior.mdl",
	Portal={
		pos=Vector(-1,-353.5,136),
		ang=Angle(0,90,0),
		width=60,
		height=91
	},
	Fallback={
		pos=Vector(0,-330,95),
		ang=Angle(0,90,0)
	},
	ExitDistance=600
}
T.Exterior={
	Model="models/drmatt/tardis/exterior/exterior.mdl",
	Mass=5000,
	Portal={
		pos=Vector(26,0,51.65),
		ang=Angle(0,0,0),
		width=44,
		height=91
	},
	Fallback={
		pos=Vector(60,0,5),
		ang=Angle(0,0,0)
	}
}

TARDIS:AddInterior(T)