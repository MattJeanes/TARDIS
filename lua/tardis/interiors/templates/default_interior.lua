local n = 5

local lp = Vector(197, 0, 340)
local la = Angle(86.8, 0, 90)
local up = Vector(0,0,1)

local v0 = Vector(0,0,0)
local a0 = Angle(0,0,0)

local ra = 360 / n

local lamp_positions = {}
for i = 1,n do
	lamp_positions[i] = { pos = v0 + lp, ang = a0 + la, }
	lp:Rotate(Angle(0,ra,0))
	la:RotateAroundAxis(up, ra)
end

local lamps = {}

for i = 1,n do
	lamps[i] = {
		color = Color(255, 255, 230),
		texture = "effects/flashlight/soft",
		fov = 165,
		distance = 290,
		brightness = 0.5,
		shadows = false,
		pos = lamp_positions[i].pos,
		ang = lamp_positions[i].ang,
		states = {
			["normal"] = {
				enabled = true,
			},
			["teleport"] = {
				enabled = false,
			},
		},
	}
end


TARDIS:AddInteriorTemplate("default_lamps", {
	Interior = {
		LightOverride = {
			basebrightness = 0.005,
		},
		Lamps = lamps,
	},
	CustomHooks = {
		lamps_toggle = {
			exthooks = {
				["DematStart"] = true,
				["StopMat"] = true,
			},
			func = function(ext,int)
				if SERVER then return end
				if not IsValid(int) then return end

				if ext:GetData("demat") then
					int:ApplyLightState("teleport")
				else
					int:ApplyLightState("normal")
				end
			end,
		},
	},
})

TARDIS:AddInteriorTemplate("default_dynamic_color", {
	CustomHooks = {
		int_color = {
			inthooks = { ["Think"] = true },
			func = function(ext,int,frame_time)
				if not IsValid(int) then return end

				if SERVER then
					local speed = 0.001
					local start_colors = { 0, 0.5, 0.5, 0.5, 1 }

					local k = ext:GetData("default_int_color_mult", start_colors[math.random(#start_colors)])
					local target = ext:GetData("default_int_color_target")
					if not target then
						target = math.random(2) - 1
						ext:SetData("default_int_color_target", target)
					end

					k = math.Approach(k, target, frame_time * speed)

					ext:SetData("default_int_color_mult", k, true)
					if k == target then
						ext:SetData("default_int_color_target", 1 - target, true)
					end
				end
			end,
		},
	},
})

local function get_color_setting_k(ply)
	local st = TARDIS:GetCustomSetting("default", "color", ply)

	if st == "blue" then
		return 0
	end
	if st == "green" then
		return 1
	end
	if st == "turquoise" then
		return 0.5
	end
	if st == "random" then
		return math.Rand(0,1)
	end
	return 0
end

TARDIS:AddInteriorTemplate("default_fixed_color", {
	CustomHooks = {
		int_color = {
			inthooks = {
				["PostInitialize"] = true
			},
			func = function(ext,int,frame_time)
				if CLIENT then return end

				local k = get_color_setting_k(ext:GetCreator())
				int:SetData("default_int_color_mult", k, true)
			end,
		},
	},
})

local function change_light_color(lt, col)
    if lt and lt.brightness and col then
        lt.color = col
        lt.color_vec = Vector(col.r/255, col.g/255, col.b/255) * lt.brightness
        lt.render_table.color = lt.color_vec
    end
end

local function set_interior_color(int, k)
	if not int.light_data then return end

	local p = 1 - k

	-- Color(0,180,255) ... Color(0,235,200)
	local col = Color(0, 180 + 55 * k, 200 + 55 * p)

	int:SetData("default_int_env_color", col)

	change_light_color(int.light_data.main, col)
	change_light_color(int.light_data.extra.console_bottom, col)

	-- Color(80, 120, 255) ... Color (80, 255, 120)
	local rotor_col = Color(80, 120 + 125 * k, 120 + 125 * p)
	int:SetData("default_int_rotor_color", rotor_col)

	-- Color(240,240,255) ... Color(255,255,200)
	local console_col = Color(240 + 15 * k, 240 + 15 * k, 200 + 55 * p)
	change_light_color(int.light_data.extra.console_white, console_col)

	-- Color(255,255,255) ... Color(255,255,220)
	local floor_lights_col = Color(255, 255, 220 + 20 * p)
	int:SetData("default_int_floor_lights_color", floor_lights_col)

	int:SetData("default_int_color_set_mult", k)
end

TARDIS:AddInteriorTemplate("default_color_update", {
	CustomHooks = {
		int_color_update = {
			inthooks = { ["Think"] = true },
			func = function(ext,int,frame_time)
				if SERVER or not IsValid(int) then return end

				local k = int:GetData("default_int_color_mult")
				if not k then return end

				if k ~= int:GetData("default_int_color_set_mult") then
					set_interior_color(int, k)
				end
			end,
		},
	},
})