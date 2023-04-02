TARDIS:ImportExterior("cabinet", nil, "Torrent64's pack")

TARDIS:ImportExterior("marble", nil, "Torrent64's pack")
TARDIS:ImportExterior("beachhut", nil, "Torrent64's pack")
TARDIS:ImportExterior("assassinclock", nil, "Torrent64's pack")
TARDIS:ImportExterior("cabinet", nil, "Torrent64's pack")
TARDIS:ImportExterior("cupboard", nil, "Torrent64's pack")
TARDIS:ImportExterior("ditrani", nil, "Torrent64's pack")
TARDIS:ImportExterior("doriccolumn", nil, "Torrent64's pack")
TARDIS:ImportExterior("pyramid", nil, "Torrent64's pack")
TARDIS:ImportExterior("ironmaiden", nil, "Torrent64's pack")
TARDIS:ImportExterior("trakenclock", nil, "Torrent64's pack")
TARDIS:ImportExterior("sarnpillar", nil, "Torrent64's pack")

if TARDIS:ImportExterior("slickwine") == false then
    TARDIS:ImportExterior("slickwineold")
end
TARDIS:ImportExterior("tuat", nil, "Police boxes")
TARDIS:ImportExterior("hartnell_63", nil, "Police boxes")
TARDIS:ImportExterior("tardis2010", nil, "Police boxes")
TARDIS:ImportExterior("ambient", nil, "Police boxes")

TARDIS:ImportExterior("rani")
TARDIS:ImportExterior("timmy2985")
TARDIS:ImportExterior("gnome")
TARDIS:ImportExterior("Bill and Ted Tardis")
TARDIS:ImportExterior("HomestucktardisVM")

TARDIS:ImportExterior("72alt", nil, nil, "Computer bank")
TARDIS:ImportExterior("jorj_whittaker", nil, "Police boxes")

TARDIS:ImportExterior("win-quartertardis", nil, "Police boxes", nil, nil, function(E)
    E.Portal.thickness = 27.6
    E.Portal.width = 28
    E.Portal.inverted = true
    return E
end)

TARDIS:ImportExterior("brun_interior", "brun", "Police boxes", nil, nil, function(E)
    E.Portal.pos = Vector(30, 0, 52.2)
    E.Portal.height = 89.4
    E.Portal.thickness = 27
    E.Portal.inverted = true

    E.Parts.door.posoffset = Vector(-30,0,-52.2)

    return E
end)


