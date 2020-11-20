-- Rendering override

TARDIS:AddSetting({
    id="lightoverride-enabled",
    name="[Experimental]\nLighting Override",
    desc="Enable/Disable experimental interior lighting.\nMay cause unexpected issues, and performance drops on lower end systems.",
    section="Misc",
    value=false,
    type="bool",
    option=true,
    networked=true
})

local function predraw_o(self)
    if not TARDIS:GetSetting("lightoverride-enabled",false,LocalPlayer()) then return end
    render.SuppressEngineLighting(true)
    --render.SetLightingMode(1)

    render.ResetModelLighting(0.5, 0.5, 0.5)
    local light=self.metadata.Interior.Light
    local lights=self.metadata.Interior.Lights
    local c = light.color:ToVector()
    if self:CallHook("ShouldDrawLight") == false then 
        render.ResetModelLighting(0.05, 0.05, 0.05)
        render.SetLocalModelLights()
        return 
    end
    --render.SetModelLighting(BOX_TOP, 1, 2, 3)
    local tab={{
        type=MATERIAL_LIGHT_POINT,
        color=light.color:ToVector()*light.brightness,
        pos = self:LocalToWorld(light.pos),
        quadraticFalloff=20,
    }}
    if lights then
        for _,light in pairs(lights) do
            local tab2 = {
                type=MATERIAL_LIGHT_POINT,
                color=light.color:ToVector()*light.brightness,
                pos = self:LocalToWorld(light.pos),
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