-- These are not configured by user directly, but used to store data

-- Interior-specific settings
TARDIS:AddSetting({
    id = "interior_custom_settings",
    type="table",
    value = {},

    class="networked",
    networked = true,

    option = false,
})

-- Used by "Select for redecoration"
TARDIS:AddSetting({
    id="redecorate-interior",
    type="text",
    value=false,

    class="networked",
    networked=true,

    option = false,
})

-- Helps to keep the folded/unfolded subsections in the settings
TARDIS:AddSetting({
    id = "options-unfolded-subsections",
    type="table",
    value = {},

    class="local",
    networked = false,

    option = false,
})

-- "Don't Show Again" button (cl_prompts.lua)
TARDIS:AddSetting({
    id="light_override_prompt_noshow",
    type="bool",
    value=false,

    class="local",
    networked = false,

    option = false,
})