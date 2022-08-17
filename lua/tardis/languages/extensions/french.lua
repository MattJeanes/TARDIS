-- Test

local T = {}
T.Code = "fr-test"
T.Extends = "fr"
T.Phrases = {
    ["Common.NewPhrase"] = "new phrase oui oui",
    ["Common.Dumb"] = "new phrase oui oui"
}

TARDIS:AddLanguageExtension(T)

-- Test

local T = {}
T.Code = "fr-test-enhanced"
T.Extends = "fr-ENHANCED"
T.Phrases = {
    ["Common.NewPhrase"] = "new phrase oui oui ENHANCED"
}

TARDIS:AddLanguageExtension(T)