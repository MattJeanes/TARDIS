-- Test

local T = {}
T.Code = "en-test"
T.Extends = "en"
T.Phrases = {
    ["Common.NewPhrase"] = "new phrase"
}

TARDIS:AddLanguageExtension(T)