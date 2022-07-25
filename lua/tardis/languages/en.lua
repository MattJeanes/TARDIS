-- English

local T = {}
T.Code = "en"
T.Name = "English"
T.Phrases = {
    ["Common.Error"] = "ERROR",
    ["Common.TARDIS"] = "TARDIS",
    ["Common.Interface"] = "TARDIS Interface",
    ["Common.OK"] = "OK",
    ["Common.Cancel"] = "Cancel",
    ["Common.Save"] = "Save",
    ["Common.Reset"] = "Reset",
    ["Common.Default"] = "Default",
    ["Common.PowerDisabled"] = "Power is disabled",
    ["Common.Enabled.Lower"] = "enabled",
    ["Common.Disabled.Lower"] = "disabled",
    ["Common.Opened.Lower"] = "opened",
    ["Common.Closed.Lower"] = "closed",
    ["Common.Locked.Lower"] = "locked",
    ["Common.Unlocked.Lower"] = "unlocked",
    ["Common.Engaged.Lower"] = "engaged",
    ["Common.Disengaged.Lower"] = "disengaged",
    ["Common.NotYetImplemented"] = "This hasn't been implemented yet",

    ["Templates.MissingTemplate"] = "Failed to find template %s required for interior %s",

    ["Destination.LockedReadyToMat"] = "Destination locked, ready to materialise",
    ["Destination.FailedSetDestinationMaybeTransitioning"] = "Failed to set destination, may be transitioning",
    ["Destination.LockedDemat"] = "Destination locked, dematerialising...",
    ["Destination.FailedDemat"] = "Failed to dematerialise",
    ["Destination.LockedReadyToDemat"] = "Destination locked, ready to dematerialise",
    ["Destination.FailedSetDestination"] = "Failed to set destination",

    ["Flight.WarnPhyslockEngaged"] = "WARNING: Physical lock engaged",
    ["Flight.NameIsThePilot"] = "%s is the pilot",
    ["Flight.NameIsNowThePilot"] = "%s is now the pilot",
    ["Flight.YouAreNowThePilot"] = "You are now the pilot",
    ["Flight.NoLongerPilot"] = "You are no longer the pilot",

    ["HADS.Triggered"] = "H.A.D.S. has been triggered!",
    ["HADS.UnderAttack"] = "Your TARDIS is under attack!",
    ["HADS.DematError"] = "Something stopped H.A.D.S. from dematerialising the TARDIS!",
    ["HADS.Mat"] = "Your TARDIS is materialising",

    ["Health.RepairActivated"] = "This TARDIS has been set to self-repair. Please vacate the interior",
    ["Health.RepairCancelled"] = "Self-repair has been cancelled",
    ["Health.RepairFinished"] = "Your TARDIS has finished self-repairing",
    ["Health.Repairing"] = "This TARDIS is repairing. It will be done in %d seconds",

    ["Lock.Locked"] = "This TARDIS is locked",

    ["Music.Stopped"] = "Music stopped",
    ["Music.Playing"] = "Playing: %s",
    ["Music.Loading"] = "Loading music...",

    ["ThirdPerson.KeyHint"] = "HINT: Use '%s + %s' keys to enter third person",

    ["Vortex.ModelMissing"] = "WARNING: Vortex model invalid - disabling vortex, are you missing a dependency?",

    ["Security.PartUseDenied"] = "This TARDIS uses Isomorphic Security. You may not use any controls",

    ["Spin.Changed"] = "Spin direction set to %s",
    ["Spin.Directions.AntiClockwise"] = "anti-clockwise",
    ["Spin.Directions.None"] = "none",
    ["Spin.Directions.Clockwise"] = "clockwise",

    ["TimeDistortionGenerator.Starting"] = "Starting the time distortion generator...",
    ["TimeDistortionGenerator.Disabled"] = "Time distortion generator disabled",
    ["TimeDistortionGenerator.Enabled"] = "Time distortion generator enabled",
    ["TimeDistortionGenerator.Distortions"] = "WARNING: Something is causing time distortions inside this TARDIS",

    ["MenuOptions.SectionReset"] = "TARDIS clientside settings of section \"%s\" have been reset. You may need to respawn the TARDIS for all changes to apply",
    ["MenuOptions.ConfirmSectionReset"] = "Reset clientside settings of section \"%s\"? This cannot be undone.",
    ["MenuOptions.SectionResetThisSection"] = "Reset settings (this section)",
    ["MenuOptions.ResetAllSettings"] = "Reset All Settings",
    ["MenuOptions.ResetClientsideSettings"] = "Reset clientside settings",
    ["MenuOptions.ConfirmResetSettings"] = "Reset all clientside settings? This cannot be undone.",
    ["MenuOptions.ResetSettingsConfirmation"] = "TARDIS clientside settings have been reset. You may need to respawn the TARDIS for all changes to apply.",

    ["Settings.Sections.GUI"] = "GUI",

    ["Settings.Sections.GUI.OldGUI"] = "Use old GUI",
    ["Settings.Sections.GUI.OldGUI.Description"] = "Use the old 2D GUI with no pictures instead of the new one",
    
    ["Settings.Sections.GUI.BigPopup"] = "GUI big popup",
    ["Settings.Sections.GUI.BigPopup.Description"] = "Should the popup for new visual GUI be bigger?",
    
    ["Settings.Sections.GUI.ScreenRows"] = "GUI rows (screen)",
    ["Settings.Sections.GUI.ScreenRows.Description"] = "How many rows of buttons should the visual GUI on the screen have?",
    
    ["Settings.Sections.GUI.ScreenOverrideRows"] = "GUI override screen rows",
    ["Settings.Sections.GUI.ScreenOverrideRows.Description"] = "Should the interior settings for button rows be overridable?",
    
    ["Settings.Sections.GUI.PopupRows"] = "GUI rows (popup)",
    ["Settings.Sections.GUI.PopupRows.Description"] = "How many rows of buttons should the visual GUI in the popup have?",
    
    ["Settings.Sections.GUI.Theme"] = "GUI Theme",
    ["Settings.Sections.GUI.Theme.Description"] = "Theme for the user interface",

    ["Settings.Sections.Performance"] = "Performance",
    
    ["Settings.Sections.Performance.LightingOverride"] = "Lighting Override",
    ["Settings.Sections.Performance.LightingOverride.Description"] = "Better interior lighting independent from the map ambience.\nMay cause performance drops on lower end systems.",
    
    ["Settings.Sections.Performance.Portals"] = "Portals Enabled",
    ["Settings.Sections.Performance.Portals.Description"] = "Whether portals will render or not, turn this off if they impact framerate significantly",
    
    ["Settings.Sections.Performance.DoorCloseDistance"] = "Door Close Distance",
    ["Settings.Sections.Performance.DoorCloseDistance.Description"] = "The distance at which the door automatically closes",
    
    ["Settings.Sections.Performance.DynamicExteriorLight"] = "Dynamic Exterior Light",
    ["Settings.Sections.Performance.DynamicExteriorLight.Description"] = "Should the exterior emit dynamic lighting?",

    ["Settings.Sections.Performance.ProjectedDoorExteriorLight"] = "Projected Door Exterior Light",
    ["Settings.Sections.Performance.ProjectedDoorExteriorLight.Description"] = "Should light shine out through the doors when they're open?",

    ["Settings.Sections.Performance.BreakdownEffects"] = "Breakdown Effects",
    ["Settings.Sections.Performance.BreakdownEffects.Description"] = "Should the TARDIS have sparkling and explosion effects in emergency situations?",

    ["Settings.Sections.Exterior"] = "Exterior",

    ["Settings.Sections.Exterior.Light"] = "Exterior light",
    
    ["Settings.Sections.Exterior.Light.EnableColorOverride"] = "Enable Light Color Override",
    ["Settings.Sections.Exterior.Light.EnableColorOverride.Description"] = "Whether the override of exterior light color is enabled",

    ["Settings.Sections.Exterior.Light.ColorOverride"] = "Color Override",
    ["Settings.Sections.Exterior.Light.ColorOverride.Description"] = "The override color of the exterior light",

    ["Settings.Sections.Exterior.Light.AlwaysOn"] = "Exterior Light Always On",
    ["Settings.Sections.Exterior.Light.AlwaysOn.Description"] = "Should the exterior light always be lit?",

    ["Settings.Sections.Exterior.ProjectedLight"] = "Projected light",

    ["Settings.Sections.Exterior.ProjectedLight.EnableBrightnessOverride"] = "Enable Brightness Override",
    ["Settings.Sections.Exterior.ProjectedLight.EnableBrightnessOverride.Description"] = "Whether the override of projected light brightness is enabled",

    ["Settings.Sections.Exterior.ProjectedLight.EnableColorOverride"] = "Enable Color Override",
    ["Settings.Sections.Exterior.ProjectedLight.EnableColorOverride.Description"] = "Whether the override of projected light color is enabled",

    ["Settings.Sections.Exterior.ProjectedLight.EnableDistanceOverride"] = "Enable Distance Override",
    ["Settings.Sections.Exterior.ProjectedLight.EnableDistanceOverride.Description"] = "Whether the override of projected light distance is enabled",

    ["Settings.Sections.Exterior.ProjectedLight.BrightnessOverride"] = "Brightness Override",
    ["Settings.Sections.Exterior.ProjectedLight.BrightnessOverride.Description"] = "Override brightness of projected light",

    ["Settings.Sections.Exterior.ProjectedLight.DistanceOverride"] = "Distance Override",
    ["Settings.Sections.Exterior.ProjectedLight.DistanceOverride.Description"] = "Override distance of projected light",

    ["Settings.Sections.Exterior.ProjectedLight.ColorOverride"] = "Color Override",
    ["Settings.Sections.Exterior.ProjectedLight.ColorOverride.Description"] = "Override color of projected light",

    ["Settings.Sections.Global"] = "Admin Options",

    ["Settings.Sections.Global.EnableHealth"] = "Enable Health",
    ["Settings.Sections.Global.EnableHealth.Description"] = "Should the TARDIS have health and take damage?",

    ["Settings.Sections.Global.MaxHealth"] = "Max Health",
    ["Settings.Sections.Global.MaxHealth.Description"] = "Maximum ammount of health the TARDIS has",

    ["Settings.Sections.Global.BoostSpeed"] = "Boost Speed",
    ["Settings.Sections.Global.BoostSpeed.Description"] = "The increase of speed the TARDIS gets with the boost key enabled",

    ["Settings.Sections.Misc"] = "Misc",

    ["Settings.Sections.Misc.NotificationType"] = "Notification type",
    ["Settings.Sections.Misc.NotificationType.Description"] = "Which type of notifications is being used",
    ["Settings.Sections.Misc.NotificationType.Types.Disabled"] = "Disabled",
    ["Settings.Sections.Misc.NotificationType.Types.ConsoleLog"] = "Console log",
    ["Settings.Sections.Misc.NotificationType.Types.Chat"] = "Chat notifications",
    ["Settings.Sections.Misc.NotificationType.Types.Inbuilt"] = "In-built notifications",

    ["Settings.Sections.Misc.EnableControlSequences"] = "Enable Control Sequences",
    ["Settings.Sections.Misc.EnableControlSequences.Description"] = "Should control sequences or 'advanced mode' be used?",
    
    ["Settings.Sections.Misc.IsomorphicSecurityDefault"] = "Isomorphic Security on by default",
    ["Settings.Sections.Misc.IsomorphicSecurityDefault.Description"] = "Whether or not others can use your TARDIS' controls by default",
    
    ["Settings.Sections.Misc.Teleport"] = "Teleport",

    ["Settings.Sections.Misc.Teleport.AutoCloseDoors"] = "Auto-Close Doors at Demat",
    ["Settings.Sections.Misc.Teleport.AutoCloseDoors.Description"] = "Should TARDIS close doors automatically before demat?",

    ["Settings.Sections.Misc.Teleport.DestinationDematOnSet"] = "Destination - Demat on Set",
    ["Settings.Sections.Misc.Teleport.DestinationDematOnSet.Description"] = "Should the TARDIS dematerialise immediately after destination is set?",

    ["Settings.Sections.Misc.Teleport.ShowVortex"] = "Show Vortex",
    ["Settings.Sections.Misc.Teleport.ShowVortex.Description"] = "Whether the vortex is shown during vortex flight",
    
    ["Settings.Sections.Misc.Flight"] = "Flight",

    ["Settings.Sections.Misc.Flight.StopSpinningOpenDoor"] = "Stop spinning with opened door",
    ["Settings.Sections.Misc.Flight.StopSpinningOpenDoor.Description"] = "Should the TARDIS stop spinning when doors are opened in flight?",

    ["Settings.Sections.Misc.Flight.DisableBoostOpenDoor"] = "Disable boost with opened doors",
    ["Settings.Sections.Misc.Flight.DisableBoostOpenDoor.Description"] = "Should the TARDIS boost stop working when doors are opened in flight?",

    ["Settings.Sections.Misc.Flight.UseWalkKeyThirdPerson"] = "Use walk key to enter third person",
    ["Settings.Sections.Misc.Flight.UseWalkKeyThirdPerson.Description"] = "Should the WALK ('ALT' by default) key be pressed to enter third person when pressing USE ('E' by default) key on the console?",

    ["Settings.Sections.Misc.Tips"] = "Tips",

    ["Settings.Sections.Misc.Tips.Enabled"] = "Tips",
    ["Settings.Sections.Misc.Tips.Enabled.Description"] = "Should tips be shown for TARDIS controls?",

    ["Settings.Sections.Misc.Tips.Style"] = "Tips Style",
    ["Settings.Sections.Misc.Tips.Style.Description"] = "Which style should the TARDIS tips use?",

    ["Settings.Sections.Misc.Spawning"] = "Spawning the TARDIS",

    ["Settings.Sections.Misc.Spawning.PreferClassicDoor"] = "Prefer classic door interiors",
    ["Settings.Sections.Misc.Spawning.PreferClassicDoor.Description"] = "Whether classic (big) door versions of interiors will spawn by default",

    ["Settings.Sections.Misc.Spawning.RandomizeSkins"] = "Randomize skins",
    ["Settings.Sections.Misc.Spawning.RandomizeSkins.Description"] = "Whether or not TARDIS skin will be randomized when it's spawned",

    ["Settings.Sections.Misc.Spawning.UseWinterSkins"] = "Use winter skins",
    ["Settings.Sections.Misc.Spawning.UseWinterSkins.Description"] = "Whether or not winter TARDIS skins will be used while it's randomized",
    
    ["Settings.Sections.SoundsAndMusic"] = "Sounds & Music",

    ["Settings.Sections.SoundsAndMusic.Sounds"] = "Sounds",

    ["Settings.Sections.SoundsAndMusic.Sounds.All"] = "All Sounds",
    ["Settings.Sections.SoundsAndMusic.Sounds.All.Description"] = "Lets you easily mute all sounds",

    ["Settings.Sections.SoundsAndMusic.Sounds.ExternalHum"] = "External Hum",
    ["Settings.Sections.SoundsAndMusic.Sounds.ExternalHum.Description"] = "Whether the hum on the outside of the TARDIS can be heard if it exists",

    ["Settings.Sections.SoundsAndMusic.Sounds.Cloak"] = "Cloak Sound",
    ["Settings.Sections.SoundsAndMusic.Sounds.Cloak.Description"] = "Whether or not sounds play when TARDIS cloaking is toggled",

    ["Settings.Sections.SoundsAndMusic.Sounds.Door"] = "Door Sound",
    ["Settings.Sections.SoundsAndMusic.Sounds.Door.Description"] = "Whether a sound is made when toggling the door or not",

    ["Settings.Sections.SoundsAndMusic.Sounds.FlightExternal"] = "Flightmode External Sound",
    ["Settings.Sections.SoundsAndMusic.Sounds.FlightExternal.Description"] = "Whether the flight sound can be heard on the outside or not",

    ["Settings.Sections.SoundsAndMusic.Sounds.Lock"] = "Lock Sound",
    ["Settings.Sections.SoundsAndMusic.Sounds.Lock.Description"] = "Whether a sound is made when toggling the lock or not",

    ["Settings.Sections.SoundsAndMusic.Sounds.Teleport"] = "Teleport Sound",
    ["Settings.Sections.SoundsAndMusic.Sounds.Teleport.Description"] = "Whether the teleport sounds can be heard or not",

    ["Settings.Sections.SoundsAndMusic.Sounds.CloisterBells"] = "Cloister bells",
    ["Settings.Sections.SoundsAndMusic.Sounds.CloisterBells.Description"] = "Whether the warning bells can be heard on the interior or not",

    ["Settings.Sections.SoundsAndMusic.Sounds.FlightInternal"] = "Flightmode Internal Sound",
    ["Settings.Sections.SoundsAndMusic.Sounds.FlightInternal.Description"] = "Whether the flight sound can be heard on the inside or not",

    ["Settings.Sections.SoundsAndMusic.Sounds.Idle"] = "Idle Sounds",
    ["Settings.Sections.SoundsAndMusic.Sounds.Idle.Description"] = "Whether the idle sounds can be heard on the inside or not",

    ["Settings.Sections.SoundsAndMusic.Music"] = "Music",

    ["Settings.Sections.SoundsAndMusic.Music.Enabled"] = "Enabled",
    ["Settings.Sections.SoundsAndMusic.Music.Enabled.Description"] = "Whether music is played through the screens or not",

    ["Settings.Sections.SoundsAndMusic.Music.Volume"] = "Volume",
    ["Settings.Sections.SoundsAndMusic.Music.Volume.Description"] = "The volume of the music played through the screens",

    ["Settings.Sections.SoundsAndMusic.Music.StopOnExit"] = "Stop on exit",
    ["Settings.Sections.SoundsAndMusic.Music.StopOnExit.Description"] = "Whether music is stopped when leaving the TARDIS",

    ["Settings.Sections.Binds"] = "Binds",

    ["Settings.Sections.Other"] = "Other",

    ["Binds.Key"] = "Key",
    ["Binds.Invalid"] = "Invalid",
    ["Binds.AnyKey"] = "Press any key",

    ["Binds.Sections.ThirdPerson"] = "Third Person",
    ["Binds.Sections.ThirdPerson.ToggleCloak"] = "Toggle Cloak",
    ["Binds.Sections.ThirdPerson.Destination"] = "Destination",
    ["Binds.Sections.ThirdPerson.Destination.Description"] = "Enter destination select state",
    ["Binds.Sections.ThirdPerson.ToggleFlight"] = "Toggle Flight",
    ["Binds.Sections.ThirdPerson.ToggleFloat"] = "Toggle Float",
    ["Binds.Sections.ThirdPerson.ToggleFloat.Description"] = "Lets the TARDIS fly as if there is no gravity",
    ["Binds.Sections.ThirdPerson.TogglePhyslock"] = "Toggle Physlock",
    ["Binds.Sections.ThirdPerson.TogglePhyslock.Description"] = "Make the TARDIS constant and unmovable in space",
    ["Binds.Sections.ThirdPerson.ToggleDoor"] = "Toggle Door",
    ["Binds.Sections.ThirdPerson.OpenScreen"] = "Open Screen",
    ["Binds.Sections.ThirdPerson.OpenScreen.Description"] = "Toggles the HUD screen",

    ["Binds.Sections.Destination"] = "Destination",
    ["Binds.Sections.Destination.Forward"] = "Forward",
    ["Binds.Sections.Destination.Backward"] = "Backward",
    ["Binds.Sections.Destination.Left"] = "Left",
    ["Binds.Sections.Destination.Right"] = "Right",
    ["Binds.Sections.Destination.Up"] = "Up",
    ["Binds.Sections.Destination.Down"] = "Down",
    ["Binds.Sections.Destination.Boost"] = "Boost",
    ["Binds.Sections.Destination.Boost.Description"] = "Hold this key while navigating to speed up",
    ["Binds.Sections.Destination.Slow"] = "Slow",
    ["Binds.Sections.Destination.Slow.Description"] = "Hold this key to slow movement",
    ["Binds.Sections.Destination.Rotate"] = "Rotate",
    ["Binds.Sections.Destination.Rotate.Description"] = "Hold this with the boost and left or right keys to rotate",
    ["Binds.Sections.Destination.SnapToFloor"] = "Snap To Floor",
    ["Binds.Sections.Destination.SnapToFloor.Description"] = "Press this key to snap to the nearest floor",
    
    ["Binds.Sections.Flight"] = "Flight",
    ["Binds.Sections.Flight.Forward"] = "Forward",
    ["Binds.Sections.Flight.Backward"] = "Backward",
    ["Binds.Sections.Flight.Left"] = "Left",
    ["Binds.Sections.Flight.Right"] = "Right",
    ["Binds.Sections.Flight.Up"] = "Up",
    ["Binds.Sections.Flight.Down"] = "Down",
    ["Binds.Sections.Flight.Boost"] = "Boost",
    ["Binds.Sections.Flight.Boost.Description"] = "Hold this key while flying to speed up",
    ["Binds.Sections.Flight.Rotate"] = "Rotate",
    ["Binds.Sections.Flight.Rotate.Description"] = "Hold this key while using left and right to rotate",
    ["Binds.Sections.Flight.SpinDirection"] = "Spin Direction",
    ["Binds.Sections.Flight.SpinDirection.Description"] = "Changes which way the TARDIS rotates while flying",
    
    ["Binds.Sections.Float"] = "Float",
    ["Binds.Sections.Float.Forward"] = "Forward",
    ["Binds.Sections.Float.Backward"] = "Backward",
    ["Binds.Sections.Float.Left"] = "Left",
    ["Binds.Sections.Float.Right"] = "Right",
    ["Binds.Sections.Float.Boost"] = "Boost",
    ["Binds.Sections.Float.Boost.Description"] = "Hold this key while floating to speed up rotation",
    ["Binds.Sections.Float.Rotate"] = "Rotate",
    ["Binds.Sections.Float.Rotate.Description"] = "Hold this key while using left and right to rotate on yaw axis",
    ["Binds.Sections.Float.Brake"] = "Brake",
    ["Binds.Sections.Float.Brake.Description"] = "Hold this key to slow rotation in float mode",
    
    ["Binds.Sections.Teleport"] = "Teleport",
    ["Binds.Sections.Teleport.Demat"] = "Demat",
    ["Binds.Sections.Teleport.Mat"] = "Mat",
    ["Binds.Sections.Teleport.Set"] = "Set",

    ["Controls.Cloak"] = "Cloak",
    ["Controls.Cloak.Tip"] = "Cloaking Device",
    ["Controls.Cloak.Status"] = "Cloak",
    ["Controls.Cloak.FailedToggle"] = "Failed to toggle cloaking",

    ["Controls.Coordinates.Tip"] = "Coordinates",

    ["Controls.Destination"] = "Destination",
    ["Controls.Destination.Tip"] = "Destination Select",

    ["Controls.Door"] = "Door",
    ["Controls.Door.Tip"] = "Door Switch",
    ["Controls.Door.Status"] = "Door",
    ["Controls.Door.UsingEmergencyPower"] = "Using emergency power to open the door...",
    ["Controls.Door.NoSwitch"] = "The door switch doesn't work",
    ["Controls.Door.FailedOpen"] = "Failed to open door",
    ["Controls.Door.FailedClose"] = "Failed to close door",
    ["Controls.Door.Locked"] = "The doors are locked",

    ["Controls.DoorLock"] = "Door Lock",
    ["Controls.DoorLock.Tip"] = "Door Lock",
    ["Controls.DoorLock.NotWorking"] = "The door lock doesn't work",
    ["Controls.DoorLock.UsingEmergencyPower"] = "Using emergency power to disengage the lock...",
    ["Controls.DoorLock.FailedToggle"] = "Failed to toggle door lock",

    ["Controls.EngineRelease"] = "Engine Release",
    ["Controls.EngineRelease.Tip"] = "Engine Release",
    ["Controls.EngineRelease.ForceDemat"] = "Force dematerialisation triggered",
    ["Controls.EngineRelease.FailedDemat"] = "Failed to dematerialise",

    ["Controls.FastReturn"] = "Fast Return",
    ["Controls.FastReturn.Tip"] = "Fast Return Protocol",
    ["Controls.FastReturn.Activated"] = "Fast-return protocol initiated",
    ["Controls.FastReturn.Failed"] = "Failed to initiate fast-return protocol",

    ["Controls.Flight"] = "Flight Mode",
    ["Controls.Flight.Tip"] = "Flight Mode",
    ["Controls.Flight.Status"] = "Flight mode",
    ["Controls.Flight.FailedToggle"] = "Failed to toggle flight mode",

    ["Controls.Float"] = "Anti-Gravs",
    ["Controls.Float.Tip"] = "Anti-Gravs",
    ["Controls.Float.Status"] = "Anti-gravs",
    ["Controls.Float.FailedToggle"] = "Failed to toggle anti-gravs",

    ["Controls.HADS"] = "H.A.D.S.",
    ["Controls.HADS.Tip"] = "H.A.D.S.",
    ["Controls.HADS.Status"] = "Hostile Action Displacement System",

    ["Controls.Handbrake"] = "Time Rotor Handbrake",
    ["Controls.Handbrake.Tip"] = "Time Rotor Handbrake",
    ["Controls.Handbrake.Status"] = "Time Rotor Handbrake",
    ["Controls.Handbrake.FailedToggle"] = "Failed to toggle the Time Rotor Handbrake",

    ["Controls.InteriorLights.Tip"] = "Lights",

    ["Controls.Isomorphic"] = "Isomorphic Security",
    ["Controls.Isomorphic.Tip"] = "Isomorphic Security System",
    ["Controls.Isomorphic.Status"] = "Isomorphic security",
    ["Controls.Isomorphic.FailedToggle"] = "Failed to toggle isomorphic security",
    ["Controls.Isomorphic.NotCreator"] = "This is not your TARDIS",
    ["Controls.Isomorphic.SingleplayerWarning"] = "WARNING: Isomorphic security has no use in singleplayer",

    ["Controls.Music.Tip"] = "Music",

    ["Controls.Physlock"] = "Physlock",
    ["Controls.Physlock.Tip"] = "Locking-Down Mechanism",
    ["Controls.Physlock.Status"] = "Locking-down mechanism",
    ["Controls.Physlock.FailedToggle"] = "Failed to toggle locking-down mechanism",

    ["Controls.Power"] = "Power",
    ["Controls.Power.Tip"] = "Power Switch",
    ["Controls.Power.Status"] = "Power",
    ["Controls.Power.FailedToggle"] = "Failed to toggle power",

    ["Controls.RandomCoords.Tip"] = "Random Destination",
    ["Controls.RandomCoords.Selected"] = "Random destination has been selected",
    
    ["Controls.Redecorate"] = "Redecoration",
    ["Controls.Redecorate.Tip"] = "Redecoration",
    ["Controls.Redecorate.Status"] = "Redecoration",
    ["Controls.Redecorate.FailedToggle"] = "Failed to toggle redecoration",
    ["Controls.Redecorate.RandomInteriorWarning"] = "WARNING: New interior has been selected randomly. Right click in spawnmenu to choose",
    ["Controls.Redecorate.NotCreator"] = "You cannot redecorate someone else's TARDIS",

    ["Controls.Repair"] = "Self-Repair",
    ["Controls.Repair.Tip"] = "Self-Repair",
    ["Controls.Repair.FailedToggle"] = "Failed to toggle self-repair",

    ["Controls.Scanner.Tip"] = "Scanner",

    ["Controls.Shields.Tip"] = "Shields",

    ["Controls.SonicDispenser.Tip"] = "Sonic Charger",
    ["Controls.SonicDispenser.MissingAddon"] = "You do not have the Sonic Screwdriver addon installed. Install it for this part to work",
    ["Controls.SonicDispenser.Dispensed"] = "Sonic Screwdriver has been dispensed",
    ["Controls.SonicDispenser.Equipped"] = "Sonic Screwdriver has been equipped",
    ["Controls.SonicDispenser.AlreadyEquipped"] = "You are already holding a Sonic Screwdriver",

    ["Controls.SpinCycle"] = "Spin direction",
    ["Controls.SpinCycle.Tip"] = "Spin",

    ["Controls.SpinSwitch.Tip"] = "Spin direction",
    ["Controls.SpinSwitch.ChangedDisabled"] = "Spin is disabled, but spin direction set to %s",

    ["Controls.SpinToggle.Tip"] = "Toggle spin",
    ["Controls.SpinToggle.Status"] = "Spin",

    ["Controls.Stabilizers.Tip"] = "Flight stabilizers",

    ["Controls.Teleport"] = "Teleport",
    ["Controls.Teleport.Tip"] = "Space-Time Throttle",
    ["Controls.Teleport.Mat"] = "Materialising",
    ["Controls.Teleport.FailedMat"] = "Failed to materialise",
    ["Controls.Teleport.Demat"] = "Dematerialising",
    ["Controls.Teleport.FailedDematDoorsOpen"] = "Can't dematerialise while doors are open",
    ["Controls.Teleport.FailedDematHandbrake"] = "Time Rotor Handbrake is engaged! Cannot dematerialise",
    ["Controls.Teleport.FailedDemat"] = "Failed to dematerialise",

    ["Controls.ThirdPersonCareful.Tip"] = "Manual Flight Control",

    ["Controls.ThirdPerson"] = "Flight Control",
    ["Controls.ThirdPerson.Tip"] = "Manual Flight Control",

    ["Controls.ToggleScreens"] = "Toggle Screen",
    ["Controls.ToggleScreens.Tip"] = "Toggle Screen",
    ["Controls.ToggleScreens.Status"] = "Interior screens",
    ["Controls.ToggleScreens.FailedToggle"] = "Failed to toggle interior screens",

    ["Controls.VirtualConsole.Tip"] = "Virtual Console",

    ["Controls.VortexFlight"] = "Vortex Flight",
    ["Controls.VortexFlight.Tip"] = "Vortex Flight",
    ["Controls.VortexFlight.Status"] = "Vortex flight",
    ["Controls.VortexFlight.FailedToggle"] = "Failed to toggle vortex flight",

    ["Themes.Default"] = "Default",
    ["Themes.Transparent"] = "Transparent",
    ["Themes.TextOnly"] = "Text only",

    ["TipStyles.Default"] = "Default (set by interior)",
    ["TipStyles.Classic"] = "Classic (legacy)",
    ["TipStyles.WhiteOnBlue"] = "White on blue",
    ["TipStyles.WhiteOnGrey"] = "White on grey",
}

TARDIS:AddLanguage(T)