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
    ["Settings.Sections.Performance"] = "Performance",
    ["Settings.Sections.Exterior"] = "Exterior",
    ["Settings.Sections.AdminOptions"] = "Admin Options",
    ["Settings.Sections.Misc"] = "Misc",
    ["Settings.Sections.SoundsAndMusic"] = "Sounds & Music",
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
}

TARDIS:AddLanguage(T)