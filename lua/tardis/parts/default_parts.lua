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
PART.ID = "default_setroof"
PART.Model = "models/molda/toyota_int/setroof.mdl"
PART.AutoSetup = true
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_rings"
PART.Model = "models/molda/toyota_int/rings.mdl"
PART.AutoSetup = true
PART.Animate = true
PART.AnimateOptions = {
    Type = "travel",
    Speed = 0.075
}
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
PART.Collision = true
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
PART.Animate = true
PART.AnimateOptions = {
    Type = "travel",
    Speed = 0.5,
    ReturnAfterStop = true,
    NoPowerFreeze = true,
}
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
PART.Animate = true
PART.AnimateOptions = {
    Type = "travel",
    Speed = 0.075,
    ReturnAfterStop = false,
    NoPowerFreeze = true,
}
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_ticks"
PART.Model = "models/molda/toyota_int/ticks.mdl"
PART.AutoSetup = true
PART.ShouldTakeDamage = false
PART.Animate = true
PART.AnimateOptions = {
    Type = "idle",
    Speed = 0.5,
    NoPowerFreeze = true,
}
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_gears1"
PART.Model = "models/molda/toyota_int/gears1.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.ShouldTakeDamage = false

PART.Animate = true
PART.AnimateOptions = {
    Type = "perpetual_use",
    Speed = 1.2,
    StopAnywhere = true,
    SpeedOverrideFunc = function(a, target, do_reset)
        if do_reset and (a.pos < 0.2 or a.pos > 0.8) then
            return a.speed * 3
        end
        return a.speed
    end,
}

if CLIENT then
    PART.Use = function(self, ply)
        self.animation.stop_anywhere = LocalPlayer():KeyDown(IN_WALK)
    end
end

TARDIS:AddPart(PART)

PART.ID = "default_gears2"
PART.Model = "models/molda/toyota_int/gears2.mdl"
PART.AnimateOptions.Speed = 1.5
TARDIS:AddPart(PART)

PART.ID = "default_gears3"
PART.Model = "models/molda/toyota_int/gears3.mdl"
PART.AnimateOptions.Speed = 0.9
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_handbrake"
PART.Model = "models/molda/toyota_int/handbrake.mdl"
PART.SoundOn = "p00gie/tardis/default/handbrake_on.ogg"
PART.SoundOff = "p00gie/tardis/default/handbrake_off.ogg"
PART.AutoSetup = true
PART.Collision = true
PART.ShouldTakeDamage = false

PART.EnabledOnStart = true

PART.Animate = true
PART.AnimateOptions = {
    Type = "toggle",
    Speed = 1.2,
}

if CLIENT then

    function trace_height(int, ply)
        local trace = {
            start = ply:EyePos(),
            endpos = ply:EyePos() + (ply:GetAimVector() * 4096),
            filter = { ply, },
        }
        if util.TraceLine(trace).Hit then
            return int:WorldToLocal(util.TraceLine(trace).HitPos).z
        end
    end

    function PART:Use(ply)
        if not self:GetOn() then return end

        if LocalPlayer():KeyDown(IN_WALK) then
            -- giving the player some control over the height
            local h = trace_height(self.interior, ply) - 132
            self.animation.max = math.Clamp(0.4 + h * 0.16, 0.4, 1)
        else
            self.animation.max = math.Rand(0.5, 1)
        end
    end
end

TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_throttle"
PART.Model = "models/molda/toyota_int/throttle.mdl"
PART.SoundOn = "p00gie/tardis/default/throttle_on.ogg"
PART.SoundOff = "p00gie/tardis/default/throttle_off.ogg"
PART.AutoSetup = true
PART.Collision = true
PART.ShouldTakeDamage = false
PART.Animate = true
PART.AnimateSpeed = 2.3
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_keyboard"
PART.Model = "models/molda/toyota_int/keyboard.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.ShouldTakeDamage = false
PART.SoundOn = "p00gie/tardis/default/keyboard_2014.ogg"
PART.SoundOff = "p00gie/tardis/default/keyboard_2015.ogg"
PART.SoundNoPower = "p00gie/tardis/default/keyboard.ogg"

if SERVER then
	function PART:Use(ply)
		self.interior:Timer("default_keyboard", 1, function()
			TARDIS:Control(self.Control, ply)
		end)
	end
end

TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_telepathic"
PART.Model = "models/molda/toyota_int/telepathic.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.ShouldTakeDamage = false
PART.Sound = "p00gie/tardis/default/telepathic.ogg"

function PART:Use(ply)
    local last_d_exit = ply:GetTardisData("destination_last_exit")

    if last_d_exit and self.Control == "destination" and CurTime() - last_d_exit < 1 then return end

    if CLIENT then
        self:SetData("default_telepathic_activation", RealTime() + 1)
    end

    self.interior:Timer("default_telepathic", 1, function()
        if SERVER then
            TARDIS:Control(self.Control, ply)
        else
            self:SetData("default_telepathic_activation", nil)
        end
    end)
end

TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_side_lever1"
PART.Model = "models/molda/toyota_int/sidelever1.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.ShouldTakeDamage = false
PART.Animate = true
PART.AnimateSpeed = 4
PART.SoundOn = "p00gie/tardis/default/slider_2_on.ogg"
PART.SoundOff = "p00gie/tardis/default/slider_off.ogg"
PART.SoundNoPower = "p00gie/tardis/default/slider_off.ogg"
TARDIS:AddPart(PART)

local PART={}
PART.ID = "default_side_lever2"
PART.Model = "models/molda/toyota_int/sidelever2.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.ShouldTakeDamage = false
PART.Animate = true
PART.AnimateSpeed = 4
PART.SoundOn = "p00gie/tardis/default/slider_on.ogg"
PART.SoundOff = "p00gie/tardis/default/slider_off.ogg"
PART.SoundNoPower = "p00gie/tardis/default/slider_off.ogg"
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
PART.AnimateSpeed = 4
PART.Sound = "p00gie/tardis/default/levers.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.Model = "models/cem/toyota_contr/button.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 6

PART.ID = "default_button_1"
PART.Sound = "p00gie/tardis/default/buttons.ogg"
PART.AnimateSpeed = 6
TARDIS:AddPart(PART)

PART.ID = "default_button_2"
PART.Sound = "p00gie/tardis/default/buttons.ogg"
PART.AnimateSpeed = 6
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_buttons"
PART.Model = "models/cem/toyota_contr/buttons.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 1
PART.SoundOn = "p00gie/tardis/default/buttons_on.ogg"
PART.SoundOff = "p00gie/tardis/default/buttons.ogg"
PART.SoundNoPower = "p00gie/tardis/default/buttons.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_crank"
PART.Model = "models/cem/toyota_contr/crank.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

PART.AnimateOptions = {
    Type = "perpetual_use",
    Speed = 1.2,
    StopAnywhere = true,
}

TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_crank2"
PART.Model = "models/cem/toyota_contr/crank2.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true

PART.AnimateOptions = {
    Type = "perpetual_use",
    Speed = 1,
    StopAnywhere = false,
}

TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_crank3"
PART.Model = "models/cem/toyota_contr/crank3.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 0.75
PART.Sound = "p00gie/tardis/default/crank.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_crank4"
PART.Model = "models/cem/toyota_contr/crank4.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "p00gie/tardis/default/crank2.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_crank5"
PART.Model = "models/cem/toyota_contr/crank5.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "p00gie/tardis/default/crank.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_crank6"
PART.Model = "models/cem/toyota_contr/crank6.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "p00gie/tardis/default/crank.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_ducks"
PART.Model = "models/cem/toyota_contr/ducks.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.SoundOn = "p00gie/tardis/default/ducks_on.ogg"
PART.SoundOff = "p00gie/tardis/default/ducks_off.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_flippers"
PART.Model = "models/cem/toyota_contr/flippers.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 1
PART.Sound = "p00gie/tardis/default/flippers.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_fiddle1"
PART.Model = "models/cem/toyota_contr/fiddle1.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 3
PART.Sound = "p00gie/tardis/default/levers.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_fiddle2"
PART.Model = "models/cem/toyota_contr/fiddle2.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 3
PART.Sound = "p00gie/tardis/default/levers.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.Model = "models/cem/toyota_contr/flat_switch.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 5
PART.Sound = "p00gie/tardis/default/switch.ogg"

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
PART.AnimateSpeed = 5
PART.Sound = "p00gie/tardis/default/levers.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_handle2"
PART.Model = "models/cem/toyota_contr/handle2.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 5
PART.Sound = "p00gie/tardis/default/levers.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_key"
PART.Model = "models/cem/toyota_contr/key.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 8
PART.SoundOn = "p00gie/tardis/default/key.ogg"
PART.SoundOff = "p00gie/tardis/default/buttons.ogg"
PART.SoundNoPower = "p00gie/tardis/default/buttons.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.Model = "models/cem/toyota_contr/red_lever.mdl"
PART.SoundOn = "p00gie/tardis/default/red_lever_on.ogg"
PART.SoundOff = "p00gie/tardis/default/red_lever_off.ogg"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 3

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
PART.AnimateSpeed = 5
PART.Sound = "p00gie/tardis/default/lever5.ogg"
TARDIS:AddPart(PART)

for i = 1,5 do
    local PART = {}
    PART.ID = "default_colored_lever_" .. i
    PART.Model = "models/cem/toyota_contr/colored_lever_" .. i .. ".mdl"

    PART.SoundOn = "p00gie/tardis/default/colored_lever_" .. i .. ".ogg"
    PART.SoundOff = "p00gie/tardis/default/colored_lever_off.ogg"
    PART.SoundOnNoPower = "p00gie/tardis/default/colored_lever_1.ogg"
    PART.SoundOffNoPower = "p00gie/tardis/default/colored_lever_off.ogg"

    PART.AutoSetup = true
    PART.Collision = true
    PART.Animate = true
    PART.AnimateSpeed = 3

    TARDIS:AddPart(PART)
end

local PART = {}
PART.ID = "default_phone"
PART.Model = "models/cem/toyota_contr/phone.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "p00gie/tardis/default/phone.ogg"
PART.SoundNoPower = false
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_red_flick_cover"
PART.Model = "models/cem/toyota_contr/red_flick_cover.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "p00gie/tardis/default/levers.ogg"
if SERVER then
	function PART:Use(ply)
		if not self:GetOn() then
			self:SetCollide(false, true)
		end
	end
end
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_red_flick_switch"
PART.Model = "models/cem/toyota_contr/red_flick_switch.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 6
PART.Sound = "p00gie/tardis/default/switch.ogg"
if SERVER then
	function PART:Use(ply)
		local cover = self.interior:GetPart("default_red_flick_cover")
		if not IsValid(cover) then return end

		if cover:GetOn() then
			TARDIS:Control(self.Control, ply)
			self.interior:Timer("default_redflickswitch_cover", 0.3, function()
				cover:SetOn(false)
				cover:SetPoseParameter("switch", 0)
				cover:SetCollide(true)
			end)
		end
	end
end
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_sliders"
PART.Model = "models/cem/toyota_contr/sliders.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.SoundOn = "p00gie/tardis/default/sliders.ogg"
PART.SoundOff = "p00gie/tardis/default/sliders_off.ogg"
PART.AnimateSpeed = 1
PART.SoundNoPower = "p00gie/tardis/default/sliders_off.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.Model = "models/cem/toyota_contr/small_switch.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 4
PART.Sound = "p00gie/tardis/default/switch.ogg"

for i = 1,18 do
    PART.ID = "default_small_switch_" .. i
    TARDIS:AddPart(PART)
end

local PART = {}
PART.Model = "models/cem/toyota_contr/spin_a.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 2
PART.Sound = "p00gie/tardis/default/switch2.ogg"

for i = 1,5 do
    PART.ID = "default_spin_a_" .. i
    TARDIS:AddPart(PART)
end

local PART = {}
PART.Model = "models/cem/toyota_contr/spin_b.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 2
PART.Sound = "p00gie/tardis/default/switch2.ogg"

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
PART.Sound = "p00gie/tardis/default/crank2.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_spin_crank"
PART.Model = "models/cem/toyota_contr/spin_crank.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "p00gie/tardis/default/crank2.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_spin_switch"
PART.Model = "models/cem/toyota_contr/spin_switch.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "p00gie/tardis/default/crank2.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_switch"
PART.Model = "models/cem/toyota_contr/switch.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.SoundOn = "p00gie/tardis/default/switch_on.ogg"
PART.SoundOff = "p00gie/tardis/default/switch.ogg"
PART.SoundNoPower = "p00gie/tardis/default/switch.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_switch2"
PART.Model = "models/cem/toyota_contr/switch2.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.Sound = "p00gie/tardis/default/switch.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_toggles"
PART.Model = "models/cem/toyota_contr/toggles.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 2
PART.SoundOn = "p00gie/tardis/default/toggles_on.ogg"
PART.SoundOff = "p00gie/tardis/default/toggles_off.ogg"
PART.SoundNoPower = "p00gie/tardis/default/toggles.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_toggles2"
PART.Model = "models/cem/toyota_contr/toggles2.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 1.5
PART.SoundOn = "p00gie/tardis/default/toggles2.ogg"
PART.SoundOff = "p00gie/tardis/default/toggles2_off.ogg"
PART.SoundNoPower = "p00gie/tardis/default/toggles2_off.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_tumblers"
PART.Model = "models/cem/toyota_contr/tumblers.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Animate = true
PART.AnimateSpeed = 3
PART.SoundOn = "p00gie/tardis/default/tumblers_on.ogg"
PART.SoundOff = "p00gie/tardis/default/tumblers_off.ogg"
PART.SoundNoPower = "p00gie/tardis/default/tumblers_off.ogg"
TARDIS:AddPart(PART)

local PART = {}
PART.ID = "default_balls"
PART.Model = "models/cem/toyota_contr/balls.mdl"
PART.AutoSetup = true
PART.Collision = true
PART.Sound = "p00gie/tardis/default/balls.ogg"
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
PART.AnimateSpeed = 1.6
PART.Sound = "p00gie/tardis/default/crank.ogg"
TARDIS:AddPart(PART)

PART.ID = "default_side_cranks2"
PART.AnimateSpeed = 0.6
PART.Sound = "p00gie/tardis/default/cranks.ogg"
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
            endpos = ply:EyePos() + ( ply:GetAimVector() * 4096 ),
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
PART.AnimateSpeed = 1
PART.Sound = "p00gie/tardis/default/intdoors_open.ogg"

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
PART.SoundOn = "p00gie/tardis/default/topdoor_open.ogg"
PART.SoundOff = "p00gie/tardis/default/topdoor_close.ogg"
PART.AnimateSpeed = 2.5
TARDIS:AddPart(PART)

PART.ID = "default_top_doors_2"
PART.SoundOn = "p00gie/tardis/default/topdoor_open.ogg"
PART.SoundOff = "p00gie/tardis/default/topdoor_close.ogg"
PART.AnimateSpeed = 2.5
TARDIS:AddPart(PART)