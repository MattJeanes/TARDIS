-- Music

local sounds={
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

TARDIS:AddScreen("Music", {id="music", menu=false, order=10, popuponly=true}, function(self,ext,int,frame,screen)
	local label = vgui.Create("DLabel",frame)
	label:SetTextColor(Color(0,0,0))
	label:SetFont(TARDIS:GetScreenFont(screen, "Med"))
	label.DoLayout = function(self)
		label:SizeToContents()
		label:SetPos((frame:GetWide()*0.5)-(label:GetWide()*0.5),(frame:GetTall()*0.3)-(label:GetTall()*0.5))
	end
	label:SetText("Enter song URL (clientside only currently)")
	label:DoLayout()

	local text_bar = vgui.Create( "DTextEntry3D2D", frame )
	text_bar.is3D2D = screen.is3D2D
	text_bar.sub3D2D = label:GetText()
	text_bar:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	text_bar:SetSize( frame:GetWide()*0.5, frame:GetTall()*0.1 )
	text_bar:SetPos(frame:GetWide()*0.5 - text_bar:GetWide()*0.5,frame:GetTall()*0.5 - text_bar:GetTall()*0.5)
	text_bar.OnEnter = function()
		ext:PlayMusic(text_bar:GetValue())
	end

	local playbutton=vgui.Create("DButton",frame)
	playbutton:SetSize(frame:GetWide()*0.2, text_bar:GetTall())
	playbutton:SetPos(text_bar:GetX() + text_bar:GetWide()*1.02, text_bar:GetY())
	playbutton:SetText("Play")
	playbutton:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	playbutton.DoClick = function()
		ext:PlayMusic(text_bar:GetValue())
	end

	--Pre-loaded legacy music

	local list = vgui.Create("DListView",frame)
	list:SetSize(frame:GetWide()*0.5, frame:GetTall()*0.4)
	list:SetPos(text_bar:GetX(), frame:GetTall()*0.78 + list:GetTall()*-0.5)
	list:AddColumn("Pre-loaded music")
	for k,v in pairs(sounds) do
		list:AddLine(v[1])
	end
	function list:OnRowSelected(rowIndex, row)
		ext:PlayMusic("https://mattjeanes.com/data/tardis/" .. sounds[rowIndex][2] ..".mp3")
	end

	local stop=vgui.Create("DButton",frame)
	stop:SetSize( frame:GetWide()*0.2, text_bar:GetTall())
	stop:SetPos(text_bar:GetX() + text_bar:GetWide()*1.02, text_bar:GetY() + text_bar:GetTall()*1.1)
	stop:SetText("Stop")
	stop:SetFont(TARDIS:GetScreenFont(screen, "Default"))
	stop.DoClick = function()
		ext:StopMusic()
	end


end)