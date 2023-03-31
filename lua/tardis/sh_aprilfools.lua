CreateConVar("tardis2_aprilfools_2023", 1, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "0: off, 1: on if april 1st, 2: always on", 0, 2)

function TARDIS:IsAprilFools()
    local aprilFools = cvars.Number("tardis2_aprilfools_2023")
    if aprilFools == 1 and os.date("%d/%m") == "01/04" then
        return true
    elseif aprilFools == 2 then
        return true
    else
        return false
    end
end
