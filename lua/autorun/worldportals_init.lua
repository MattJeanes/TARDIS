
worldportals = {}

-- Load required files
if SERVER then

	include( "worldportals/render_sv.lua" )

	AddCSLuaFile( "worldportals/render_cl.lua" )

else

	include( "worldportals/render_cl.lua" )

end
