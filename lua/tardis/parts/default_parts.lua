local PART = {}
PART.ID = "default_doorframe"
PART.Model = "models/molda/toyota_int/frame.mdl"
PART.AutoSetup = true

TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_doorframe_light"
PART.Model = "models/molda/toyota_int/frame2.mdl"
PART.AutoSetup = true

TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_floor"
PART.Model = "models/molda/toyota_int/floor.mdl"
PART.AutoSetup = true
PART.Collision = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_walls"
PART.Model = "models/molda/toyota_int/walls.mdl"
PART.AutoSetup = true
PART.Collision = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_entry"
PART.Model = "models/molda/toyota_int/entry.mdl"
PART.AutoSetup = true
PART.Collision = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_pillars"
PART.Model = "models/molda/toyota_int/pillars.mdl"
PART.AutoSetup = true
PART.Collision = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_roof"
PART.Model = "models/molda/toyota_int/roof.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_setroof"
PART.Model = "models/molda/toyota_int/setroof.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_rings"
PART.Model = "models/molda/toyota_int/rings.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_cables1"
PART.Model = "models/molda/toyota_int/cables1.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_cables2"
PART.Model = "models/molda/toyota_int/cables2.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_cables3"
PART.Model = "models/molda/toyota_int/cables3.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_chairs"
PART.Model = "models/molda/toyota_int/chairs.mdl"
PART.AutoSetup = true
PART.Collision = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_casing"
PART.Model = "models/molda/toyota_int/casing.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_console"
PART.Model = "models/molda/toyota_int/console.mdl"
PART.AutoSetup = true
PART.Collision = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_corridors1"
PART.Model = "models/molda/toyota_int/corridors1.mdl"
PART.AutoSetup = true
PART.Collision = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_corridors2"
PART.Model = "models/molda/toyota_int/corridors2.mdl"
PART.AutoSetup = true
PART.Collision = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_neon"
PART.Model = "models/molda/toyota_int/neon_cyan.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_rotor_base"
PART.Model = "models/molda/toyota_int/rotor_base_smith.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_side_details1"
PART.Model = "models/molda/toyota_int/side_details1.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_side_details2"
PART.Model = "models/molda/toyota_int/side_details2.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_pistons"
PART.Model = "models/molda/toyota_int/pistons.mdl"
PART.AutoSetup = true
PART.UseTransparencyFix = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_toplights"
PART.Model = "models/molda/toyota_int/toplights.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_roundels1"
PART.Model = "models/molda/toyota_int/roundels1.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_roundels2"
PART.Model = "models/molda/toyota_int/roundels2.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_bulbs"
PART.Model = "models/molda/toyota_int/bulbs.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_transparent_parts"
PART.Model = "models/molda/toyota_int/transparent.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.UseTransparencyFix = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_ticks"
PART.Model = "models/molda/toyota_int/ticks.mdl"
PART.AutoSetup = true
PART.ShouldTakeDamage = false

if CLIENT then
    function PART:Initialize()
        self.posepos = 0
        self.speed = 0.1
    end

    function PART:Think()
        local ext=self.exterior

        local power = ext:GetPower()
        if not power then return end

        self.posepos=math.Approach(self.posepos,1,FrameTime()*self.speed)
        if self.posepos==1 then
            self.posepos=0
        end
        self:SetPoseParameter("switch",self.posepos)
        self:InvalidateBoneCache()
    end
end

TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_gears1"
PART.Model = "models/molda/toyota_int/gears1.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.ShouldTakeDamage = false

PART.Animate = true
PART.AnimateSpeed = 1.2
PART.CycleUseAnimation = true
PART.CompensateSlowdownAnimation = { start = 0.2, stop = 0.8, speed = 3.6 }
--PART.Sound = "molda/toyotaredo/gears.wav"
--PART.PowerOffSound = true
--PART.PowerOffUse = true
TARDIS:AddPart(PART)

PART.ID = "default_gears2"
PART.Model = "models/molda/toyota_int/gears2.mdl"
PART.AnimateSpeed = 1.5
PART.CompensateSlowdownAnimation = { start = 0.2, stop = 0.8, speed = 4.5 }
TARDIS:AddPart(PART)

PART.ID = "default_gears3"
PART.Model = "models/molda/toyota_int/gears3.mdl"
PART.AnimateSpeed = 1
PART.CompensateSlowdownAnimation = { start = 0.2, stop = 0.8, speed = 3 }
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_handbrake"
PART.Model = "models/molda/toyota_int/handbrake.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.ShouldTakeDamage = false
PART.Animate = true
PART.AnimateSpeed = 1.2
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_throttle"
PART.Model = "models/molda/toyota_int/throttle.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.ShouldTakeDamage = false
PART.Animate = true
PART.AnimateSpeed = 1.2
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_keyboard"
PART.Model = "models/molda/toyota_int/keyboard.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.ShouldTakeDamage = false
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_telepathic"
PART.Model = "models/molda/toyota_int/telepathic.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.ShouldTakeDamage = false
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_side_lever1"
PART.Model = "models/molda/toyota_int/sidelever1.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.ShouldTakeDamage = false
PART.Animate = true
PART.AnimateSpeed = 4
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_side_lever2"
PART.Model = "models/molda/toyota_int/sidelever2.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.ShouldTakeDamage = false
PART.Animate = true
PART.AnimateSpeed = 3
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_side_dial"
PART.Model = "models/molda/toyota_int/side_dial.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_throttle_lights"
PART.Model = "models/molda/toyota_int/throttle_lights.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_side_speakers"
PART.Model = "models/molda/toyota_int/side_speakers.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.ShouldTakeDamage = false
TARDIS:AddPart(PART)


------------------------------
-- ported from Toyota addon --
------------------------------

local PART = {}
PART.ID = "default_bouncy_lever"
PART.Model = "models/cem/toyota_contr/bouncy_lever.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.Model = "models/cem/toyota_contr/button.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

PART.ID = "default_button_1"
TARDIS:AddPart(PART)

PART.ID = "default_button_2"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_buttons"
PART.Model = "models/cem/toyota_contr/buttons.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_crank"
PART.Model = "models/cem/toyota_contr/crank.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_crank2"
PART.Model = "models/cem/toyota_contr/crank2.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_crank3"
PART.Model = "models/cem/toyota_contr/crank3.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_crank4"
PART.Model = "models/cem/toyota_contr/crank4.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_crank5"
PART.Model = "models/cem/toyota_contr/crank5.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_crank6"
PART.Model = "models/cem/toyota_contr/crank6.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_ducks"
PART.Model = "models/cem/toyota_contr/ducks.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_flippers"
PART.Model = "models/cem/toyota_contr/flippers.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_fiddle1"
PART.Model = "models/cem/toyota_contr/fiddle1.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_fiddle2"
PART.Model = "models/cem/toyota_contr/fiddle2.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.Model = "models/cem/toyota_contr/flat_switch.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

for i = 1,6 do
    PART.ID = "default_flat_switch_" .. i
    TARDIS:AddPart(PART)
end

local PART = {}
PART.ID = "default_handle1"
PART.Model = "models/cem/toyota_contr/handle1.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_handle2"
PART.Model = "models/cem/toyota_contr/handle2.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_key"
PART.Model = "models/cem/toyota_contr/key.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.Model = "models/cem/toyota_contr/red_lever.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

PART.ID = "default_red_lever_1"
TARDIS:AddPart(PART)
PART.ID = "default_red_lever_2"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_thick_lever"
PART.Model = "models/cem/toyota_contr/thick_lever.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_colored_lever_1"
PART.Model = "models/cem/toyota_contr/colored_lever_1.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_colored_lever_2"
PART.Model = "models/cem/toyota_contr/colored_lever_2.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_colored_lever_3"
PART.Model = "models/cem/toyota_contr/colored_lever_3.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_colored_lever_4"
PART.Model = "models/cem/toyota_contr/colored_lever_4.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_colored_lever_5"
PART.Model = "models/cem/toyota_contr/colored_lever_5.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_phone"
PART.Model = "models/cem/toyota_contr/phone.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_red_flick_cover"
PART.Model = "models/cem/toyota_contr/red_flick_cover.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_red_flick_switch"
PART.Model = "models/cem/toyota_contr/red_flick_switch.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_sliders"
PART.Model = "models/cem/toyota_contr/sliders.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.Model = "models/cem/toyota_contr/small_switch.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

for i = 1,18 do
    PART.ID = "default_small_switch_" .. i
    TARDIS:AddPart(PART)
end

local PART = {}
PART.Model = "models/cem/toyota_contr/spin_a.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

for i = 1,5 do
    PART.ID = "default_spin_a_" .. i
    TARDIS:AddPart(PART)
end

local PART = {}
PART.Model = "models/cem/toyota_contr/spin_b.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

for i = 1,4 do
    PART.ID = "default_spin_b_" .. i
    TARDIS:AddPart(PART)
end

local PART = {}
PART.ID = "default_spin_big"
PART.Model = "models/cem/toyota_contr/spin_big.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_spin_crank"
PART.Model = "models/cem/toyota_contr/spin_crank.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_spin_switch"
PART.Model = "models/cem/toyota_contr/spin_switch.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_switch"
PART.Model = "models/cem/toyota_contr/switch.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_switch2"
PART.Model = "models/cem/toyota_contr/switch2.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_toggles"
PART.Model = "models/cem/toyota_contr/toggles.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_toggles2"
PART.Model = "models/cem/toyota_contr/toggles2.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_tumblers"
PART.Model = "models/cem/toyota_contr/tumblers.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_balls"
PART.Model = "models/cem/toyota_contr/balls.mdl"
PART.AutoSetup = true
PART.Collision = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_console_scanner"
PART.Model = "models/cem/toyota_contr/console_scanner.mdl"
PART.AutoSetup = true
PART.Collision = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_monitor"
PART.Model = "models/cem/toyota_contr/monitor.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_monitor_2012"
PART.Model = "models/cem/toyota_contr/monitor_2012.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_monitor_2015"
PART.Model = "models/cem/toyota_contr/monitor_2015.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
TARDIS:AddPart(PART)

local PART = {}
PART.Model = "models/cem/toyota_contr/cranks.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.NoStrictUse = true

PART.ID = "default_side_cranks1"
TARDIS:AddPart(PART)

PART.ID = "default_side_cranks2"
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_side_panels"
PART.Model = "models/molda/toyota_int/sidepanels.mdl"
PART.AutoSetup = true
PART.Collision = true

if SERVER then
    -- temporary fix for side panels collision
    local function TraceEyeThroughSidePanels(self, ply)
        local trace = {
            start = ply:EyePos(),
            endpos = ply:EyePos() + ( ply:GetAimVector() * ( 4096 * 8 ) ),
            filter = { ply, self },
        }
        return util.TraceLine(trace).Hit and util.TraceLine(trace).Entity
    end

    function PART:Use(ply)
        local tr_ent = TraceEyeThroughSidePanels(self, ply)
        local p1 = self.interior:GetPart("default_side_cranks1")
        local p2 = self.interior:GetPart("default_side_cranks2")

        if IsValid(tr_ent) and (tr_ent == p1 or tr_ent == p2) then
            return tr_ent:Use(ply, ply, SIMPLE_USE, 1)
        end

        TARDIS:Control(self.Control, ply, self)
    end
end

TARDIS:AddPart(PART)


local PART={}
PART.Model = "models/molda/toyota_int/side_toggle.mdl"
PART.AutoSetup = true

PART.ID = "default_side_toggles_1"
TARDIS:AddPart(PART)
PART.ID = "default_side_toggles_2"
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_intdoors"
PART.Model = "models/molda/toyota_int/intdoors.mdl"
PART.AutoSetup = true
PART.Animate = true
PART.Collision = true

if SERVER then
    function PART:Use(ply)
        self:SetCollide(self:GetOn())

        if not self:GetOn() then
            self.interior:Timer(self.ID, 5, function(int)
                self:SetOn(false)
                self:SetCollide(true)
                if self.Sound then
                    sound.Play(self.Sound, self:LocalToWorld(self.SoundPos))
                end
            end)
        else
            self.interior:CancelTimer(self.ID)
        end
    end
end

TARDIS:AddPart(PART)

PART.ID = "default_top_doors_1"
PART.Model = "models/molda/toyota_int/intdoors2.mdl"
TARDIS:AddPart(PART)

PART.ID = "default_top_doors_2"
TARDIS:AddPart(PART)