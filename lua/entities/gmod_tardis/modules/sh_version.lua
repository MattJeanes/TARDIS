-- Version

ENT:AddHook("Initialize", "version", function(self)
    if CLIENT and LocalPlayer()~=self:GetCreator() then return end

    if TARDIS:IsNewVersion() then
        self:CallCommonHook("NewVersion", TARDIS:GetVersion(), TARDIS:GetLastUsedVersion())
    end

    TARDIS:SetLastUsedVersion()
end)

if SERVER then return end

local function get_release_notes(newVersion)
    local show = TARDIS:GetSetting("show_release_notes")
    if not show then return end
    local headers = {
        ["X-GitHub-Api-Version"] = "2022-11-28"
    }
    local function onsuccess(body, size, headers, code)
        if code ~= 200 then
            print("Failed to retrieve TARDIS release notes for " .. newVersion .. ", code: " .. code .. ", body: " .. body)
            return
        end
        local data = util.JSONToTable(body)
        local release_notes = data.body
        local json = string.match(release_notes, "<!%-%-(.-)%-%->")
        if not json then return end
        local releaseMetadata = util.JSONToTable(json)
        if releaseMetadata.showPopup and releaseMetadata.summary then
            local notes = releaseMetadata.summary
            if releaseMetadata.changes then
                notes = notes .. "\n"
                for k,v in ipairs(releaseMetadata.changes) do
                    notes = notes .. "\n" .. "• ".. v
                end
            end
            Derma_Query(
                TARDIS:GetPhrase("Update.Updated", newVersion) .. "\n\n" .. notes .. "\n\n" .. TARDIS:GetPhrase("Update.ShowReleaseNotes"),
                "TARDIS Update",
                TARDIS:GetPhrase("Common.Yes"),
                function()
                    gui.OpenURL(data.html_url)
                end,
                TARDIS:GetPhrase("Common.No"),
                function() end,
                TARDIS:GetPhrase("Common.DontAskAgain"),
                function()
                    TARDIS:SetSetting("show_release_notes", false)
                end
            )
        end
    end
    local function onfailure(reason)
        print("Failed to retrieve TARDIS release notes for " .. newVersion .. ": " .. reason)
    end
    http.Fetch("https://api.github.com/repos/MattJeanes/TARDIS/releases/tags/" .. newVersion, onsuccess, onfailure, headers)
end

ENT:AddHook("NewVersion", "version", function(self, newVersion, oldVersion)
    get_release_notes(newVersion)
end)
