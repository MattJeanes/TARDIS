-- GUI Settings

TARDIS.GUISettings={}
function TARDIS:AddGUISetting(name,func)
	self.GUISettings[name]=func
end