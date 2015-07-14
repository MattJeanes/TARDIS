-- Key bind system (inspired by WAC)

if SERVER then
	util.AddNetworkString("TARDISI-KeyBind")
	
	local binds={}
	
	net.Receive("TARDISI-KeyBind", function(_,ply)
		local int=ply:GetTardisData("interior")
		if IsValid(int) then
			local id=net.ReadString()
			if binds[id] then
				binds[id](int,net.ReadBool(),ply)
			end
		end
	end)
	
	function ENT:AddKeyBind(id,data)
		if not data.clientonly then
			binds[id]=data.func
		end
	end
	
	function ENT:RemoveKeyBind(id)
		binds[id]=nil
	end
else
	local keys = {
		[0]={n=""},
		[1]={n="0"},
		[2]={n="1"},
		[3]={n="2"},
		[4]={n="3"},
		[5]={n="4"},
		[6]={n="5"},
		[7]={n="6"},
		[8]={n="7"},
		[9]={n="8"},
		[10]={n="9"},
		[11]={n="A"},
		[12]={n="B"},
		[13]={n="C"},
		[14]={n="D"},
		[15]={n="E"},
		[16]={n="F"},
		[17]={n="G"},
		[18]={n="H"},
		[19]={n="I"},
		[20]={n="J"},
		[21]={n="K"},
		[22]={n="L"},
		[23]={n="M"},
		[24]={n="N"},
		[25]={n="O"},
		[26]={n="P"},
		[27]={n="Q"},
		[28]={n="R"},
		[29]={n="S"},
		[30]={n="T"},
		[31]={n="U"},
		[32]={n="V"},
		[33]={n="W"},
		[34]={n="X"},
		[35]={n="Y"},
		[36]={n="Z"},
		[37]={n="keypad 0"},
		[38]={n="keypad 1"},
		[39]={n="keypad 2"},
		[40]={n="keypad 3"},
		[41]={n="keypad 4"},
		[42]={n="keypad 5"},
		[43]={n="keypad 6"},
		[44]={n="keypad 7"},
		[45]={n="keypad 8"},
		[46]={n="keypad 9"},
		[47]={n="keypad /"},
		[48]={n="keypad *"},
		[49]={n="keypad -"},
		[50]={n="keypad +"},
		[51]={n="keypad Enter"},
		[52]={n="keypad Del"},
		[53]={n="["},
		[54]={n="]"},
		[55]={n=";"},
		[56]={n='"'},
		[57]={n="`"},
		[58]={n=","},
		[59]={n="."},
		[60]={n="/"},
		[61]={n="\\"},
		[62]={n="-"},
		[63]={n="="},
		[64]={n="Enter"},
		[65]={n="Space"},
		[66]={n="Backspace"},
		[67]={n="Tab"},
		[68]={n="Caps Lock"},
		[69]={n="Num Lock"},
		[71]={n="Scroll Lock"},
		[72]={n="Insert"},
		[73]={n="Delete"},
		[74]={n="Home"},
		[75]={n="End"},
		[76]={n="Page Up"},
		[78]={n="Break"},
		[79]={n="Shift"},
		[80]={n="Shift Left"},
		[81]={n="Alt"},
		[82]={n="Alt Right"},
		[83]={n="Control"},
		[84]={n="Control Right"},
		[88]={n="Arrow Up"},
		[89]={n="Arrow Left"},
		[90]={n="Arrow Down"},
		[91]={n="Arrow Right"},
		[92]={n="F1"},
		[93]={n="F2"},
		[94]={n="F3"},
		[95]={n="F4"},
		[96]={n="F5"},
		[97]={n="F6"},
		[98]={n="F7"},
		[99]={n="F8"},
		[100]={n="F9"},
		[101]={n="F10"},
		[102]={n="F11"},
		[103]={n="F12"},
		[107]={n="Mouse Left"},
		[108]={n="Mouse Right"},
		[109]={n="Mouse 3"},
		[110]={n="Mouse 4"},
		[111]={n="Mouse 5"},
		[112]={n="Mouse Wheel Up"},
		[113]={n="Mouse Wheel Down"},
	}
	
	function ENT:GetKeyName(key)
		if keys[key] then
			return keys[key].n
		end
	end
	
	local chatopen=false
	hook.Add("StartChat", "TARDISI-KeyBind", function()
		chatopen=true
	end)

	hook.Add("FinishChat", "TARDISI-KeyBind", function()
		chatopen=false
	end)
	
	hook.Add("Think", "tardis-keybind", function()
		if chatopen or gui.IsConsoleVisible() or gui.IsGameUIVisible() then return end -- thanks Exho
		local ext=LocalPlayer():GetTardisData("exterior")
		local int=LocalPlayer():GetTardisData("interior")
		if IsValid(ext) and IsValid(int) then
			for key, info in pairs(keys) do
				local b = info.b
				info.b = key >= 107 and input.IsMouseDown(key) or input.IsKeyDown(key)
				if info.b ~= b then
					--ext:HandleKey(key,info.b)
					int:HandleKey(key,info.b)
				end
			end
		end
	end)
	
	local bindkeys={}
	local binds={}
	
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
		file.Write("tardisi_binds.txt", self.von.serialize(bindkeys))
	end
	
	function ENT:GetKeyBinds()
		local keys={}
		for k,v in pairs(binds) do
			keys[k]=bindkeys[k]
		end
		return keys
	end
	
	function ENT:LoadKeyBinds()
		local keys=file.Read("tardisi_binds.txt","DATA")
		if keys then
			bindkeys=self.von.deserialize(keys)
		end
	end
	ENT:LoadKeyBinds()
	
	function ENT:HandleKey(key,down)
		for k,v in pairs(bindkeys) do
			if v==key then
				local bind=binds[k]
				if bind then
					local res
					if (bind.clientonly or (not (bind.clientonly and bind.serveronly))) and (not bind.serveronly) then
						res=bind.func(self,down)
					end
					if (res~=false) and (not bind.clientonly) then
						net.Start("TARDISI-KeyBind")
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