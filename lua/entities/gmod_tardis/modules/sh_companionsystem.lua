-- Companion system - used to allow other users to use owner TARDIS functions

TARDIS:AddSetting({
    id="companions-list",
    name="Companions",
    --section="Exterior Door",
    desc="List of companions that can use owner functions on your TARDIS as well as bypass isomorphic controls.",
    value={},
    type="custom",
    option=true,
    networked=true
})

local function DrawAddPlayerSubMenu(frame, lst)
    local addMenuBtn = vgui.Create("DButton", frame)
	addMenuBtn:Dock(TOP)
	addMenuBtn:SetText("Add")

	addMenuBtn.DoClick = function(me)
        local addMenu = vgui.Create("DFrame", frame)
        addMenu:SetSkin("TARDIS")
        addMenu:SetTitle("Add To Companions")
        addMenu:SetSize(frame:GetWide(), frame:GetTall())
        addMenu:SetDraggable(false)
        addMenu:ShowCloseButton(false)
        addMenu:Center()

        local onlinePlayersList = vgui.Create("DListView", addMenu)
        onlinePlayersList:Dock(TOP)
        onlinePlayersList:SetTall(addMenu:GetTall() * 0.7)
        onlinePlayersList:SetMultiSelect(false)
        onlinePlayersList:AddColumn("Name")
        onlinePlayersList:AddColumn("SteamID")
        onlinePlayersList.Players = {}

        onlinePlayersList.AddPlayer = function(me, v)
            local name = v:Name()
            local id = v:SteamID()

            me.Players[id] = v

            me:AddLine(name, id)
        end

        for k, v in pairs(player.GetAll()) do
            if not IsValid(v) or v == LocalPlayer() or lst.Players[v:SteamID()] then continue end
            onlinePlayersList:AddPlayer(v)
        end

        --[[local steamIDEntry = vgui.Create("DTextEntry", addMenu)
        steamIDEntry:Dock(TOP)
        steamIDEntry:SetPlaceholderText("Or enter the player's SteamID here...")--]]

        addPlayerBtn = vgui.Create("DButton", addMenu)
        addPlayerBtn:Dock(TOP)
        addPlayerBtn:SetTall(addMenu:GetTall() * 0.1)
        addPlayerBtn:SetText("Add Player")

        addPlayerBtn.DoClick = function(me)
            local selectionID, selectionLineInfo = onlinePlayersList:GetSelectedLine()
            if selectionID == nil or selectionLineInfo == nil then return end
            
            local ID = selectionLineInfo:GetColumnText(2)

            if onlinePlayersList.Players[ID] then
                onlinePlayersList:RemoveLine(selectionID)
                
                -- Add to companions list
                lst:AddPlayer(onlinePlayersList.Players[ID])
                print("Running hook!")
                hook.Run("TARDIS-UpdateCustomOption", onlinePlayersList.Players)
                
                onlinePlayersList.Players[ID] = nil
            end
        end

        local returnBtn = vgui.Create("DButton", addMenu)
        returnBtn:Dock(BOTTOM)
        returnBtn:SetTall(addMenu:GetTall() * 0.1)
        returnBtn:SetText("Return")

        returnBtn.DoClick = function(me)
            addMenu:Remove()
        end
    end
end

hook.Add("TARDIS-CustomOption", "companions_menu", function(frame, savedData)
    frame:SetTall(frame:GetTall() + 200) -- Create more space for list
	local companionsList = vgui.Create("DListView", frame)
	companionsList:Dock(TOP)
	companionsList:DockMargin(0, 50, 0, 0)
	companionsList:SetTall(frame:GetTall() * 0.4)
	companionsList:SetMultiSelect(true)
	companionsList:AddColumn("Name")
	companionsList:AddColumn("SteamID")
    companionsList.Players = {}

    companionsList.AddPlayer = function(me, v)
        local name = v:Name()
        local id = v:SteamID()

        me.Players[id] = v

        me:AddLine(name, id)
    end

    companionsList.RemovePlayer = function(me, v, lineID)
        local name = v:Name()
        local id = v:SteamID()

        me.Players[id] = nil 
        me:RemoveLine(lineID)
    end

    local function updateList(value)
        if istable(value) and table.Count(value) > 0 then
            for k, v in pairs(value) do
                companionsList:AddPlayer(v)
            end
        elseif istable(value) and table.Count(value) <= 0 then
            companionsList:Clear()
            companionsList.Players = {}
        end
    end

    DrawAddPlayerSubMenu(frame, companionsList)

	local removeBtn = vgui.Create("DButton", frame)
	removeBtn:Dock(TOP)
	removeBtn:SetText("Remove")

    removeBtn.DoClick = function(me)
        local selectionID, selectionLineInfo = companionsList:GetSelectedLine()
        if selectionID == nil or selectionLineInfo == nil then return end
            
        local ID = selectionLineInfo:GetColumnText(2)

        if companionsList.Players[ID] then
            companionsList:RemovePlayer(companionsList.Players[ID], selectionID)
        end
    end

    return updateList
end)