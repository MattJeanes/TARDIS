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
CreateConVar("tardis2_message_type", 3, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "TARDIS - debug enabled")
cvars.AddChangeCallback("tardis2_message_type", function()
	TARDIS.msg_style = GetConVar("tardis2_message_type"):GetInt()
end)

TARDIS.msg_style = GetConVar("tardis2_message_type"):GetInt()

if SERVER then
	util.AddNetworkString("tardis_notification_message")
	util.AddNetworkString("tardis_notification_error")
end
net.Receive("tardis_notification_message", function()
	notification.AddLegacy(net.ReadString(), NOTIFY_GENERIC, 5)
end)
net.Receive("tardis_notification_error", function()
	notification.AddLegacy(net.ReadString(), NOTIFY_ERROR, 5)
end)

function TARDIS:Message(ply, message, error, style_override)
	local style = style_override or self.msg_style
	local fullmessage = "[TARDIS] "..message
	if style == 0 then
		return
	end
	if style == 1 then
		print(fullmessage)
		return
	end
	if style == 2 then
		ply:ChatPrint(fullmessage)
		return
	end
	if style == 3 then
		if error then
			net.Start("tardis_notification_error")
		else
			net.Start("tardis_notification_message")
		end
			net.WriteString(fullmessage)
		net.Send(ply)
		print(fullmessage)
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