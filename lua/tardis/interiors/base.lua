-- Base

local T = {}
T.Base = true
T.Name = "Base"
T.ID = "base"
T.Interior = {
	Model = "models/drmatt/tardis/interior.mdl",
	ExitDistance = 600,
	Portal = {
		pos = Vector(-1,-353.5,136),
		ang = Angle(0,90,0),
		width = 60,
		height = 91
	},
	Fallback = {
		pos = Vector(0,-330,95),
		ang = Angle(0,90,0)
	},
	Sounds = {
		Teleport = {
			demat_fail = "drmatt/tardis/demat_fail_int.wav"
		}, -- uses exterior sounds if not specified
		Power = {
			On = "drmatt/tardis/power_on.wav",
			Off = "drmatt/tardis/power_off.wav"
		},
		SequenceOK = "drmatt/tardis/seq_ok.wav",
		SequenceFail = "drmatt/tardis/seq_bad.wav",
		Cloister = "drmatt/tardis/cloisterbell_loop.wav",
		Lock = "drmatt/tardis/lock_int.wav",
	},
	Tips = {},
	CustomTips = {},
	PartTips = {},
	TipSettings = {
		style = "white_on_grey",
		view_range_min = 70,
		view_range_max = 100,
	},
	LightOverride = {
		basebrightness = 0.3, --Base interior brightness when power is on.
		nopowerbrightness = 0.05 --Interior brightness with no power. Should always be darker than basebrightness.
	},
	ScreenDistance = 500,
	ScreensEnabled = true
}
T.Exterior = {
	Model = "models/drmatt/tardis/exterior/exterior.mdl",
	Mass = 5000,
	DoorAnimationTime = 0.5,
	ScannerOffset = Vector(22,0,50),
	Portal = {
		pos = Vector(26,0,51.65),
		ang = Angle(0,0,0),
		width = 44,
		height = 91
	},
	Fallback = {
		pos = Vector(60,0,5),
		ang = Angle(0,0,0)
	},
	Light = {
		enabled = true,
		pos = Vector(0,0,122),
		color = Color(255,255,255),
		dynamicpos = Vector(0,0,130),
		dynamicbrightness = 2,
		dynamicsize = 300
	},
	ProjectedLight = {
		--color = Color(r,g,b), --Base color. Will use main interior light if not set.
		--warncolor = Color(r,g,b), --Warning color. Will use main interior warn color if not set.
		brightness = 0.1, --Light's brightness
		--vertfov = 90,
		--horizfov = 90, --vertical and horizontal field of view of the light. Will default to portal height and width.
		farz = 750, --FarZ property of the light. Determines how far the light projects.]]
		offset = Vector(-21,0,51.1), --Offset from box origin
		texture = "effects/flashlight/square" --Texture the projected light will use. You can get these from the Lamp tool.
	},
	Sounds = {
		Teleport = {
			demat = "drmatt/tardis/demat.wav",
			demat_damaged = "drmatt/tardis/demat_damaged.wav",
			demat_fail = "drmatt/tardis/demat_fail_ext.wav",
			mat = "drmatt/tardis/mat.wav",
			mat_damaged = "drmatt/tardis/mat_damaged.wav",
			fullflight = "drmatt/tardis/full.wav",
			fullflight_damaged = "drmatt/tardis/full_damaged.wav",
		},
		RepairFinish = "drmatt/tardis/repairfinish.wav",
		Lock = "drmatt/tardis/lock.wav",
		Door = {
			enabled = true,
			open = "drmatt/tardis/door_open.wav",
			close = "drmatt/tardis/door_close.wav",
			locked = "drmatt/tardis/door_locked.wav"
		},
		FlightLoop = "drmatt/tardis/flight_loop.wav",
		FlightLoopDamaged = "drmatt/tardis/flight_loop_damaged.wav",
		Cloak = "drmatt/tardis/phase_enable.wav",
		CloakOff = "drmatt/tardis/phase_disable.wav",
	},
	Parts = {
		vortex = {
			model = "models/doctorwho1200/toyota/2013timevortex.mdl",
			pos = Vector(0,0,50),
			ang = Angle(0,0,0),
			scale = 10
		}
	},
	Teleport = {
		SequenceSpeed = 0.77,
		SequenceSpeedFast = 0.935,
		DematSequence = {
			150,
			200,
			100,
			150,
			50,
			100,
			0
		},
		MatSequence = {
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