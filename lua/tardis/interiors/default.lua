local T = {}

T.Base = "base"
T.Name = "Interiors.Default"
T.ID = "default"

T.Interior = {

    Model="models/molda/toyota_int/interior.mdl",
    ExitDistance=1450,
    LightOverride = {
        basebrightness = 0.25,
        nopowerbrightness = 0.001,
    },
    Light={
        color=Color(0,170,255),
        pos=Vector(0,0,110),
        brightness=0.5,
        warn_color=Color(0,51,51),
        nopower = true,
        off_color = Color(0,65,215),
        off_brightness = 0.2,
    },
    Lights={
        console_white = {
            pos=Vector(0,0,187),
            brightness=0.3,
            color=Color(100,140,210),
            warncolor=Color(255,143,143),
        },
        lower_light = {
            color=Color(0,170,255),
            warncolor=Color(51,102,102),
            pos=Vector(0,0,-30),
            brightness=3,
        },
    },

    Portal={
        --pos=Vector(-314,0,139.8),
        pos = Vector(-322.5, 0, 139.8),
        ang=Angle(0,0,0),
        width=50,
        height=92,
        thickness = -2,
    },

    Fallback={
        pos=Vector(-280,0,100),
        ang=Angle(0,0,0)
    },
    Parts = {
        door = {
            model="models/vtalanov98/toyota_ext/doors_interior.mdl",
            posoffset=Vector(0.8,0,-52.8),
            angoffset=Angle(0,180,0),
        },
        default_doorframe = {},
        default_doorframe_light = {},
        default_floor = {},
        default_entry = {},
        default_walls = {},
        --default_roof = {},
        default_setroof = {},
        default_pillars = {},
        default_rings = {},
        default_side_panels = {},
        default_chairs = {},
        default_casing = {},
        default_corridors1 = {},
        default_corridors2 = {},
        default_console = { ang = Angle(0,90,0), },
        default_neon = {},
        default_rotor_base = {},
        default_side_details1 = {},
        default_side_details2 = {},
        default_pistons = {},
        default_toplights = {},
        default_cables1 = {},
        default_cables2 = {},
        default_cables3 = {},
        default_roundels1 = {},
        default_roundels2 = {},
        default_bulbs = {},
        default_transparent_parts = {},
        default_ticks = {},

        default_gears1 = {},
        default_gears2 = {},
        default_gears3 = {},

        default_handbrake = {},
        default_keyboard = {},
        default_telepathic = {},
        default_throttle = {},

        default_side_lever1 = { pos = Vector(100.487, 114.569, 126.76), },
        default_side_lever2 = { pos = Vector(-55.242, -142.028, 126.76), },
        default_side_dial = {},
        default_side_speakers = {},
        default_throttle_lights = {},

    },
    Controls = {

    },
    TipSettings = {},
    CustomTips = {},
    PartTips = {},
}

T.Exterior = {}

T.Templates = {
    default_exterior = { override = true, },
}


TARDIS:AddInterior(T)
