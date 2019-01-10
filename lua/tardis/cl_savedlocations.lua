TARDIS.Locations = TARDIS.Locations or {}


function TARDIS:LoadLocations()
    if file.Exists("tardis_locations.txt", "DATA") then
        TARDIS.Locations = TARDIS.von.deserialize(file.Read("tardis_locations.txt", "DATA"))
    end
end

function TARDIS:SaveLocations()
    file.Write("tardis_locations.txt", TARDIS.von.serialize(TARDIS.Locations))
end

TARDIS:LoadLocations()