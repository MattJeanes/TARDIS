-- Localization

TARDIS.Languages = TARDIS.Languages or {}
TARDIS.DefaultLanguage = "en"

function TARDIS:GetPhrase(phrase, ...)
    if not phrase then
        return ""
    end
    local str = self:GetPhraseInternal(phrase)
    if not str then
        return phrase
    end
    if not ... then
        return str
    end
    local args = {...}
    for k,v in ipairs(args) do
        args[k] = self:GetPhraseInternal(v) or v
    end
    return string.format(str, unpack(args))
end

function TARDIS:PhraseExists(phrase)
    return self:GetPhraseInternal(phrase) ~= nil
end

function TARDIS:GetPhraseIfExists(phrase, ...)
    if not phrase then
        return nil
    end
    local str = self:GetPhraseInternal(phrase)
    if not str then
        return nil
    end
    if not ... then
        return str
    end
    return string.format(str, ...)
end

function TARDIS:GetPhraseInternal(phrase)
    local lang = self:GetLanguage()
    local str = lang.Phrases[phrase]
    if str then
        return str
    else
        while lang.Base do
            local baseLang = lang.Base
            lang = self.Languages[baseLang]
            if not lang then
                return nil
            end
            str = lang.Phrases[phrase]
            if str then
                return str
            end
        end
    end
end

function TARDIS:AddLanguage(t)
    if not (t.Code and t.Phrases) then
        error("TARDIS:AddLanguage: Invalid language table")
    end
    if not self.Languages[t.Code] then
        self.Languages[t.Code] = {}
    end
    local lang = self.Languages[t.Code]
    if t.Name then
        lang.Name = t.Name
    elseif not lang.Name then
        error("TARDIS:AddLanguage: Language name required")
    end
    if t.Code ~= self.DefaultLanguage then
        lang.Base = t.Base or self.DefaultLanguage
    end
    if lang.Phrases then
        for k, v in pairs(t.Phrases) do
            lang.Phrases[k] = v
        end
    else
        lang.Phrases = t.Phrases
    end
end

function TARDIS:GetLanguage()
    local lang = cvars.String("gmod_language", "en")
    local lang_table = self.Languages[lang]
    if lang_table then
        return lang_table
    else
        return self.Languages[self.DefaultLanguage]
    end
end

TARDIS:LoadFolder("languages", false, true)
