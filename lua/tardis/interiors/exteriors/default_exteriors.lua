TARDIS:ImportExterior("cabinet")

TARDIS:ImportExterior("marble")
TARDIS:ImportExterior("beachhut")
TARDIS:ImportExterior("assassinclock")
TARDIS:ImportExterior("cabinet")
TARDIS:ImportExterior("cupboard")
TARDIS:ImportExterior("ditrani")
TARDIS:ImportExterior("doriccolumn")
if TARDIS:ImportExterior("slickwine") == false then
    TARDIS:ImportExterior("slickwineold")
end
TARDIS:ImportExterior("pyramid")
TARDIS:ImportExterior("rani")
TARDIS:ImportExterior("ironmaiden")
TARDIS:ImportExterior("trakenclock")
TARDIS:ImportExterior("sarnpillar")
TARDIS:ImportExterior("timmy2985")
TARDIS:ImportExterior("tuat")
TARDIS:ImportExterior("hartnell_63")
TARDIS:ImportExterior("gnome")
TARDIS:ImportExterior("tardis2010")
TARDIS:ImportExterior("Bill and Ted Tardis")
TARDIS:ImportExterior("ambient")
TARDIS:ImportExterior("HomestucktardisVM")

TARDIS:ImportExterior("72alt")
TARDIS:ImportExterior("jorj_whittaker")

TARDIS:ImportExterior("win-quartertardis", nil, nil, nil, function(E)
    E.Portal.thickness = 27.6
    return E
end)

TARDIS:ImportExterior("brun_interior", "brun", nil, nil, function(E)
    E.Portal.pos = Vector(30, 0, 52.2)
    E.Portal.height = 89.4
    E.Portal.thickness = 27
    E.Portal.inverted = true

    E.Parts.door.posoffset = Vector(-30,0,-52.2)

    return E
end)


