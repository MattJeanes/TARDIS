-- Music

local default_music={
	{"Main Theme (2005)", "theme1"},
	{"Main Theme (2009)", "theme2"},
	{"Main Theme (2010)", "theme3"},
	{"Main Theme (2013)", "theme4"},
	{"Ninth Doctor", "nine"},
	{"Tenth Doctor", "ten"},
	{"Eleventh Doctor", "eleven"},
	{"Rose Tyler", "rose"},
	{"Martha Jones", "martha"},
	{"Donna Noble", "donna"},
	{"Amy Pond", "amy"},
	{"River Song", "river"},
	{"Clara Oswald", "clara"},
	{"Abigail's Song", "abigail"},
	{"This is Gallifrey", "thisisgallifrey"},
	{"Gallifrey", "gallifrey"},
	{"Vale Decem", "valedecem"},
	{"The Majestic Tale", "majestictale"},
	{"Forgiven", "forgiven"},
	{"The Wedding of River Song", "weddingofriversong"},
	{"All the Strange Creatures", "allthestrangecreatures"},
	{"You're Fired", "yourefired"},
	{"Whose Enigma", "whoseenigma"},
	{"The Long Song", "thelongsong"},
	{"Infinite Potential", "infinitepotential"},
	{"The New Doctor", "thenewdoctor"},
	{"My Husband's Home", "myhusbandshome"},
	{"Doomsday", "doomsday"},
	{"Dark and Endless Dalek Night", "darkandendlessdaleknight"},
	{"The Greatest Story Never Told", "greateststorynevertold"},
}

--Custom music

local custom_music

local filename = "tardis2_custom_music.txt"
if file.Exists(filename,"DATA") then
	custom_music = TARDIS.von.deserialize(file.Read(filename,"DATA"))
else
	custom_music = {}
end

function TARDIS:SaveCustomMusic()
	file.Write(filename, TARDIS.von.serialize(custom_music))
end

function TARDIS:AddCustomMusic(name, url)
	local next = table.Count(custom_music) + 1
	custom_music[next] = {name, url}
	TARDIS:SaveCustomMusic()
end

function TARDIS:RemoveCustomMusic(index)
	table.remove(custom_music, index)
	TARDIS:SaveCustomMusic()
end


	--Music GUI

TARDIS:AddScreen("Music", {id="music", menu=false, order=10, popuponly=true}, function(self,ext,int,frame,screen)
	local frW = frame:GetWide()
	local frT = frame:GetTall()
	local gap = math.min(frT, frW) * 0.05 * 1.2

	local bT = frT * 0.1

	local listW = frW * 0.3
	local listT = frT - 2 * gap

	local tbW = frW - 4 * gap - 2 * listW
	local tbT = frT * 0.1
	local bW = 0.5 * (tbW - gap)

	local midX = 3 * gap + 2 * listW

	local url
	local name_bar
	local list_premade
	local list_custom

	local text_bar = vgui.Create( "DTextEntry", frame )
	text_bar:SetPlaceholderText("Enter song URL (Clientside Only)")
	text_bar:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	text_bar:SetSize(tbW, tbT)
	text_bar:SetPos(midX, gap)
	function text_bar:OnEnter()
		ext:PlayMusic(text_bar:GetValue())
	end

	function text_bar:OnGetFocus()
		text_bar:SetTextColor(Color(0,0,0))
		name_bar:SetTextColor(Color(0,0,0))
		list_premade:ClearSelection()
		list_custom:ClearSelection()
	end


	function text_bar:OnValueChange()
		text_bar:SetTextColor(Color(0,0,0))
		name_bar:SetTextColor(Color(0,0,0))
		list_premade:ClearSelection()
		list_custom:ClearSelection()
	end

	name_bar = vgui.Create( "DTextEntry", frame )
	name_bar:SetPlaceholderText("Enter custom song name")
	name_bar:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	name_bar:SetSize(tbW, tbT)
	name_bar:SetPos(midX, 2 * gap + tbT)
	function name_bar:OnEnter()
		TARDIS:AddCustomMusic(name_bar:GetText(), text_bar:GetText())
		frame.updatelist()
	end

	function name_bar:OnGetFocus()
		text_bar:SetTextColor(Color(0,0,0))
		name_bar:SetTextColor(Color(0,0,0))
		list_premade:ClearSelection()
		list_custom:ClearSelection()
	end

	function name_bar:OnValueChange()
		text_bar:SetTextColor(Color(0,0,0))
		name_bar:SetTextColor(Color(0,0,0))
		list_premade:ClearSelection()
		list_custom:ClearSelection()
	end

	--Buttons

	local playbutton=vgui.Create("DButton",frame)
	playbutton:SetSize(tbW, bT * 1.3)
	playbutton:SetPos(midX, gap + listT - bT * 1.3)
	playbutton:SetText("Play / Stop")
	playbutton:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	function playbutton:DoClick()
		if IsValid(ext.music) and ext.music:GetState()==GMOD_CHANNEL_PLAYING then
			ext:StopMusic()
		else
			if list_premade:GetSelectedLine() then
				ext:PlayMusic(url)
			else
				ext:PlayMusic(text_bar:GetValue())
			end
		end
	end

	local removemus=vgui.Create("DButton",frame)
	removemus:SetSize(bW, bT)
	removemus:SetPos(midX + gap + bW, 3 * gap + 2 * tbT)
	removemus:SetText("Remove")
	removemus:SetFont(TARDIS:GetScreenFont(screen, "Default"))

	--Pre-loaded legacy music select

	list_premade = vgui.Create("DListView",frame)
	list_premade:SetSize(listW, listT)
	list_premade:SetPos(gap, gap)
	list_premade:AddColumn("Pre-loaded music")
	list_premade:SetMultiSelect(false)
	for k,v in pairs(default_music) do
		list_premade:AddLine(v[1])
	end

	function list_premade:OnRowSelected(rowIndex, row)
		list_custom:ClearSelection()
		url = ("https://mattjeanes.com/data/tardis/" .. default_music[rowIndex][2] ..".mp3")
		text_bar:SetTextColor(Color(139,139,139))
		name_bar:SetTextColor(Color(139,139,139))
	end

	--Custom music select

	list_custom = vgui.Create("DListView",frame)
	list_custom:SetSize(listW, listT)
	list_custom:SetPos(2 * gap + listW, gap)
	list_custom:AddColumn("Custom Music")
	list_custom:SetMultiSelect(false)

	function list_custom:OnRowSelected(rowIndex,row)
		list_premade:ClearSelection()
		text_bar:SetText(custom_music[rowIndex][2])
		name_bar:SetText(custom_music[rowIndex][1])
		text_bar:SetTextColor(Color(0,0,0))
		name_bar:SetTextColor(Color(0,0,0))
	end

	local savemus=vgui.Create("DButton",frame)
	savemus:SetSize(bW, bT)
	savemus:SetPos(midX, 3 * gap + 2 * tbT)
	savemus:SetText("Save")
	savemus:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	function savemus:DoClick()
		TARDIS:AddCustomMusic(name_bar:GetText(), text_bar:GetText())
		frame.updatelist()
	end

	function removemus:DoClick()
		local line = list_custom:GetSelectedLine()
		if not line then
			TARDIS:ErrorMessage(LocalPlayer(), "Nothing has been chosen for removal.")
			return
		end

		Derma_Query("Are you sure you want to remove " .. custom_music[line][1] .. " from the music list? This cannot be undone.",
					"TARDIS Interface",
					"Yes",
					function()
						TARDIS:RemoveCustomMusic(line)
						frame.updatelist()
					end,
					"No",
					function()
					end):SetSkin("TARDIS")
	end

	function frame.updatelist()
		list_custom:Clear()
		if text_bar ~= nil then
			for k,v in pairs(custom_music) do
				list_custom:AddLine(v[1])
			end
		end
	end
	frame.updatelist()

end)