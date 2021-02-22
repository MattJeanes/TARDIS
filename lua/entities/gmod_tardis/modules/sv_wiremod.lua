--Wiremod support

if not WireLib then return end -- hopefully this prevents the file from running at all if there's no wirelib.

--Vars

local inputs = inputs or {}
local outputs = outputs or {}

--Methods

function ENT:AddWireInput(name)
	table.insert(inputs, name)
end

function ENT:AddWireOutput(name)
	table.insert(outputs, name)
end

--Hooks

function ENT:TriggerInput(name, value)
	self:CallHook("WireInput", name, value)
end

ENT:AddHook("Initialize", "wiremod", function(self)
	WireLib.CreateInputs(self, inputs)
	WireLib.CreateOutputs(self, outputs)
end)