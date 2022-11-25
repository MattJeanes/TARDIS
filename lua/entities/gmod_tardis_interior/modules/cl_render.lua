-- Rendering override

local function predraw_o(self)
    if not TARDIS:GetSetting("lightoverride-enabled") then return end

    render.SuppressEngineLighting(true)
    local lo = self.metadata.Interior.LightOverride
    local br = power and lo.basebrightness or lo.nopowerbrightness
    render.ResetModelLighting(br, br, br)

    --render.SetLightingMode(1)
    local light = self.light_data.main

    if light == nil then return end
    --because for some reason SOMEONE OUT THERE didn't define a light.

    local lights = self.light_data.extra
    local warning = self:GetData("health-warning", false)
    local power = self:GetPower()

    local tab={}

    local function AddLightRenderTable(lt)
        if self:CallHook("ShouldDrawLight",nil,lt) == false then return end

        if not power and warning then
            table.insert(tab, {
                type = MATERIAL_LIGHT_POINT,
                color = lt.off_warn_color_vec,
                pos = lt.off_warn_pos_global,
                quadraticFalloff = lt.off_warn_falloff,
            })
        elseif not power then
            table.insert(tab, {
                type = MATERIAL_LIGHT_POINT,
                color = lt.off_color_vec,
                pos = lt.off_pos_global,
                quadraticFalloff = lt.off_falloff,
            })
        elseif warning then
            table.insert(tab, {
                type = MATERIAL_LIGHT_POINT,
                color = lt.warn_color_vec,
                pos = lt.warn_pos_global,
                quadraticFalloff = lt.warn_falloff,
            })
        else -- power and no warning
            table.insert(tab, {
                type = MATERIAL_LIGHT_POINT,
                color = lt.color_vec,
                pos = lt.pos_global,
                quadraticFalloff = lt.falloff,
            })
        end
    end

    AddLightRenderTable(light)
    if lights and not TARDIS:GetSetting("extra-lights-disabled") then
        for _,l in pairs(lights) do
            AddLightRenderTable(l)
        end
    end

    if #tab==0 then
        render.SetLocalModelLights()
    else
        render.SetLocalModelLights(tab)
    end
end

local function postdraw_o(self)
    if not TARDIS:GetSetting("lightoverride-enabled") then return end
    if self.light_data.main == nil then return end
    render.SuppressEngineLighting(false)
end

ENT:AddHook("PreDraw", "customlighting", predraw_o)

ENT:AddHook("Draw", "customlighting", postdraw_o)

ENT:AddHook("PreDrawPart", "customlighting", predraw_o)

ENT:AddHook("DrawPart", "customlighting", postdraw_o)