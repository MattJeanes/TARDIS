TARDIS.CloakMaterials = TARDIS.CloakMaterials or {}

concommand.Add("tardis2_createcloakmats", function(ply)
	if not ply == LocalPlayer() then return end
	TARDIS:CreateCloakMaterials()
end, nil, "Generate TARDIS cloak procedural materials")

function TARDIS:CreateCloakMaterial(metadataid, refresh)
	if not TARDIS:GetInteriors()[metadataid] or (not refresh and self.CloakMaterials[metadataid]) then return end
	local metadata = TARDIS:GetInterior(metadataid)

	local ent = ClientsideModel(metadata.Exterior.Model, RENDERGROUP_OTHER)
	local basemat = Material(ent:GetMaterials()[1])
	ent:Remove()
	ent = nil

	local normalmap = basemat:GetString("$normalmap")
	local bumpmap = basemat:GetString("$bumpmap")

	if normalmap==nil and bumpmap==nil then return end

	local mat = CreateMaterial("tardiscloak-"..metadataid, "Refract", {
		["$model"] = 1,
		["$refractamount"] = ".1",
		["$refracttint"] = "{255 255 255}",
		["$bluramount"] = 0,
		["$normalmap"] = normalmap or bumpmap,
		["$bumpframe"] = 0,
		Proxies = {
			AnimatedTexture ={
				animatedtexturevar = "$normalmap",
				animatedtextureframenumvar = "$bumpframe",
				animatedtextureframerate = 100.00
			}
		}
	})

	self.CloakMaterials[metadataid] = mat
end

function TARDIS:CreateCloakMaterials()
	print("TARDIS - Generating procedural cloak materials")
	local interiors = self:GetInteriors()
	for k,v in pairs(interiors) do
		if v.Exterior.PhaseMaterial then return end
		self:CreateCloakMaterial(k)
	end
	print("TARDIS - Finished generating "..table.Count(self.CloakMaterials).." procedural materials.")
end

function TARDIS:GetCloakMaterial(id)
	if TARDIS:GetInterior(id).Exterior.PhaseMaterial then
		return Material(TARDIS:GetInterior(id).Exterior.PhaseMaterial)
	end
	return self.CloakMaterials[id] or Material("models/drmatt/tardis/exterior/phase_noise.vmt")
end