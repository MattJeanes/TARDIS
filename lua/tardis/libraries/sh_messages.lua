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
end
net.Receive("tardis_notification_message", function()
	notification.AddLegacy(net.ReadString(), NOTIFY_GENERIC, 4)
end)

function TARDIS:Message(ply, message)
	local fullmessage = "[TARDIS] "..message
	if self.msg_style == 0 then
		return
	end
	if self.msg_style == 1 then
		print(fullmessage)
		return
	end
	if self.msg_style == 2 then
		ply:ChatPrint(fullmessage)
		return
	end
	if self.msg_style == 3 then
		net.Start("tardis_notification_message")
			net.WriteString(fullmessage)
		net.Send(ply)
		return
	end
end

function TARDIS:StatusMessage(ply, name, condition, enabled_msg, disabled_msg)
	if not enabled_msg then enabled_msg = "enabled" end
	if not disabled_msg then disabled_msg = "disabled" end
	TARDIS:Message(ply, name.." "..(condition and enabled_msg or disabled_msg))
end