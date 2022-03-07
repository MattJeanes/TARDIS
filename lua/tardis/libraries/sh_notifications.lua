-- Debug messages

if SERVER then
    util.AddNetworkString("TARDIS-Debug")
end

local function chat_print(text)
    if SERVER then
        net.Start("TARDIS-Debug")
            net.WriteString(text)
        net.Broadcast()
    else
        if LocalPlayer() and LocalPlayer().ChatPrint then
            -- this function doesn't exist yet when the game is loading
            LocalPlayer():ChatPrint(text)
        else
            print(text)
        end
    end
end

if CLIENT then
    net.Receive("TARDIS-Debug", function()
        local text=net.ReadString()
        chat_print(text)
    end)
end

function TARDIS:Debug(...)
    if not TARDIS:GetSetting("debug", false) then return end

    local args = {...}

    -- nil values are being ignored, so we add them as strings
    for i = 1,table.maxn(args) do
        if args[i] == nil then
            args[i] = "<nil>"
        end
    end

    local debug_prefix = "[TARDIS DEBUG] (" .. (SERVER and "SERVER" or "CLIENT") .. ")  :  "

    local full_text = debug_prefix
    local table_num = 1

    if ... == nil or args == nil then
        full_text = "<nil>"
    else
        for k,arg in pairs(args) do
            local text
            if istable(arg) then
                print("\n" .. debug_prefix .. "Table #" .. table_num .. ":")
                print("---------------------------------------------------")
                PrintTable(arg, 1)
                print("---------------------------------------------------")

                full_text = full_text .. "<table #" .. table_num .. ">  "
                table_num = table_num + 1
            else
                full_text = full_text .. tostring(arg) .. "  "
            end
        end
    end
    print("\n")
    if TARDIS:GetSetting("debug_chat") then
        if SERVER then print(full_text) end
        chat_print(full_text)
    else
        print(full_text)
    end

end

-- shortcut alias
function tardisdebug(...) TARDIS:Debug(...) end

-- Notification messages

if SERVER then
    util.AddNetworkString("tardis_message")
else
    net.Receive("tardis_message", function()
        local error = net.ReadBool()
        local message = net.ReadString()
        TARDIS:Message(LocalPlayer(), message, error)
    end)
end

function TARDIS:Message(ply, message, error)
    if SERVER then
        net.Start("tardis_message")
            net.WriteBool(error)
            net.WriteString(message)
        net.Send(ply)
        return
    end
    local style = self:GetSetting("notification_type", 3, ply)

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