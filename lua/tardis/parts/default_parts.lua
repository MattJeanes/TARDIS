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
PART.ID = "default_side_panels"
PART.Model = "models/molda/toyota_int/sidepanels.mdl"
PART.AutoSetup = true
PART.Collision = true
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