-- English

local T = {}
T.Code = "en"
T.Name = "English"
T.Phrases = {
    ["Common.Error"] = "ERROR",

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
}

TARDIS:AddLanguage(T)