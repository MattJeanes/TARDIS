-- Advanced mode on Steroids // also known as don't let me think when the power's out

ENT:AddHook("PartUsed","HandleControlSequence",function(self,part,a)
    --print(part:GetClass())
end)

