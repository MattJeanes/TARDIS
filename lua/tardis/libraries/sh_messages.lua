-- Debug messages

CreateConVar("tardis2_debug", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "TARDIS - debug enabled")
cvars.AddChangeCallback("tardis2_debug", function()
	TARDIS.debug = GetConVar("tardis2_debug"):GetBool()
end)

TARDIS.debug = GetConVar("tardis2_debug"):GetBool()
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

-- Notification messages

if SERVER then
	util.AddNetworkString("tardis_message")
else
	net.Receive("tardis_message", function()
		local error = net.ReadBool()
		local message = net.ReadString()
		TARDIS:Message(LocalPlayer(), message, error)
	end)

	CreateConVar("tardis2_message_type", 3, {FCVAR_ARCHIVE}, "TARDIS - debug enabled")
	cvars.AddChangeCallback("tardis2_message_type", function()
		TARDIS.msg_style = GetConVar("tardis2_message_type"):GetInt()
	end)
	TARDIS.msg_style = GetConVar("tardis2_message_type"):GetInt()
end

function TARDIS:Message(ply, message, error)
	if SERVER then 
		net.Start("tardis_message")
			net.WriteBool(error)
			net.WriteString(message)
		net.Send(ply)
		return
	end
	local style = self.msg_style

	local prefix = "[TARDIS] "
	local err = error and "ERROR: " or ""

	if style == 0 then
		return
	end
	if style == 1 then
		print(prefix .. err .. message)
		return
	end
	if style == 2 then
		LocalPlayer():ChatPrint(prefix .. err .. message)
		return
	end
	if style == 3 then
		local notifyType
		if error then
			notifyType = NOTIFY_ERROR
		else
			notifyType = NOTIFY_GENERIC
		end
		notification.AddLegacy(prefix .. message, notifyType, 5)
		print(prefix .. err .. message)
		return
	end
end

function TARDIS:ErrorMessage(ply, message)
	return TARDIS:Message(ply, message, true)
end

function TARDIS:StatusMessage(ply, name, condition, enabled_msg, disabled_msg)
	if not enabled_msg then enabled_msg = "enabled" end
	if not disabled_msg then disabled_msg = "disabled" end
	TARDIS:Message(ply, name.." "..(condition and enabled_msg or disabled_msg))
end