function TARDIS:SpawnTARDIS(ply, customData)
    local entityName = "gmod_tardis"

    local metadataID = customData.metadataID

    if not (TARDIS:GetInterior(metadataID) and IsValid(ply) and gamemode.Call("PlayerSpawnSENT", ply, entityName)) then return end

    local vStart = ply:EyePos()
    local vForward = ply:GetAimVector()

    local tr
    if not customData.pos then
        local trace = {}
        trace.start = vStart
        trace.endpos = vStart + (vForward * 4096)
        trace.filter = ply

        tr = util.TraceLine(trace)
    end

    local sent = scripted_ents.GetStored(entityName).t
    ClassName = entityName
    local SpawnFunction = scripted_ents.GetMember(entityName, "SpawnFunction")
    if not SpawnFunction then
        return
    end
    local entity = SpawnFunction(sent, ply, tr, entityName, customData)

    if IsValid(entity) then
        entity:SetCreator(ply)
    end

    ClassName = nil

    local interior = TARDIS:GetInterior(metadataID)
    local printName = "TARDIS ("..interior.Name..")"

    if not IsValid(entity) then return end

    if IsValid(ply) then
        gamemode.Call("PlayerSpawnedSENT", ply, entity)
    end

    undo.Create("SENT")
    undo.SetPlayer(ply)
    undo.AddEntity(entity)
    if customData.redecorate_parent then
        undo.AddEntity(customData.redecorate_parent)
    end
    undo.SetCustomUndoText("Undone " .. printName)
    undo.Finish(printName)

    ply:AddCleanup("sents", entity)
    entity:SetVar("Player", ply)

    if TARDIS:GetSetting("randomize_skins", true, entity:GetCreator()) then
        local total_skins = entity:SkinCount()
        if total_skins then
            local chosen_skin = math.random(total_skins)

            local excluded = entity.metadata.Exterior.ExcludedSkins
            local winter = entity.metadata.Exterior.WinterSkins
            local winter_ok = TARDIS:GetSetting("winter_skins", false, entity:GetCreator())

            local function cannot_use_skin(chosen_skin)
                local is_excluded = table.HasValue(excluded, chosen_skin)
                return is_excluded or (not winter_ok and winter and table.HasValue(winter, chosen_skin) )
            end

            if excluded then
                local attempts = 1
                while cannot_use_skin(chosen_skin) and attempts < 30 do
                    chosen_skin = math.random(total_skins)
                    attempts = attempts + 1
                end
            end
            if not excluded or not table.HasValue(excluded, chosen_skin) then
                entity:SetSkin(chosen_skin)
                entity:SetData("intdoor_skin_needs_update", true, true)
            end
        end
    end

    return entity
end
concommand.Add("tardis2_spawn", function(ply, cmd, args)
    TARDIS:SpawnTARDIS(ply, {metadataID = args[1]})
end)