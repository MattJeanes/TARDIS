-- Advanced mode on Steroids // also known as don't let me think when the power's out

--[[
Control Sequences - Format & Execution

Sequences are defined in a file (will probably be in the interiors folder),
and the file's name referenced in the metadata.

When the interior is loaded, the data in the sequences file will be "moved" into a table in the metadata
so that it can be easily accessed from code (mostly by [this] file)

The proposed format is the following
local SEQ = {
    ID="sequences-id"
    ["starter-control-1"] = {
        Controls={
            "followup-control-1",
            "followup-2",
            "followup-3"
        },
        OnFinish = function(int, ply, step, part) end,
        OnFail = function(int, ply, step, part) end
    }
}
This is the definition of a simple sequence.
The table keys are control IDs, like the ones in the interior file.
Using starter-control-1 will initiate the sequence. From there, you would use the followup-controls
in the order they were defined on the table. OnFinish will be the end result if the sequence is done right
Otherwise, OnFail will be called. The example above shows the order of the args on both.

When a sequence is in progress, all the parts of that sequence will receive a variable which can be used to
determine whether or not it is being used in a sequence. The idea is so that individual developers can
choose any control they have, while keeping their individual functionality.
It's recommended however, not to mix sequence starter controls with individual functioning ones, as this will
simultaneously engage the tardis into a sequence as well as do the individual control's use function.

There's also support for branched sequences, from which a starter control can branch off into different
sequences. As of 04/02/2019 there's no plans to support this as deeper as one level, that is, it will only be
available on the first followup control. This might change five minutes after.

Full documentation for control sequences will be available on the wiki.
]]


if SERVER then
    ENT:AddHook("PartUsed","HandleControlSequence",function(self,part,a)
        local sequences = TARDIS:GetCSequence(self.metadata.Interior.Sequences)
        if sequences == nil then return end
        local id = part.ID
        local active = self:GetData("cseq-active",false)
        local step = self:GetData("cseq-step")
        if active==false and sequences[id] then
            if not self:GetData("advanced-flight", false) then return end
            self:EmitSound(self.metadata.Interior.Sounds.SeqOK)
            self:SetData("cseq-active", true)
            self:SetData("cseq-step", 1)
            self:SetData("cseq-curseq", id)
            for _,v in pairs(sequences[id].Controls) do
                local p = TARDIS:GetPart(self,v)
                p.InSequence = true
            end
        elseif active==true then
            local curseq = self:GetData("cseq-curseq","none")
            if sequences[curseq].Controls[step] == id then
                self:EmitSound(self.metadata.Interior.Sounds.SeqOK)
                self:SetData("cseq-step",step+1)
                if step == #sequences[curseq].Controls then
                    sequences[curseq].OnFinish(self, a, step, part)
                    self:TerminateSequence()
                    return
                end
            else
                if id == "console" or id == "door" then return end
                self:EmitSound(self.metadata.Interior.Sounds.SeqBad)
                if sequences[curseq].OnFail then
                    sequences[curseq].OnFail(self, a, step, part)
                end
                self:TerminateSequence()
                return
            end
        end
    end)
    ENT:AddHook("CanStartCSequence", "settingquery-sv", function(self)
        return true
    end)

    function ENT:TerminateSequence()
        --print("force-quitting current tardis cseq ("..self:GetData("cseq-curseq")..")")
        local sequences = TARDIS:GetCSequence(self.metadata.Interior.Sequences)
        local curseq = self:GetData("cseq-curseq","none")
        for _,v in pairs(sequences[curseq].Controls) do
            local p = TARDIS:GetPart(self,v)
            p.InSequence = false
        end
        self:SetData("cseq-step",nil)
        self:SetData("cseq-curseq",nil)
        self:SetData("cseq-active",false)
    end

end