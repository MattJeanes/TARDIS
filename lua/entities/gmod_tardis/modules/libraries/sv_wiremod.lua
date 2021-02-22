--Wiremod support

--Vars

local inputs = inputs or {}
local outputs = outputs or {}

--Methods

function ENT:AddWireInput(Name, Desc, Type)
	if not WireLib then return end
	local input = {
		name = Name,
		desc = Desc,
		datatype = Type
	}
	table.insert(inputs, input)
end

function ENT:AddWireOutput(Name, Desc, Type)
	if not WireLib then return end
	local output = {
		name = Name,
		desc = Desc,
		datatype = Type
	}
	table.insert(outputs, output)
end

--Hooks

function ENT:TriggerInput(name, value)
	self:CallHook("WireInput", name, value)
end

ENT:AddHook("Initialize", "wiremod", function(self)
	if not WireLib then return end
	PrintTable(inputs)
	PrintTable(outputs)
	local ins = {}
	local indescs = {}
	local intypes = {}
	for k,v in ipairs(inputs) do
		ins[k] = v.name
		indescs[k] = v.desc or nil
		intypes[k] = v.datatype or nil
	end
	WireLib.CreateSpecialInputs(self, ins, intypes, indescs)
	local outs = {}
	local outdescs = {}
	local outtypes = {}
	for k,v in ipairs(outputs) do
		outs[k] = v.name
		outdescs[k] = v.desc or nil
		outtypes[k] = v.datatype or nil
	end
	PrintTable(outdescs)
	WireLib.CreateSpecialOutputs(self, outs, outtypes, outdescs)
end)