TARDIS.CSequences = {}

function TARDIS:AddCSequence(cseq)
    self.CSequences[cseq.ID] = cseq
end

function TARDIS:GetCSequence(id)
    if self.CSequences[id] ~= nil then
        return self.CSequences[id]
    end
end

TARDIS:LoadFolder("interiors",false,true)