-- GUI Settings

ENT.GUISettings={}
function ENT:AddGUISetting(name,func)
    self.GUISettings[name]=func
end