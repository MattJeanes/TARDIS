CreateConVar("tardis2_debug", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "TARDIS - debug enabled")

TARDIS.debug = GetConVar("tardis2_debug"):GetBool()

cvars.AddChangeCallback("tardis2_debug", function()
	TARDIS.debug = GetConVar("tardis2_debug"):GetBool()
end)

function TARDIS:IsDebugOn()
	return TARDIS.debug
end

function TARDIS:Debug(text, ply)
	if TARDIS:IsDebugOn() then
		local fulltext = "[TARDIS Debug] "..text
		if CLIENT and LocalPlayer() then
			LocalPlayer():ChatPrint(fulltext)
		elseif ply ~= nil then
			ply:ChatPrint(fulltext)
		else
			print(fulltext)
		end
	end
end

function TARDIS:DebugPrintTable(table, name)
	if TARDIS:IsDebugOn() then
		if table.name then
			print("\n[TARDIS Debug] Printing table "..name)
		end
		print("\n")
		PrintTable(table)
		print("\n")
	end
end

