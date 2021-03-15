TARDIS.CSequences = {}

function TARDIS:AddControlSequence(cseq)
	self.CSequences[cseq.ID] = cseq
end

function TARDIS:GetControlSequence(id)
	if self.CSequences[id] ~= nil then
		return self.CSequences[id]
	end
end

TARDIS:LoadFolder("interiors/sequences",nil,true)