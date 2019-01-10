TARDIS.Locations = TARDIS.Locations or {}


function TARDIS:LoadLocations()
    if file.Exists("tardis_locations.txt", "DATA") then
        TARDIS.Locations = TARDIS.von.deserialize(file.Read("tardis_locations.txt", "DATA"))
    end
end

function TARDIS:SaveLocations()
    file.Write("tardis_locations.txt", TARDIS.von.serialize(TARDIS.Locations))
end

function TARDIS:AddLocation(pos,ang,name,map)
    if TARDIS.Locations and TARDIS.Locations[map] then
        TARDIS.Locations[map][table.Count(TARDIS.Locations[map])+1] = {
            ["name"] = name,
            ["pos"] = pos,
            ["ang"] = ang
        }
    elseif not TARDIS.Locations[map] then
        TARDIS.Locations[map] = {
            {
                ["name"] = name,
                ["pos"] = pos,
                ["ang"] = ang
            }
        }
    end
    TARDIS:SaveLocations()
end

function TARDIS:RemoveLocation(map,index)
    table.remove(TARDIS.Locations[map],index)
end

TARDIS:LoadLocations()