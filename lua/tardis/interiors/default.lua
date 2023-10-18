-- Default

local function SonicModelExists()
    if SonicSD and file.Exists("models/weapons/c_sonicsd.mdl", "GAME") then
        return true
    end
    return false
end

local T = {}

T.Versions = {
    randomize = false,
    allow_custom = false,
    randomize_custom = false,

    main = {
        id = "default",
    },
    other = {
        {
            name = "Interiors.Default.Versions.TTCapsuleType40",
            id = "default_tt_type40",
        },
        {
            name = "Interiors.Default.Versions.TTCapsuleType50",
            id = "default_tt_type50",
        },
        {
            name = "Interiors.Default.Versions.TTCapsuleType55",
            id = "default_tt_type55",
        },
        {
            name = "Interiors.Default.Versions.TTCapsuleType55B",
            id = "default_tt_type55b",
        },
        {
            name = "Interiors.Default.Versions.SIDRAT",
            id = "default_sidrat",
        },
    },
}


T.Base = "base"
T.Name = "Interiors.Default"
T.ID = "default"
T.Interior = {
    Model = "models/drmatt/tardis/interior.mdl",
    IdleSound = {
        {
            path = "drmatt/tardis/default/interior_idle_loop.wav",
            volume = 0.5
        },
        {
            path = "drmatt/tardis/default/interior_idle2_loop.wav",
            volume = 0.5
        }
    },
    Light = {
        color = Color(255, 50, 0),
        warncolor = Color(255, 0, 0),
        pos = Vector(0, 0, 120),
        brightness = 5
    },
    Lights = {
        {
            color = Color(0, 255, 0),
            pos = Vector(0, 0, -50),
            brightness = 2,
            nopower = true
        }
    },
    Portal = {
        pos = Vector(316.7, 334.9, -33.7),
        ang = Angle(0, 230, 0),
        width = 45,
        height = 91
    },
    Fallback = {
        pos = Vector(291, 305, -75),
        ang = Angle(0, 230, 0)
    },
    Screens = {
        {
            pos = Vector(44.5, -6.5, 39),
            ang = Angle(0, 84.5, 91),
            width = 227.75,
            height = 140,
            gui_rows = 2,
            power_off_black = true
        }
    },
    Scanners = {
        {
            mat = "models/drmatt/tardis/tardisscanner",
            width = 1024,
            height = 1024,
            ang = Angle(0,0,0),
            fov = 90,
        }
    },
    Sounds = {
        Teleport = {
            demat = "drmatt/tardis/demat.wav",
            mat = "drmatt/tardis/mat.wav",
            mat_fast = "p00gie/tardis/mat_fast.wav",
            mat_damaged_fast = "p00gie/tardis/mat_damaged_fast.wav",
            fullflight = "drmatt/tardis/full.wav",
        },
    },
    Sequences = "default_sequences",
    Parts = {
        door = {
            posoffset=Vector(28,0,-54.6),
            ang = Angle(0, 50, 0),
            width = 443,
            height = 335
        },
        default_rails = true,
        default_throttle            =   {pos = Vector(-8.87, -50, 5.5),                     ang = Angle(-12, -5, 24),               },
        default_flightlever         =   {pos = Vector(-0.431641, 44.75, 6.4),               ang = Angle(-63.913, 137.035, 136.118), },
        default_screen              =   {pos = Vector(42, 0.75, 27.1),                      ang = Angle(0, -5, 0),                  },
        default_screenbutton        =   {pos = Vector(44.5, 9.75, 38.2),                    ang = Angle(215, 85, 90),               },
        default_scannerbutton       =   {pos = Vector(42, -31.5, 1.4),                      ang = Angle(-25, 150, -10)              },
        default_wibblylever         =   {pos = Vector(-48, 18, 5.4),                        ang = Angle(335, 347, 6),               },
        default_enginerelease       =   {pos = Vector(-61.229, 21.622, -4.514),             ang = Angle(180, 90.911, -90),          },
        default_doorbutton          =   {pos = Vector(-60.782, -25.129, -6.108),            ang = Angle(0, 65.911, -81.515),        },
        default_powerlever          =   {pos = Vector(44, -18, 5.5),                        ang = Angle(22, 328, 347.5),            },
        default_keyboard            =   {pos = Vector(29, -53, -8),                         ang = Angle(0, 30, 50),                 },
        default_hads                =   {pos = Vector(39, 22.75, 5.828125),                 ang = Angle(296.260, 78.027, 136.528),  },
        default_typewriter          =   {pos = Vector(19.002930, 48.807617, 2.078125),      ang = Angle(0.945, 330.128, 339.750),   },
        default_repairlever         =   {pos = Vector(-6.623535, 44.351563, 7),             ang = Angle(349, 5, 337),               },
        default_redecoratebutton    =   {pos = Vector(-6.412, 53.588, 1.556),               ang = Angle(9.445, 46.482, -21.861),    },
        default_handbrake           =   {pos = Vector(-40.088379, -21.466797, 7.924805),    ang = Angle(290.494, 208.321, 182.157), },
        default_gramophone          =   {pos = Vector(-26, -1.5, 30),                       ang = Angle(0, 30, 0),                  },
        default_biglever            =   {pos = Vector(-9.94, -65, -52),                     ang = Angle(0, 270, 0),                 },
        default_physlock            =   {pos = Vector(39.5, -22.75, 6.914063),              ang = Angle(303.286, 6.660, 148.819),   },
        default_isomorphic          =   {pos = Vector(-39.5, 22, 6.629883),                 ang = Angle(290.762, 195, 137.777),     },
        default_atomaccel           =   {pos = Vector(20, -37.669998, 1.75),                ang = Angle(0, 0, 0),                   },
        default_directionalpointer  =   {pos = Vector(12.5, -24.5, 23),                     ang = Angle(0, 30, 0),                  },
        default_float               =   {pos = Vector(-2.5, -45.5, 7.75),                   ang = Angle(-56.714, -54.280, 148.819), },
        default_blacksticks         =   {pos = Vector(4.480469, -43.906372, 7),             ang = Angle(13, 0, 24.176),             },
        default_longflighttoggle    =   {pos = Vector(-37.242310, -27.915344, 7.428223),    ang = Angle(338, 28.721, 15),           },
        default_dematcircuit        =   {pos = Vector(-43.168457, -31.015625, 4.7),         ang = Angle(22, 209.224, 348),          },
        default_sonicdispenser      =   {pos = Vector(-26.048, 42.31, 1.45),                ang = Angle(9.445, 46.482, -21.861),    },
        default_helmic              =   {pos = Vector(-26, -41, 4),                         ang = Angle(0, 330, 24.5),              },
        default_sonic_inserted      =   SonicModelExists() and
                                        {pos = Vector(-29.748, 40.71, -20.15),              ang = Angle(-100, -90, 90),             },
        default_doorframe = {
            pos = Vector(317, 336.3, -80),
            ang = Angle(0, -40, 0),
            scale = 0.764,
            matrixScale = Vector(1, 1, 1.083)
        },
        default_doorframe_bottom = {
            pos = Vector(317, 335.8, -93.5),
            ang = Angle(0, 50, 0),
            scale = 1.14,
            matrixScale = Vector(0.53, 1.02, 1)
        },
        default_doorframe_bottom2 = {
            pos = Vector(317, 335.8, -93.5),
            ang = Angle(0, 230, 0),
            scale = 1.14,
            matrixScale = Vector(0.54, 1.02, 1)
        },
    },
    Controls = {
        default_throttle            = "teleport_double",
        default_flightlever         = "flight",
        default_screen              = nil,
        default_screenbutton        = "toggle_screens",
        default_scannerbutton       = "toggle_scanners",
        default_wibblylever         = "doorlock",
        default_enginerelease       = "engine_release",
        default_doorbutton          = "door",
        default_powerlever          = "power",
        default_keyboard            = "destination",
        default_hads                = "hads",
        default_typewriter          = "coordinates",
        default_repairlever         = "repair",
        default_redecoratebutton    = "redecorate",
        default_handbrake           = "handbrake",
        default_gramophone          = "music",
        default_biglever            = "fastreturn",
        default_physlock            = "physlock",
        default_isomorphic          = "isomorphic",
        default_float               = "float",
        default_blacksticks         = "cloak",
        default_longflighttoggle    = "vortex_flight",
        default_dematcircuit        = nil,
        default_sonicdispenser      = "sonic_dispenser",
        default_sonic_inserted      = SonicModelExists() and "sonic_dispenser",
        default_helmic              = "thirdperson",
        default_atomaccel           = "spin_toggle",
        default_directionalpointer  = "spin_switch",


    },
    Tips = {},
    -- Interior.Tips are deprecated; should be deleted when the extensions update and
    -- replace with Interior.CustomTips, Interior.PartTips and Interior.TipSettings
    TipSettings = {
        view_range_min = 70,
        view_range_max = 90,
    },
    CustomTips = {
        --{ text = "Example", pos = Vector(0, 0, 0) },
    },
    PartTips = {

        default_throttle            =   {pos = Vector(-8.87, -50, 5.5), down = true},
        default_flightlever         =   {pos = Vector(-1, 59, 2), down = true},
        default_screen              =   {pos = Vector(42, 0.75, 29.1), down = true},
        default_screenbutton        =   {pos = Vector(47, 10, 38), right = true},
        default_scannerbutton        =  {pos = Vector(43, -32, 3.5), down = true},
        default_wibblylever         =   {pos = Vector(-48, 18, 5.4), right = true},
        default_enginerelease       =   {pos = Vector(-61.229, 21.622, -4.514), down = true},
        default_doorbutton          =   {pos = Vector(-62.699, -24.23, -5.506), down = true},
        default_powerlever          =   {pos = Vector(44, -18, 5.5), right = true},
        default_keyboard            =   {pos = Vector(29, -53, -8), right = true, down = true},
        default_hads                =   {pos = Vector(52, 31, 1), down = true},
        default_typewriter          =   {pos = Vector(19, 48.80, 2.07) },
        default_repairlever         =   {pos = Vector(-8, 45, 9), right = true},
        default_redecoratebutton    =   {pos = Vector(-6.542, 54.408, 3.081), down = true, right = true},
        default_handbrake           =   {pos = Vector(-52, -29, 2), down = true},
        default_gramophone          =   {pos = Vector(-26, -1.50, 40), right = true, down = true},
        default_biglever            =   {pos = Vector(-9.94, -65, -12) },
        default_physlock            =   {pos = Vector(52, -30, 0), down = true},
        default_isomorphic          =   {pos = Vector(-52, 29, 2), down = true},
        default_atomaccel           =   {pos = Vector(20, -38, 6), right = true},
        default_directionalpointer  =   {pos = Vector(12.5, -24.5, 23) },
        default_float               =   {pos = Vector(-2, -60, 1), right = true, down = true},
        default_blacksticks         =   {pos = Vector(4.48, -43.9, 7) },
        default_longflighttoggle    =   {pos = Vector(-37.24, -27.91, 7.42) },
        default_dematcircuit        =   {pos = Vector(-43.16, -31.01, 4.7), right = true, down = true},
        default_sonicdispenser      =   {pos = Vector(-26.048, 42.31, 3.15), right = true, down = false},
        default_helmic = {
            pos = Vector(-26, -41, 4),
            right = true,
            view_range_max = 70, --less view range since there's a lot stuff in the way
            view_range_min = 50,
        },
    },
    Seats = {
        {
            pos = Vector(130, -96, -30),
            ang = Angle(0, 40, 0)
        },
        {
            pos = Vector(125, 55, -30),
            ang = Angle(0, 135, 0)
        }
    },
    BreakdownEffectPos = Vector(0, 0, 40),
}

T.Exterior = {
    Parts = {
        door = {
            posoffset=Vector(-28,0,-54.6)
        }
    },
    Sounds = {
        Teleport = {
            demat = "drmatt/tardis/demat.wav",
            demat_fast = "drmatt/tardis/demat.wav",
            mat = "drmatt/tardis/mat.wav",
            mat_fast = "p00gie/tardis/mat_fast.wav",
            mat_damaged_fast = "p00gie/tardis/mat_damaged_fast.wav",
            fullflight = "drmatt/tardis/full.wav",
            interrupt = "drmatt/tardis/repairfinish.wav",
        },
        Spawn = "drmatt/tardis/repairfinish.wav",
        RepairFinish = "drmatt/tardis/repairfinish.wav",
        Delete = "p00gie/tardis/tardis_delete.wav",
        FlightLand = "p00gie/tardis/tardis_landing.wav",
    },
    Light = {
        warncolor = Color(255,200,200),
    },
    PhaseMaterial = "models/drmatt/tardis/exterior/phase.vmt",
    Portal = {
        pos = Vector(28,0,54.6),
        ang = Angle(0,0,0),
        width = 45,
        height = 92,
        thickness = 42,
        inverted = true,
    },
}

local function playerlookingat(self,ply,vec,fov,width)
    local disp = vec - self:WorldToLocal(ply:GetPos()+Vector(0,0,64))
    local dist = disp:Length()

    local maxcos = math.abs( math.cos( math.acos( dist / math.sqrt( dist * dist + width * width ) ) + fov * ( math.pi / 180 ) ) )
    disp:Normalize()

    if disp:Dot( ply:EyeAngles():Forward() ) > maxcos then
        return true
    end

    return false
end

T.Interior.CustomHooks = {
    init_rotor = {
        "Initialize",
        function(self)
            self.timerotor={}
            self.timerotor.pos=0
            self.timerotor.mode=1
        end
    },
    think_rotor = {
        "Think",
        function(self)
            local moving = self:GetData("teleport",false)
            local flightmode = self:GetData("flight",false)
            local active = (moving or flightmode)
            if not CLIENT then return end
            if active or self.timerotor.pos > 0 then
                if self.timerotor.pos==1 then
                    self.timerotor.mode=0
                elseif active and self.timerotor.pos==0 then
                    self.timerotor.mode=1
                end
                self.timerotor.pos=math.Approach( self.timerotor.pos, self.timerotor.mode, FrameTime()*1.1 )
                self:SetPoseParameter( "glass", self.timerotor.pos )
            end
        end,
    },
    use_console = {
        "Use",
        function(self,a,c)
            if SERVER and a:IsPlayer() and (not a:GetTardisData("outside")) and CurTime() > a:GetTardisData("outsidecool",0) then
                local pos=Vector(0,0,0)
                local pos2=self:WorldToLocal(a:GetPos())
                local distance=pos:Distance(pos2)
                if distance < 110 and playerlookingat(self,a,pos,10,10) then
                    TARDIS:Control("thirdperson_careful", a)
                end
            end
        end,
    },
}

TARDIS:AddInterior(T)
