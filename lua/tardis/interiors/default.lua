local T = {}

T.Base = "base"
T.Name = "Interiors.Default"
T.ID = "default"

T.Interior = {

    Model="models/molda/toyota_int/interior.mdl",
    ExitDistance=600,
    LightOverride = {
        basebrightness = 0.05,
        nopowerbrightness = 0.001,
    },
    Light={
        color = Color(0,170,255),
        pos = Vector(0,0,-30),
        brightness = 8,
        warn_brightness = 6,
        NoLO = {
            brightness = 5,
            warn_brightness = 3,
        },
        NoExtra = {
            pos = Vector(0,0,187.4),
            brightness = 1,
        },
    },
    Lights={
        console_white = {
            pos = Vector(0,0,187.4),
            brightness = 0.4,
            color = Color(255,255,200),
            warn_color = Color(255,143,143),
            off_color = Color(0,120,200),
            off_brightness = 0.1,
            nopower = true,
        },
        console_bottom = {
            color = Color(0,170,255),
            pos = Vector(0,0,110),
            brightness = 0.5,
            warn_brightness = 0.2,
            nopower = true,
            off_color = Color(0,65,215),
            off_brightness = 0.2,
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

    Sounds = {
        Teleport = {
            demat = "p00gie/tardis/default/demat_int.ogg",
            mat = "p00gie/tardis/default/mat_int.ogg",
            fullflight = "p00gie/tardis/default/full_int.ogg",
            demat_fail = "p00gie/tardis/default/demat_fail.ogg",
            demat_hads = "p00gie/tardis/demat_hads.wav",
            interrupt = "p00gie/tardis/default/demat_interrupt.ogg",
        },
        FlightLoop = "p00gie/tardis/default/flight_loop.wav",
    },

    Scanners = {
        {
            part = "default_console_scanner",
            mat = "models/cem/toyota_contr/screen",
            width = 1024,
            height = 1024,
            ang = Angle(0,0,0),
            fov = 90,
        },
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
        default_pillars = {},
        default_rings = {},
        default_side_panels = {},
        default_chairs = {},
        default_casing = {},
        --default_corridors1 = {},
        --default_corridors2 = {},
        default_corridors_minimal = { ang = Angle(0,90,0), },
        default_console = { ang = Angle(0,90,0), },
        --default_neon = {},
        --default_rotor_base = {},
        default_side_details1 = {},
        default_side_details2 = {},
        --default_pistons = {},
        default_toplights = {},
        default_cables1 = {},
        default_cables2 = {},
        default_cables3 = {},
        default_roundels1 = {},
        default_roundels2 = {},
        default_bulbs = {},
        --default_transparent_parts = {},
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

        default_side_cranks1 = {
            pos = Vector(-5.781, -7.625, 0.5),
            ang = Angle(0, -1.54, 0),
        },
        default_side_cranks2 = {
            pos = Vector(2.98, 9.09, 0.5),
            ang = Angle(0, 198.54, 0),
        },

        default_side_toggles_1 = {},
        default_side_toggles_2 = { ang = Angle(0,160,0), },

        --default_monitor = {},
        --default_monitor_2012 = {},
        --default_monitor_2015 = {},

        default_top_doors_1 = { pos = Vector(-346.742, 125.858, 160.575), ang = Angle(0,70,0), },
        default_top_doors_2 = { pos = Vector(-346.742, -125.858, 160.575), ang = Angle(0,110,0), },

        default_monitor_1 = { ang = Angle(0,-120,0), },
        default_monitor_1_handles = { ang = Angle(0,-30,0), },
        default_monitor_1_collision = { ang = Angle(0,-30,0), },

        default_monitor_2 = { ang = Angle(0,60,0), },
        default_monitor_2_handles = { ang = Angle(0,150,0), },
        default_monitor_2_collision = { ang = Angle(0,150,0), },

        default_rotor_ring = {},
        default_rotor = {},

        --default_setroof = {},
        default_roof = {},

        default_intdoors_static = { pos = Vector(73.559, -417.853, 47.506), ang = Angle(0,10,0), },
        default_corridor_doors_static = { pos = Vector(-475.5, 213, 160.8) },
    },
    Controls = {
        default_throttle  = "teleport_double",
        default_handbrake  = "handbrake",
        default_side_lever1 = "engine_release",
        default_side_speakers = "music",
        default_telepathic  = "destination",
        default_console_scanner = "thirdperson_careful",
        default_balls  = "thirdperson",
        default_keyboard  = "coordinates",
        default_crank4 = "repair",
        default_crank2  = "power",
        default_crank3  = "redecorate",
        default_side_lever2 = "physlock",
        default_crank = "random_coords",
        default_buttons = "isomorphic",
        default_fiddle1  = "door",
        default_fiddle2  = "doorlock",
        default_crank6 = "cloak",
        default_crank5 = "spin_switch",
        default_tumblers = "vortex_flight",
        default_button2 = "toggle_scanners",
        default_red_flick_switch = "fastreturn",
        default_key = "toggle_console",
        default_sonic_charger = "sonic_dispenser",
        default_spin_crank = "hads",
        default_small_switch_18 = "exterior_light",

        default_spin_b_1 = "flight",
        default_spin_b_2 = "float",
        default_spin_b_3 = "toggle_scanners",
        default_spin_b_4 = "spin_toggle",
        default_thick_lever = "shields",
    },
    TipSettings = {},
    CustomTips = {},
    PartTips = {},
}

T.Exterior = {
    Sounds = {
        Spawn = "drmatt/tardis/repairfinish.wav",
        Delete = "p00gie/tardis/tardis_delete.wav",
    },
}

T.Timings = {
    DematInterrupt = 3,
    DematStartingAnimation = 3,
    MatStoppingAnimation = 3.2,
}

T.CustomHooks = {
    fast_top_bulbs = {
        exthooks = {
            ["DematStart"] = true,
            ["StopMat"] = true,
        },
        func = function(ext,int)
            if SERVER then return end
            if not IsValid(int) then return end

            local time, data

            if ext:GetData("demat") then
                time = ext.metadata.Timings.DematStartingAnimation
                data = "demat_animation"
            else
                time = ext.metadata.Timings.MatStoppingAnimation
                data = "mat_animation"
            end

            int:SetData(data, true)
            int:Timer(data, time, function()
                int:SetData(data, nil)
            end)
        end,
    },
    fast_top_bulbs_handbrake = {
        inthooks = {
            ["HandbrakeToggled"] = true,
        },
        func = function(ext,int,on)
            if CLIENT and on and IsValid(int) and int:GetData("mat_animation") then
                int:CancelTimer("mat_animation")
                int:SetData("mat_animation", nil)
            end
        end,
    },
}

T.CustomSettings = {
    color = {
        text = "Interiors.Default.CustomSettings.Color",
        value_type = "list",
        value = "dynamic",
        options = {
            ["dynamic"] = "Interiors.Default.CustomSettings.Color.Dynamic",
            ["blue"] = "Interiors.Default.CustomSettings.Color.Blue",
            ["green"] = "Interiors.Default.CustomSettings.Color.Green",
            ["turquoise"] = "Interiors.Default.CustomSettings.Color.Turquoise",
            ["random"] = "Interiors.Default.CustomSettings.Color.Random",
        },
    },
    lamps = {
        text = "Interiors.Default.CustomSettings.Lamps",
        value_type = "list",
        value = false,
        options = {
            [false] = "Interiors.Default.CustomSettings.Lamps.Off",
            ["few"] = "Interiors.Default.CustomSettings.Lamps.Few",
            ["many"] = "Interiors.Default.CustomSettings.Lamps.Many",
        },
    }
}

T.Templates = {
    default_exterior = { override = true, },
    default_lamps = {
        override = true,
        condition = function(id, ply, ent)
            return (TARDIS:GetCustomSetting(id, "lamps", ply) ~= false)
        end,
    },
    default_more_lamps = {
        override = true,
        condition = function(id, ply, ent)
            return (TARDIS:GetCustomSetting(id, "lamps", ply) == "many")
        end,
    },
    default_dynamic_color = {
        override = true,
        condition = function(id, ply, ent)
            local setting_val = TARDIS:GetCustomSetting(id, "color", ply)
            return (setting_val == "dynamic")
        end,
    },
    default_fixed_color = {
        override = true,
        condition = function(id, ply, ent)
            local setting_val = TARDIS:GetCustomSetting(id, "color", ply)
            return (setting_val ~= "dynamic")
        end,
    },
    default_color_update = {},
}
T.TemplatesMergeOrder = {
    "default_lamps",
    "default_more_lamps",
}

TARDIS:AddInterior(T)
