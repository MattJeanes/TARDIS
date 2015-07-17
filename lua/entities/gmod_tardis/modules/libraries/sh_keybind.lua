-- Key bind system (inspired by WAC)

if SERVER then
	util.AddNetworkString("TARDIS-KeyBind")
	
	local binds={}
	
	net.Receive("TARDIS-KeyBind", function(_,ply)
		local ext=ply:GetTardisData("exterior")
		if IsValid(ext) then
			local id=net.ReadString()
			if binds[id] then
				local bind=binds[id]
				local b=net.ReadBool()
				bind.b[ply]=b
				if bind.func then
					bind.func(ext,b,ply)
				end
			end
		end
	end)
	
	function ENT:AddKeyBind(id,data)
		if not data.clientonly then
			binds[id]=table.Copy(data)
			binds[id].b={}
		end
	end
	
	function ENT:IsBindDown(ply,id)
		if binds[id] then
			return binds[id].b[ply]
		end
	end
	
	function ENT:RemoveKeyBind(id)
		binds[id]=nil
	end
else
	local keys = {
		[KEY_NONE]={n=""},
		[KEY_0]={n="0"},
		[KEY_1]={n="1"},
		[KEY_2]={n="2"},
		[KEY_4]={n="3"},
		[KEY_5]={n="4"},
		[KEY_6]={n="5"},
		[KEY_7]={n="6"},
		[KEY_8]={n="7"},
		[KEY_9]={n="8"},
		[KEY_9]={n="9"},
		[KEY_A]={n="A"},
		[KEY_B]={n="B"},
		[KEY_C]={n="C"},
		[KEY_D]={n="D"},
		[KEY_E]={n="E"},
		[KEY_F]={n="F"},
		[KEY_G]={n="G"},
		[KEY_H]={n="H"},
		[KEY_I]={n="I"},
		[KEY_J]={n="J"},
		[KEY_K]={n="K"},
		[KEY_L]={n="L"},
		[KEY_M]={n="M"},
		[KEY_N]={n="N"},
		[KEY_O]={n="O"},
		[KEY_P]={n="P"},
		[KEY_Q]={n="Q"},
		[KEY_R]={n="R"},
		[KEY_S]={n="S"},
		[KEY_T]={n="T"},
		[KEY_U]={n="U"},
		[KEY_V]={n="V"},
		[KEY_W]={n="W"},
		[KEY_X]={n="X"},
		[KEY_Y]={n="Y"},
		[KEY_Z]={n="Z"},
		[KEY_PAD_0]={n="Keypad 0"},
		[KEY_PAD_1]={n="Keypad 1"},
		[KEY_PAD_2]={n="Keypad 2"},
		[KEY_PAD_3]={n="Keypad 3"},
		[KEY_PAD_4]={n="Keypad 4"},
		[KEY_PAD_5]={n="Keypad 5"},
		[KEY_PAD_6]={n="Keypad 6"},
		[KEY_PAD_7]={n="Keypad 7"},
		[KEY_PAD_8]={n="Keypad 8"},
		[KEY_PAD_9]={n="Keypad 9"},
		[KEY_PAD_DIVIDE]={n="Keypad /"},
		[KEY_PAD_MULTIPLY]={n="Keypad *"},
		[KEY_PAD_MINUS]={n="Keypad -"},
		[KEY_PAD_PLUS]={n="Keypad +"},
		[KEY_PAD_ENTER]={n="Keypad Enter"},
		[KEY_PAD_DECIMAL]={n="Keypad Del"},
		[KEY_LBRACKET]={n="["},
		[KEY_RBRACKET]={n="]"},
		[KEY_SEMICOLON]={n=";"},
		[KEY_APOSTROPHE]={n='"'},
		[KEY_BACKQUOTE]={n="`"},
		[KEY_COMMA]={n=","},
		[KEY_PERIOD]={n="."},
		[KEY_SLASH]={n="/"},
		[KEY_BACKSLASH]={n="\\"},
		[KEY_MINUS]={n="-"},
		[KEY_EQUAL]={n="="},
		[KEY_ENTER]={n="Enter"},
		[KEY_SPACE]={n="Space"},
		[KEY_BACKSPACE]={n="Backspace"},
		[KEY_TAB]={n="Tab"},
		[KEY_CAPSLOCK]={n="Caps Lock"},
		[KEY_NUMLOCK]={n="Num Lock"},
		[KEY_SCROLLLOCK]={n="Scroll Lock"},
		[KEY_INSERT]={n="Insert"},
		[KEY_DELETE]={n="Delete"},
		[KEY_HOME]={n="Home"},
		[KEY_END]={n="End"},
		[KEY_PAGEUP]={n="Page Up"},
		[KEY_BREAK]={n="Break"},
		[KEY_LSHIFT]={n="Shift"},
		[KEY_RSHIFT]={n="Shift Right"},
		[KEY_LALT]={n="Alt"},
		[KEY_RALT]={n="Alt Right"},
		[KEY_LCONTROL]={n="Control"},
		[KEY_RCONTROL]={n="Control Right"},
		[KEY_UP]={n="Arrow Up"},
		[KEY_LEFT]={n="Arrow Left"},
		[KEY_DOWN]={n="Arrow Down"},
		[KEY_RIGHT]={n="Arrow Right"},
		[KEY_F1]={n="F1"},
		[KEY_F2]={n="F2"},
		[KEY_F3]={n="F3"},
		[KEY_F4]={n="F4"},
		[KEY_F5]={n="F5"},
		[KEY_F6]={n="F6"},
		[KEY_F7]={n="F7"},
		[KEY_F8]={n="F8"},
		[KEY_F9]={n="F9"},
		[KEY_F10]={n="F10"},
		[KEY_F11]={n="F11"},
		[KEY_F12]={n="F12"},
		[MOUSE_LEFT]={n="Mouse Left"},
		[MOUSE_RIGHT]={n="Mouse Right"},
		[MOUSE_MIDDLE]={n="Mouse 3"},
		[MOUSE_4]={n="Mouse 4"},
		[MOUSE_5]={n="Mouse 5"},
		[MOUSE_WHEEL_UP]={n="Mouse Wheel Up"},
		[MOUSE_WHEEL_DOWN]={n="Mouse Wheel Down"},
	}
	
	function ENT:GetKeyName(key)
		if keys[key] then
			return keys[key].n
		end
	end
	
	local chatopen=false
	hook.Add("StartChat", "TARDIS-KeyBind", function()
		chatopen=true
	end)

	hook.Add("FinishChat", "TARDIS-KeyBind", function()
		chatopen=false
	end)
	
	hook.Add("Think", "TARDIS-KeyBind", function()
		if chatopen or gui.IsConsoleVisible() or gui.IsGameUIVisible() then return end -- thanks Exho
		local ext=LocalPlayer():GetTardisData("exterior")
		if IsValid(ext) then
			for key, info in pairs(keys) do
				local b = info.b
				info.b = key >= MOUSE_LEFT and input.IsMouseDown(key) or input.IsKeyDown(key)
				if info.b ~= b then
					ext:HandleKey(key,info.b)
				end
			end
		end
	end)
	
	local bindkeys={}
	local binds={}
	
	function ENT:GetBindKey(id)
		if bindkeys[id] then
			return bindkeys[id]
		end
	end
	
	function ENT:AddKeyBind(id,data)
		if bindkeys[id]==nil then
			bindkeys[id]=data.key
		end
		binds[id]=table.Copy(data)
	end
	
	function ENT:RemoveKeyBind(id)
		bindkeys[id]=nil
		binds[id]=nil
	end
	
	function ENT:SetKeyBind(id,key)
		if bindkeys[id] then
			bindkeys[id]=key
		end
		self:SaveKeyBinds()
	end
	
	function ENT:GetBinds()
		return binds
	end
	
	function ENT:GetBind(id)
		if binds[id] then
			return binds[id]
		end
	end
	
	function ENT:SaveKeyBinds()
		local keys={}
		for k,v in pairs(binds) do
			if bindkeys[k] and bindkeys[k]~=v.key then
				keys[k]=bindkeys[k]
			end
		end
		file.Write("tardis_binds.txt", self.von.serialize(keys))
	end
	
	function ENT:LoadKeyBinds()
		local keys=file.Read("tardis_binds.txt","DATA")
		if keys then
			bindkeys=self.von.deserialize(keys)
		end
	end
	ENT:LoadKeyBinds()
	
	function ENT:IsBindDown(id)
		if bindkeys[id] then
			return keys[bindkeys[id]].b
		end
	end
	
	function ENT:HandleKey(key,down)
		for k,v in pairs(bindkeys) do
			if v==key then
				local bind=binds[k]
				if bind then
					local res
					if (bind.clientonly or (not (bind.clientonly and bind.serveronly))) and (not bind.serveronly) and bind.func then
						res=bind.func(self,down,LocalPlayer())
					end
					if (res~=false) and (not bind.clientonly) then
						net.Start("TARDIS-KeyBind")
							net.WriteString(k)
							net.WriteBool(down)
						net.SendToServer()
					end
				end
			end
		end
	end
	
end

--[[
ENT:AddKeyBind("test",{
	func=function(self,down,ply)
		if CLIENT then
			LocalPlayer():ChatPrint("CLIENT "..tostring(down))
		else
			ply:ChatPrint("SERVER "..tostring(down))
		end
	end,
	key=KEY_SPACE
})
]]--