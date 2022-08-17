-- Localization
TARDIS.Languages = TARDIS.Languages or {}
TARDIS.LanguageExtensions = TARDIS.LanguageExtensions or {}
TARDIS.LanguageCache = TARDIS.LanguageCache or {}
TARDIS.CurrentLanguage = TARDIS.CurrentLanguage
TARDIS.DefaultLanguage = "en"

function TARDIS:GetPhrase(phrase, ...)
    if not phrase then
        return ""
    end
    local str = self.LanguageCache[self.CurrentLanguage][phrase]
    if not str then
        return phrase
    end
    if not ... then
        return str
    end
    local args = {...}
    for k, v in ipairs(args) do
        args[k] = self.LanguageCache[self.CurrentLanguage][v] or v
    end
    return string.format(str, unpack(args))
end

function TARDIS:PhraseExists(phrase)
    return self.LanguageCache[self.CurrentLanguage][phrase] ~= nil
end

function TARDIS:GetPhraseIfExists(phrase, ...)
    if not phrase then
        return nil
    end
    local str = self.LanguageCache[self.CurrentLanguage][phrase]
    if not str then
        return nil
    end
    if not ... then
        return str
    end
    return string.format(str, ...)
end

function TARDIS:AddLanguage(t)
    if not (t.Code and t.Phrases and t.Name) then
        error("TARDIS:AddLanguage: Invalid language configuration")
    end
    local lang = {}
    lang.Name = t.Name
    lang.Base = t.Base
    lang.Extends = t.Extends
    lang.Phrases = t.Phrases

    self.Languages[t.Code] = lang

    self:CompileLanguage(t.Code)
    self:UpdateLanguage()
end

function TARDIS:AddLanguageExtension(t)
    if not (t.Code and t.Phrases and t.Extends) then
        error("TARDIS:AddLanguageExtension: Invalid language extension configuration")
    end

    local langExtension = {}
    langExtension.Phrases = t.Phrases

    self.LanguageExtensions[t.Extends] = self.LanguageExtensions[t.Extends] or {}
    self.LanguageExtensions[t.Extends][t.Code] = langExtension

    if self.Languages[t.Extends] then
        self:CompileLanguage(t.Extends)
    end
end

function TARDIS:CompileLanguage(code)
    local phrases = {}

    local lang = self.Languages[code]
    if not lang then
        return
    end

    for k, v in pairs(lang.Phrases) do
        phrases[k] = v
    end

    local extensions = self.LanguageExtensions[code]
    if extensions then
        for k, v in pairs(extensions) do
            for k,v in pairs(v.Phrases) do
                if phrases[k] then
                    ErrorNoHalt("Extension " .. v.Code .. " attempted to override existing language phrase " .. k)
                else
                    phrases[k] = v
                end
            end
        end
    end

    local base = lang.Base or self.DefaultLanguage
    local baseLang = self.Languages[base]
    if code ~= base then
        local basePhrases = self.LanguageCache[base]
        if basePhrases then
            for k,v in pairs(basePhrases) do
                if not phrases[k] then
                    phrases[k] = v
                end
            end
        end
    end

    self.LanguageCache[code] = phrases

    for k, v in pairs(self.Languages) do
        if k ~= code then
            local base = v.Base or self.DefaultLanguage
            local baseLang
            repeat
                baseLang = self.Languages[base]
                if base == code then
                    self:CompileLanguage(k)
                    break
                end
                base = baseLang.Base or self.DefaultLanguage
            until base == self.DefaultLanguage
        end
    end

    return phrases
end

function TARDIS:GetLanguage()
    if not TARDIS.CurrentLanguage then
        self:UpdateLanguage()
    end
    return TARDIS.CurrentLanguage
end

function TARDIS:UpdateLanguage()
    local langCode
    if SERVER then
        langCode = "default"
    else
        langCode = self:GetSetting("language")
    end

    if langCode == "default" then
        langCode = cvars.String("gmod_language", "en")
    end

    if not self.Languages[langCode] then
        langCode = TARDIS.DefaultLanguage
    end

    local oldLangCode = TARDIS.CurrentLanguage
    TARDIS.CurrentLanguage = langCode

    if not TARDIS.LanguageCache[langCode] then
        self:CompileLanguage(langCode)
    end

    if oldLangCode ~= langCode then
        hook.Call("TARDIS_LanguageChanged", GAMEMODE, langCode, oldLangCode)
        for k,v in pairs(ents.FindByClass("gmod_tardis")) do
            v:CallCommonHook("LanguageChanged", langCode, oldLangCode)
        end
    end
end

hook.Add("TARDIS_SettingChanged", "TARDIS_LanguageSettingChanged", function(id, value, ply)
    if id == "language" then
        TARDIS:UpdateLanguage()
    end
end)

function TARDIS:GetLanguages()
    return self.Languages
end

TARDIS:LoadFolder("languages", false, true)
TARDIS:LoadFolder("languages/extensions", false, true)