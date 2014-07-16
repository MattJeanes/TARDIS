
-- Add all portal visleafs to server's potentially visible set
hook.Add( "SetupPlayerVisibility", "WorldPortals_AddPVS", function( ply, ent )
	for _, portal in ipairs( ents.FindByClass( "linked_portal_door" ) ) do
		AddOriginToPVS( portal:GetPos() )
	end
end )


-- Make sure that all portals have found their exit
-- Sometimes the entrance portal will be initialized before the exit
hook.Add( "InitPostEntity", "WorldPortals_PairWithExits", function( ply, ent )
	for _, portal in ipairs( ents.FindByClass( "linked_portal_door" ) ) do
		if not IsValid( portal:GetExit() ) then
			portal:SetExit( ents.FindByName( portal:GetPartnerName() )[1] )
		end
	end
end )