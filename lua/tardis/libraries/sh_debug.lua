
-- Debug messages

CreateConVar("tardis2_debug", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "TARDIS - debug enabled")
cvars.AddChangeCallback("tardis2_debug", function()
    TARDIS.debug = GetConVar("tardis2_debug"):GetBool()
end)

CreateConVar("tardis2_debug_chat", 0, {FCVAR_ARCHIVE, FCVAR_REPLICATED}, "TARDIS - print debug to chat as well")
cvars.AddChangeCallback("tardis2_debug_chat", function()
    TARDIS.debug_chat = GetConVar("tardis2_debug_chat"):GetBool()
end)

TARDIS.debug = GetConVar("tardis2_debug"):GetBool()
TARDIS.debug_chat = GetConVar("tardis2_debug_chat"):GetBool()

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
    if not self.debug then return end

    local args = {...}

    -- nil values are being ignored, so we add them as strings
    for i = 1,table.maxn(args) do
        if args[i] == nil then
            args[i] = "<nil>"
        end
    end

    local SOURCE = (SERVER and "SERVER" or "CLIENT")
    local debug_prefix = "[TARDIS DEBUG] (" .. SOURCE .. ")  :  "
    local debug_table_prefix = "[TARDIS DEBUG :: TABLE OUTPUT] (" .. SOURCE .. ")  :  "

    local tables_to_print = {}

    local full_text = debug_prefix

    if ... == nil or args == nil then
        full_text = full_text .. "<nil>"
    else
        for k,arg in pairs(args) do
            local text
            if istable(arg) then
                table.insert(tables_to_print, arg)
                full_text = full_text .. "<" .. tostring(arg) .. ">  "
            else
                full_text = full_text .. tostring(arg) .. "  "
            end
        end
    end
    print("\n")
    if self.debug_chat then
        if SERVER then print(full_text) end
        chat_print(full_text)
    else
        print(full_text)
    end

    for i,v in ipairs(tables_to_print) do
        print("\n\n" .. debug_table_prefix .. tostring(v) .. ":")
        print("―――――――――――――――――――――――――――――――――――――――――――――――――――")
        PrintTable(v, 1)
        print("―――――――――――――――――――――――――――――――――――――――――――――――――――")
    end
    print("\n\n\n")

end

-- shortcut alias
function tardisdebug(...) TARDIS:Debug(...) end