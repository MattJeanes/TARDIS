-- These are not configured by user directly, but used to store data

-- Interior-specific settings
TARDIS:AddSetting({
    id = "interior_custom_settings",
	type="table",
    value = {},
    option = false,
    networked = true
})

-- Used by "Select for redecoration"
TARDIS:AddSetting({
    id="redecorate-interior",
	type="text",
    value=false,
	option = false,
    networked=true
})

-- Helps to keep the folded/unfolded subsections in the settings
TARDIS:AddSetting({
    id = "options-unfolded-subsections",
	type="table",
    value = {},
    option = false,
    networked = false,
})

-- "Don't Show Again" button (cl_prompts.lua)
TARDIS:AddSetting({
    id="light_override_prompt_noshow",
    type="bool",
    value=false,
	option = false,
	networked = false,
})