
local S = mobs.intllib

mobs.igor_drops = {
	"vessels:glass_bottle", "mobs:meat_raw", "default:sword_steel",
	"farming:bread", "bucket:bucket_water"
}

mobs:register_mob("mobs_npc:igor", {
	type = "npc",
	passive = false,
	damage = 5,
	attack_type = "dogfight",
	owner_loyal = true,
	pathfinding = true,
	reach = 2,
	attacks_monsters = true,
	hp_min = 20,
	hp_max = 30,
	armor = 100,
	collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
	visual = "mesh",
	mesh = "mobs_character.b3d",
	textures = {
		{"mobs_igor.png"},  -- Skin by ruby32199
		{"mobs_igor2.png"},
		{"mobs_igor3.png"},
		{"mobs_igor4.png"},
		{"mobs_igor5.png"},
		{"mobs_igor6.png"},
		{"mobs_igor7.png"},
		{"mobs_igor8.png"},
	},
	makes_footstep_sound = true,
	sounds = {},
	walk_velocity = 1,
	run_velocity = 2,
	stepheight = 1.1,
	fear_height = 2,
	jump = true,
	drops = {
		{name = "mobs:meat_raw", chance = 1, min = 1, max = 2},
		{name = "default:gold_lump", chance = 3, min = 1, max = 1},
	},
	water_damage = 1,
	lava_damage = 3,
	light_damage = 0,
	follow = {"mobs:meat_raw", "default:diamond"},
	view_range = 15,
	owner = "",
	order = "follow",
	animation = {
		speed_normal = 30,
		speed_run = 30,
		stand_start = 0,
		stand_end = 79,
		walk_start = 168,
		walk_end = 187,
		run_start = 168,
		run_end = 187,
		punch_start = 200,
		punch_end = 219,
	},
	on_rightclick = function(self, clicker)
		-- Feed to tame or heal npc
		if mobs:feed_tame(self, clicker, 8, false, true) then return end
		-- Capture npc with net or lasso
		if mobs:capture_mob(self, clicker, nil, 5, 80, false, nil) then return end
		-- Protect npc with mobs:protector
		if mobs:protect(self, clicker) then return end
		-- Right clicking with gold lump gives random item
		if mobs.npc_drop(self, clicker, S("Igor"), self.igor_drops or mobs.igor_drops) then return end
		-- By right-clicking owner can switch npc between follow and stand
		mobs.npc_order(self, clicker, S("Igor"))
	end,
})

-- Register spawning abm
mobs:spawn({
	name = "mobs_npc:igor",
	nodes = {"default:stonebrick"},
	neighbors = {"group:grass"},
	min_light = 10,
	chance = 10000,
	min_height = 0,
})

-- Register spawn egg
mobs:register_egg("mobs_npc:igor", S("Igor"), "mobs_meat_raw.png", 1)

-- Compatibility
mobs:alias_mob("mobs:igor", "mobs_npc:igor")
