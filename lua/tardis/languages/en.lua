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
}

TARDIS:AddLanguage(T)