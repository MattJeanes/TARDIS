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

        default_bouncy_lever = { pos = Vector(37.6148, 12.5797, 134.562), },
        default_button_1 = {},
        default_button_2 = { pos = Vector(0,9.4,0), },
        default_buttons = {},
        default_crank = {},
        default_crank2 = {},
        default_crank3 = {},
        default_crank4 = {},
        default_crank5 = {},
        default_crank6 = {},
        default_ducks = {},
        default_fiddle1 = { pos = Vector(-47.83, 20.39, 128.36), },
        default_fiddle2 = { pos = Vector(-47.83, 17.33, 128.36), },
        default_flat_switch_1 = { pos = Vector(-10.1897, 28.1115, 137.23), },
        default_flat_switch_2 = { pos = Vector(-11.3625, 27.4343, 137.23), },
        default_flat_switch_3 = { pos = Vector(-12.5354, 26.7572, 137.23), },
        default_flat_switch_4 = { pos = Vector(-16.7892, 24.3012, 137.23), },
        default_flat_switch_5 = { pos = Vector(-17.9621, 23.6241, 137.23), },
        default_flat_switch_6 = { pos = Vector(-19.1350, 22.9469, 137.23), },
        default_flippers = {},
        default_handle1 = {pos = Vector(-32.0253, -11.1286, 136.032), ang = Angle(33.87, 94.5, -24.402)},
        default_handle2 = {pos = Vector(-32.0253, 11.1286, 136.032), },
        default_key = {},

        default_red_lever_1 = {},
        default_red_lever_2 = { pos = Vector(0,26.55,0), },

        default_thick_lever = {},

        default_colored_lever_1 = { pos = Vector(31.28, -6.48, 134.362), },
        default_colored_lever_2 = { pos = Vector(31.28, -3.23, 134.362), },
        default_colored_lever_3 = { pos = Vector(31.28,  0.00, 134.362), },
        default_colored_lever_4 = { pos = Vector(31.28,  3.24, 134.362), },
        default_colored_lever_5 = { pos = Vector(31.28,  6.47, 134.362), },

        default_phone = {},
        default_red_flick_cover = { pos = Vector(46.8003, 20.3683, 130.056), },
        default_red_flick_switch = { pos = Vector(48.3763, 20.3791, 129.36), },
        default_sliders = {},

        default_small_switch_1  = { pos = Vector(-43.5688,9.2562,129.997), },
        default_small_switch_2  = { pos = Vector(-43.5688,8.45203,129.997), },
        default_small_switch_3  = { pos = Vector(-43.5688,7.64787,129.997), },
        default_small_switch_4  = { pos = Vector(-43.5688,6.84371,129.997), },
        default_small_switch_5  = { pos = Vector(-43.5688,6.03954,129.997), },
        default_small_switch_6  = { pos = Vector(-43.5688,-2.63501,129.997), },
        default_small_switch_7  = { pos = Vector(-43.5688,5.23538,129.997), },
        default_small_switch_8  = { pos = Vector(-43.5688,4.43121,129.997), },
        default_small_switch_9  = { pos = Vector(-43.5688,3.62705,129.997), },
        default_small_switch_10 = { pos = Vector(-43.5688,2.82289,129.997), },
        default_small_switch_11 = { pos = Vector(-43.5688,-3.43917,129.997), },
        default_small_switch_12 = { pos = Vector(-43.5688,-4.24334,129.997), },
        default_small_switch_13 = { pos = Vector(-43.5688,-5.0475,129.997), },
        default_small_switch_14 = { pos = Vector(-43.5688,-5.85166,129.997), },
        default_small_switch_15 = { pos = Vector(-43.5688,-6.65583,129.997), },
        default_small_switch_16 = { pos = Vector(-43.5688,-7.45999,129.997), },
        default_small_switch_17 = { pos = Vector(-43.5688,-8.26416,129.997), },
        default_small_switch_18 = { pos = Vector(-43.5688,-9.06832,129.997), },

        default_spin_a_1 = { pos = Vector(-48.304,  9.401, 129.35), },
        default_spin_a_2 = { pos = Vector(-48.304,  4.707, 129.35), },
        default_spin_a_3 = { pos = Vector(-48.304, -0.009, 129.35), },
        default_spin_a_4 = { pos = Vector(-48.304, -4.644, 129.35), },
        default_spin_a_5 = { pos = Vector(-48.304, -9.453, 129.35), },

        default_spin_b_1 = { pos = Vector(-10.011, 45.859, 130.910), ang = Angle(0, -2.574, 0) },
        default_spin_b_2 = { pos = Vector(-14.892, 46.776, 129.530), ang = Angle(-2.88, -7.88, 4.089) },
        default_spin_b_3 = { pos = Vector(-33.016, 36.267, 129.530), ang = Angle(-4.68, -21.49, 4.023) },
        default_spin_b_4 = { pos = Vector(-34.663, 31.617, 130.910), ang = Angle( 1.56,  9.08, -1.378) },

        default_spin_big = { pos = Vector(33.5519, -30.4627, 130.518), ang = Angle(11.6955,-19.35,-2) },
        default_spin_crank = { pos = Vector(-39.865, -31.28, 129.931), ang = Angle(0, -4.62, 0) },
        default_spin_switch = { pos = Vector(32.9344, -25.9602, 132.217), ang = Angle(0, -4.62, 0) },

        default_switch = {},
        default_switch2 = {},
        default_toggles = {},
        default_toggles2 = {},
        default_tumblers = {},

        default_balls = {},
        default_console_scanner = {},

        --default_monitor = {},
        --default_monitor_2012 = {},
        --default_monitor_2015 = {},
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


--[[

_TODO:

add side white cranks
side red switches
console scanner from new version?
clean duplicating textures from cem/ subfolder
fix sonic charger material
dynamic environment (distance?)
selectable colors

_Choose models:

balls.mdl
console_scanner.mdl
sliders.mdl
telepathic.mdl
cranks.mdl


_Removed:

audio_system.mdl
audio_system_2012.mdl
throttle.mdl
gears.mdl
handbrake.mdl
holder.mdl
keyboard.mdl
levers.mdl
phone_port.mdl
sonic_charger.mdl
lever3.mdl


Control materials:
models/cem/toyota_contr/console.vmt
models/cem/toyota_contr/console1.vtf
models/cem/toyota_contr/details_normal.vtf
models/cem/toyota_contr/details.vmt
models/cem/toyota_contr/details.vtf
models/cem/toyota_contr/detailsm.vmt
models/cem/toyota_contr/glass_normal.vtf
models/cem/toyota_contr/metal_env.vtf
models/cem/toyota_contr/metal_normal.vtf
models/cem/toyota_contr/newswitches.vmt
models/cem/toyota_contr/newswitches.vtf
models/cem/toyota_contr/screen.vmt
models/cem/toyota_contr/screen.vtf
models/cem/toyota_contr/white.vtf

]]