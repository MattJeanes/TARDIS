-- Rendering override

TARDIS:AddSetting({
	id="lightoverride-enabled",
	name="[Experimental]\nLighting Override",
	desc="Enable/Disable experimental interior lighting.\nMay cause unexpected issues, and performance drops on lower end systems.",
	section="Misc",
	value=false,
	type="bool",
	option=true,
})

local function predraw_o(self)
	if not TARDIS:GetSetting("lightoverride-enabled",false) then return end
	if self.metadata.Interior.Light == nil then return end --because for some reason SOMEONE OUT THERE didn't define a light.
	--render.SetLightingMode(1)
	local light=self.metadata.Interior.Light
	local lights=self.metadata.Interior.Lights
	local warning = self.exterior:GetData("health-warning", false)
	
	render.SuppressEngineLighting(true)
	local tab={}

	if self:CallHook("ShouldDrawLight",nil,light)~=false then
		render.ResetModelLighting(0.3, 0.3, 0.3)

		local c=light.color
		local warnc = light.warncolor or c
		local lcolor = (warning) and warnc:ToVector() or c:ToVector()
		table.insert(tab,{
			type=MATERIAL_LIGHT_POINT,
			color=lcolor*light.brightness,
			pos = self:LocalToWorld(light.pos),
			quadraticFalloff=20,
		})
	else
		table.insert(tab,{
			type=MATERIAL_LIGHT_POINT,
			color=Vector(0,0,0),
			pos = self:LocalToWorld(light.pos),
			quadraticFalloff=1,
		})
		render.ResetModelLighting(0.05, 0.05, 0.05)
	end
	if lights then
		for _,l in pairs(lights) do
			local shouldDraw = self:CallHook("ShouldDrawLight",nil,l)
			if shouldDraw==false then return end
			local c=l.color
			local warnc = l.warncolor or c
			local lcolor = (warning) and warnc:ToVector() or c:ToVector()
			local tab2 = {
				type=MATERIAL_LIGHT_POINT,
				color=lcolor*l.brightness,
				pos = self:LocalToWorld(l.pos),
				quadraticFalloff=10,
			}
			table.insert(tab, tab2)
		end
	end
	render.SetLocalModelLights(tab)
end

local function postdraw_o(self)
	render.SuppressEngineLighting(false)
end

ENT:AddHook("PreDraw", "customlighting", predraw_o)

ENT:AddHook("Draw", "customlighting", postdraw_o)

ENT:AddHook("PreDrawPart", "customlighting", predraw_o)

ENT:AddHook("DrawPart", "customlighting", postdraw_o)