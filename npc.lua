
local S = mobs.intllib

mobs.npc_drops = {
	"default:pick_steel", "mobs:meat", "default:sword_steel",
	"default:shovel_steel", "farming:bread", "bucket:bucket_water"
}

mobs:register_mob("mobs_npc:npc", {
	type = "npc",
	passive = false,
	damage = 3,
	attack_type = "dogfight",
	attacks_monsters = true,
	attack_npcs = false,
	owner_loyal = true,
	pathfinding = true,
	hp_min = 10,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
	visual = "mesh",
	mesh = "mobs_character.b3d",
	textures = {
		{"mobs_npc.png"},
		{"mobs_npc2.png"},  -- Female skin by nuttmeg20
	},
	child_texture = {
		{"mobs_npc_baby.png"},  -- Derpy baby skin by AmirDerAssassine
	},
	makes_footstep_sound = true,
	sounds = {},
	walk_velocity = 2,
	run_velocity = 3,
	jump = true,
	drops = {
		{name = "default:wood", chance = 1, min = 1, max = 3},
		{name = "default:apple", chance = 2, min = 1, max = 2},
		{name = "default:axe_stone", chance = 5, min = 1, max = 1},
	},
	water_damage = 0,
	lava_damage = 2,
	light_damage = 0,
	follow = {"farming:bread", "mobs:meat", "default:diamond"},
	view_range = 15,
	owner = "",
	order = "follow",
	fear_height = 3,
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
		if mobs:feed_tame(self, clicker, 8, true, true) then return end
		-- Capture npc with net or lasso
		if mobs:capture_mob(self, clicker, nil, 5, 80, false, nil) then return end
		-- Protect npc with mobs:protector
		if mobs:protect(self, clicker) then return end
		-- Right clicking with gold lump gives random item
		if mobs.npc_drop(self, clicker, S("NPC"), self.npc_drops or mobs.npc_drops) then return end
		-- By right-clicking owner can switch npc between follow and stand
		mobs.npc_order(self, clicker, S("NPC"))
	end,
})

-- Register spawning abm
mobs:spawn({
	name = "mobs_npc:npc",
	nodes = {"default:brick"},
	neighbors = {"group:grass"},
	min_light = 10,
	chance = 10000,
	min_height = 0,
	day_toggle = true,
})

-- Register spawn egg
mobs:register_egg("mobs_npc:npc", S("Npc"), "default_brick.png", 1)

-- Compatibility
mobs:alias_mob("mobs:npc", "mobs_npc:npc")
