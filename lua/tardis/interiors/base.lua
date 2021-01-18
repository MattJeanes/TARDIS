-- Base

local T={}
T.Base=true
T.Name="Base"
T.ID="base"
T.Interior={
	Model="models/drmatt/tardis/2012interior/interior.mdl",
	ExitDistance=600,
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
	Sounds={
		Teleport={
		}, -- uses exterior sounds if not specified
		Power={
			On="drmatt/tardis/power_on.wav",
			Off="drmatt/tardis/power_off.wav"
		},
		SequenceOK = "drmatt/tardis/seq_ok.wav",
		SequenceFail = "drmatt/tardis/seq_bad.wav",
		Cloister = "tardis/cloisterbell_loop.wav"
	},
	ScreenDistance=500
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
	},
	Light={
		enabled=true,
		pos=Vector(0,0,122),
		color=Color(255,255,255)
	},
	ProjectedLight={
		--color=Color(r,g,b), --Base colour. Will use main interior light if not set.
		--warncolor=Color(r,g,b), --Warning colour. Will use main interior warn colour if not set.
		brightness=0.5, --Light's brightness
		--vertfov=90,
		--horizfov=90, --vertical and horizontal field of view of the light. Will default to portal height and width.
		farz=150, --FarZ property of the light. Determines how far the light projects.]]
		offset=Vector(-21,0,51.1), --Offset from box origin
		texture="effects/flashlight/square" --Texture the projected light will use. You can get these from the Lamp tool.
	},
	Sounds={
		Teleport={
			demat="drmatt/tardis/demat.wav",
			mat="drmatt/tardis/mat.wav",
			fullflight = "drmatt/tardis/full.wav"
		},
		RepairFinish="drmatt/tardis/repairfinish.wav",
		Lock="drmatt/tardis/lock.wav",
		Door={
			enabled=true,
			open="drmatt/tardis/door_open.wav",
			close="drmatt/tardis/door_close.wav"
		},
		FlightLoop="drmatt/tardis/flight_loop.wav",
	},
	Parts={
		vortex={
			model="models/doctorwho1200/toyota/2013timevortex.mdl",
			pos=Vector(0,0,50),
			ang=Angle(0,0,0),
			scale=10
		}
	},
	Teleport={
		SequenceSpeed=0.85,
		SequenceSpeedFast=0.935,
		DematSequence={
			150,
			200,
			100,
			150,
			50,
			100,
			0
		},
		MatSequence={
			100,
			50,
			150,
			100,
			200,
			150,
			255
		}
	}
}

TARDIS:AddInterior(T)