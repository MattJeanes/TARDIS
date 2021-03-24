TARDIS.CloakMaterials = TARDIS.CloakMaterials or {}

function TARDIS:CreateCloakMaterial(metadataid, refresh)
	if not TARDIS:GetInteriors()[metadataid] or (not refresh and self.CloakMaterials[metadataid]) then return end
	local metadata = TARDIS:GetInterior(metadataid)

	local ent = ClientsideModel(metadata.Exterior.Model, RENDERGROUP_OTHER)
	local basemat = Material(ent:GetMaterials()[1])
	--print(basemat)
	--print(basemat:GetString("$normalmap"))
	ent:Remove()
	ent = nil

	local normalmap = basemat:GetString("$normalmap")
	local bumpmap = basemat:GetString("$bumpmap")

	local mat = CreateMaterial("tardiscloak-"..metadataid, "Refract", {
		["$model"] = 1,
		["$refractamount"] = ".1",
		["$bluramount"] = 0,
		["$normalmap"] = normalmap,
		["$bumpmap"] = bumpmap,
		["$bumpframe"] = 0,
		Proxies = {
			AnimatedTexture ={
				animatedtexturevar = (normalmap~=nil) and normalmap or bumpmap,
				animatedtextureframenumvar = "$bumpframe",
				animatedtextureframerate = 100.00
			}
		}
	})

	self.CloakMaterials[metadataid] = mat
end

function TARDIS:GetCloakMaterial(id)
	if not self.CloakMaterials[id] then return end
	return self.CloakMaterials[id]
end