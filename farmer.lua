
local S = mobs.intllib

-- Create different skins from parts (total of 12 different skins)
local skins = {}
for a=1, 2 do
	for b=1, 3 do
		for c=1, 2 do
			table.insert(skins, {
				"(mobs_farmer_legs_"..a..".png"..
				"^mobs_farmer_shirt_"..b..".png)"..
				"^mobs_farmer_head_"..c..".png"
			})
		end
	end
end

-- Dirt and soil to convert and plant crops on
-- [dirt] = plantable soil
local soils = {
	["default:dirt"] = "farming:soil_wet",
	["farming:soil"] = "farming:soil_wet",
	["farming:soil_wet"] = "farming:soil_wet",
	["default:dry_dirt"] = "farming:dry_soil_wet",
	["farming:dry_soil"] = "farming:dry_soil_wet",
	["farming:dry_soil_wet"] = "farming:dry_soil_wet",
	-- For cocoa
	["default:jungletree"] = "default:jungletree",
}

-- Crops ready to harvest and replant
-- [ripe_plant] = {new_plant, seed_item, <extra_item>}
local crops = {
	["farming:artichoke_5"] = {"farming:artichoke_1", "farming:artichoke"},
	["farming:barley_7"] = {"farming:barley_1", "farming:seed_barley"},
	["farming:beanpole_5"] = {"farming:beanpole_1", "farming:beans", "farming:beanpole"},
	["farming:beetroot_5"] = {"farming:beetroot_1", "farming:beetroot"},
	["farming:blackberry_4"] = {"farming:blackberry_1", "farming:blackberry"},
	["farming:blueberry_4"] = {"farming:blueberry_1", "farming:blueberries"},
	["farming:cabbage_6"] = {"farming:cabbage_1", "farming:cabbage"},
	["farming:carrot_8"] = {"farming:carrot_1", "farming:carrot"},
	["farming:chili_8"] = {"farming:chili_1", "farming:chili_pepper"},
	["farming:cocoa_4"] = {"farming:cocoa_1", "farming:cocoa_beans"},
	["farming:coffee_5"] = {"farming:coffee_1", "farming:coffee_beans"},
	["farming:corn_8"] = {"farming:corn_1", "farming:corn"},
	["farming:cotton_8"] = {"farming:cotton_1", "farming:seed_cotton"},
	["farming:cucumber_4"] = {"farming:cucumber_1", "farming:cucumber"},
	["farming:garlic_5"] = {"farming:garlic_1", "farming:garlic_clove"},
	["farming:grapes_8"] = {"farming:grapes_1", "farming:grapes", "farming:trellis"},
	["farming:hemp_8"] = {"farming:hemp_1", "farming:seed_hemp"},
	["farming:lettuce_5"] = {"farming:lettuce_1", "farming:lettuce"},
	["farming:melon_8"] = {"farming:melon_1", "farming:melon_slice"},
	["farming:mint_4"] = {"farming:mint_1", "farming:seed_mint"},
	["farming:oat_8"] = {"farming:oat_1", "farming:seed_oat"},
	["farming:onion_5"] = {"farming:onion_1", "farming:onion"},
	["farming:parsley_3"] = {"farming:parsley_1", "farming:parsley"},
	["farming:pea_5"] = {"farming:pea_1", "farming:pea_pod"},
	["farming:pepper_5"] = {"farming:pepper_1", "farming:peppercorn"},
	["farming:pepper_6"] = {"farming:pepper_1", "farming:peppercorn"},
	["farming:pepper_7"] = {"farming:pepper_1", "farming:peppercorn"},
	["farming:pineapple_8"] = {"farming:pineapple_1", "farming:pineapple_top"},
	["farming:potato_4"] = {"farming:potato_1", "farming:potato"},
	["farming:pumpkin_8"] = {"farming:pumpkin_1", "farming:pumpkin_slice"},
	["farming:raspberry_4"] = {"farming:raspberry_1", "farming:raspberries"},
	["farming:rhubarb_3"] = {"farming:rhubarb_1", "farming:rhubarb"},
	["farming:rice_8"] = {"farming:rice_1", "farming:seed_rice"},
	["farming:rye_8"] = {"farming:rye_1", "farming:seed_rye"},
	["farming:soy_7"] = {"farming:soy_1", "farming:soy_pod"},
	["farming:sunflower_8"] = {"farming:sunflower_1", "farming:seed_sunflower"},
	["farming:tomato_8"] = {"farming:tomato_1", "farming:tomato"},
	["farming:wheat_8"] = {"farming:wheat_1", "farming:seed_wheat"},
	["farming:vanilla_8"] = {"farming:vanilla_1", "farming:vanilla"},
	-- Empty beanpole/trellis
	["farming:beanpole"] = {"farming:beanpole_1", "farming:beans", "farming:beanpole"},
	["farming:trellis"] = {"farming:grapes_1", "farming:grapes", "farming:trellis"},
}

-- Items that need to be crafted into seeds before planting
-- [item] = {{output1, amount1}, {output2, amount2}, ...}
local seed_crafts = {
	["farming:garlic"] = {{"farming:garlic_clove", 8}},
	["farming:melon_8"] = {{"farming:melon_slice", 4}},
	["farming:pepper"] = {{"farming:peppercorn", 1}},
	["farming:pepper_red"] = {{"farming:peppercorn", 1}},
	["farming:pepper_yellow"] = {{"farming:peppercorn", 1}},
	["farming:pineapple"] = {{"farming:pineapple_top", 1}, {"farming:pineapple_ring", 5}},
	["farming:pumpkin_8"] = {{"farming:pumpkin_slice", 4}},
	["farming:sunflower"] = {{"farming:seed_sunflower", 5}},
}

-- Lookup for the seed crafts
-- [seed] = {craft1, craft2, ...}
local craft_lookup = {}
for k,v in pairs(seed_crafts) do
	for _,i in pairs(v) do
		if craft_lookup[i[1]] then
			table.insert(craft_lookup[i[1]], k)
		else
			craft_lookup[i[1]] = {k}
		end
	end
end

-- Nodes to look for to replace
local look_for_nodes = {}
-- Seeds and items for planting
local seed_items = {}

for k in pairs(soils) do
	table.insert(look_for_nodes, k)
end
for k,v in pairs(crops) do
	table.insert(look_for_nodes, k)
	seed_items[v[2]] = true
	if v[3] then
		seed_items[v[3]] = true
	end
end
for k in pairs(seed_crafts) do
	seed_items[k] = true
end


local function add_to_inv(self, item, count)
	if not self.inv[item] then
		self.inv[item] = count
	else
		self.inv[item] = self.inv[item] + count
	end
end

local function remove_from_inv(self, item, count)
	self.inv[item] = self.inv[item] - count
	if self.inv[item] <= 0 then
		self.inv[item] = nil
	end
end

local function have_seed(self, seed)
	if self.inv[seed] then
		-- Have seed in inventory
		return true
	end
	if craft_lookup[seed] then
		for _,v in pairs(craft_lookup[seed]) do
			if self.inv[v] then
				-- Can craft seed
				return true
			end
		end
	end
	return false
end

local function use_seed(self, seed)
	if self.inv[seed] then
		-- Use seed from inventory
		remove_from_inv(self, seed, 1)
		return true
	end
	-- Find what seed can be crafted from
	if not craft_lookup[seed] then
		return false  -- No craft available
	end
	local crafts = {}
	for _,item in pairs(craft_lookup[seed]) do
		if self.inv[item] then
			table.insert(crafts, item)
		end
	end
	if #crafts > 0 then
		-- Craft seed
		local item = crafts[math.random(#crafts)]
		remove_from_inv(self, item, 1)  -- Take item used to craft
		for _,v in pairs(seed_crafts[item]) do
			add_to_inv(self, v[1], v[2])  -- Add items from crafting
		end
		remove_from_inv(self, seed, 1)  -- Take seed that was used
		return true
	end
	return false
end


local function plant_crop(self, pos, crop)
	if not crop then
		-- Find what farmer can plant
		local can_plant = {}
		for k,v in pairs(crops) do
			  -- Exclude cocoa, beanpole, and trellis
			if k ~= "farming:cocoa_4" and k ~= "farming:beanpole" and k ~= "farming:trellis" then
				-- Check if seeds are available
				if (not v[3] or self.inv[v[3]]) and have_seed(self, v[2]) then
					table.insert(can_plant, k)
				end
			end
		end
		if #can_plant == 0 then
			return false
		end
		-- Pick a random crop
		crop = can_plant[math.random(#can_plant)]
	end
	-- Plant the selected crop
	crop = crops[crop]
	if use_seed(self, crop[2]) then
		if crop[3] then
			-- Take the extra item (beanpole, trellis, etc)
			remove_from_inv(self, crop[3], 1)
		end
		minetest.set_node(pos, {name = crop[1]})
		return true
	end
	return false
end

local function find_nodes(pos)
	local pos1 = {x=pos.x-1, y=pos.y-1, z=pos.z-1}
	local pos2 = {x=pos.x+1, y=pos.y+1, z=pos.z+1}
	return minetest.find_nodes_in_area(pos1, pos2, look_for_nodes)
end

local function soil_below(pos, crop)
	local below_pos = {x=pos.x, y=pos.y-1, z=pos.z}
	local nn = minetest.get_node(below_pos).name
	if nn == "default:jungletree" then
		if crop == "farming:cocoa_4" then
			return true
		end
	elseif nn == "farming:dry_soil_wet" or nn == "farming:soil_wet" then
		return true
	end
	return false
end

local function air_above(pos)
	local above_pos = {x=pos.x, y=pos.y+1, z=pos.z}
	local nn = minetest.get_node(above_pos).name
	if nn == "air" then
		return true
	elseif nn == "ignore" then
		return false
	else
		local def = minetest.registered_nodes[nn]
		if def and def.drawtype == "airlike" and def.buildable_to then
			return true
		end
	end
	return false
end

local function is_near_water(pos)
	local pos1 = {x=pos.x+3, y=pos.y-1, z=pos.z+3}
	local pos2 = {x=pos.x-3, y=pos.y, z=pos.z-3}
	return #minetest.find_nodes_in_area(pos1, pos2, {"group:water"}) > 0
end

local function do_farming(self)
	-- Get position of node where farmer is standing
	local pos = self.object:get_pos()
	pos.y = pos.y - 0.5
	pos = vector.round(pos)
	-- Find a node near it
	for _,p in pairs(find_nodes(pos)) do
		local nn = minetest.get_node(p).name
		if crops[nn] then
			if soil_below(p, nn) then
				-- Harvest and add items to virtual inventory
				for _,i in pairs(minetest.get_node_drops(nn)) do
					local item = string.split(i, " ")
					add_to_inv(self, item[1], item[2] or 1)
				end
				-- Replant
				if plant_crop(self, p, nn) then
					minetest.sound_play("default_grass_footstep", {pos = p, gain = 1.0})
					return true
				end
			end
		elseif nn == "default:jungletree" and air_above(p) then
			-- Plant cocoa on jungletree
			p.y = p.y + 1
			if plant_crop(self, p, "farming:cocoa_4") then
				minetest.sound_play("default_place_node", {pos = p, gain = 1.0})
				return true
			end
		elseif air_above(p) and is_near_water(p) then
			-- Plant a crop
			p.y = p.y + 1
			if plant_crop(self, p) then
				minetest.sound_play("default_place_node", {pos = p, gain = 1.0})
				if soils[nn] ~= nn then
					-- Replace (hoe and wet) the soil
					p.y = p.y - 1
					minetest.set_node(p, {name = soils[nn]})
				end
				return true
			end
		end
	end
	return false
end


mobs:register_mob("mobs_npc:farmer", {
	type = "npc",
	passive = false,
	damage = 3,
	attack_type = "dogfight",
	attacks_monsters = true,
	attack_animals = false,
	attack_npcs = false,
	pathfinding = true,
	hp_min = 10,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
	visual = "mesh",
	mesh = "mobs_character.b3d",
	textures = skins,
	makes_footstep_sound = true,
	sounds = {},
	walk_velocity = 1,
	run_velocity = 2,
	jump = true,
	drops = nil,  -- No drops because items are dropped in custom on_die function
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	follow = {"default:apple", "default:diamond"},
	view_range = 10,  -- Less view range because it's used for `stay_near` searching
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
	stay_near = {look_for_nodes, 10},  -- Makes the farmer go towards nodes to "farm"
	on_rightclick = function(self, clicker)
		-- Feed to tame or heal npc
		if mobs:feed_tame(self, clicker, 8, false, true) then return end
		-- Capture npc with net or lasso
		if mobs:capture_mob(self, clicker, nil, 5, 80, false, nil) then return end
		-- Lock or unlock by right-clicking with paper
		if mobs.npc_lock(self, clicker, S("Farmer")) then return end
		-- Protect npc with mobs:protector
		if mobs:protect(self, clicker) then return end
		-- Right clicking with seeds gives them to the farmer
		local item = clicker:get_wielded_item()
		local item_name = item:get_name()
		local player = clicker:get_player_name()
		if seed_items[item_name] then
			add_to_inv(self, item_name, 1)
			if not mobs.is_creative(player) then
				item:take_item()
				clicker:set_wielded_item(item)
			end
			return
		end
		-- Right clicking with gold lump gives some of the farmed items
		if item_name == "default:gold_lump" then
			if self.locked and self.owner and self.owner ~= player then
				minetest.chat_send_player(player, S("@1 is owner!", self.owner))
				return
			end
			if not mobs.is_creative(player) then
				item:take_item()
				clicker:set_wielded_item(item)
			end
			local name, count = next(self.inv or {})
			if name and count then
				count = math.min(count, ItemStack(name):get_stack_max())
				mobs.give_to_player(clicker, name.." "..count)
				remove_from_inv(self, name, count)
			end
			return
		end
		-- By right-clicking owner can switch npc between follow and stand
		mobs.npc_order(self, clicker, S("Farmer"))
	end,
	do_custom = function(self, dtime)
		if not self.inv then
			self.inv = {}
			self.farming_timer = 5
			return
		end
		self.farming_timer = self.farming_timer - dtime
		if self.farming_timer <= 0 then
			if do_farming(self) then
				-- Something was "farmed", likely there is more, so check again soon
				self.farming_timer = math.random(1, 3)
			else
				-- Nothing "farmed", check again later
				self.farming_timer = math.random(5, 15)
			end
		end
	end,
	on_die = function(self, pos)
		-- Items that will be dropped
		local to_drop = {}
		-- Random hoe
		local hoes = {"farming:hoe_wood", "farming:hoe_stone", "farming:hoe_steel"}
		table.insert(to_drop, {hoes[math.random(3)], 1})
		-- Some gold lumps
		table.insert(to_drop, {"default:gold_lump", math.random(5)})
		-- Most of the items in inventory
		for item, count in pairs(self.inv or {}) do
			if count < 10 then
				table.insert(to_drop, {item, count})
			else
				table.insert(to_drop, {item, math.random(math.ceil(count / 2), count)})
			end
		end
		-- Drop all the items
		local item, count, drop_count, obj
		for _,v in pairs(to_drop) do
			item = v[1]
			count = v[2]
			-- Separate stacks for count greater than max
			while count > 0 do
				drop_count = math.min(count, ItemStack(item):get_stack_max())
				obj = minetest.add_item(pos, {name = item, count = drop_count})
				-- Add random velocity (same as normal mob drops)
				if obj and obj:get_luaentity() then
					obj:set_velocity({
						x = math.random(-10, 10) / 9,
						y = 6,
						z = math.random(-10, 10) / 9
					})
				elseif obj then
					obj:remove()  -- Item does not exist
				end
				count = count - drop_count
			end
		end
	end,
})

-- Register spawning abm
mobs:spawn({
	name = "mobs_npc:farmer",
	nodes = {"default:desert_stonebrick"},
	neighbors = {"group:grass"},
	min_light = 10,
	chance = 10000,
	min_height = 0,
	day_toggle = true,
	active_object_count = 2,
})

-- Register spawn egg
mobs:register_egg("mobs_npc:farmer", S("Farmer"), "default_coniferous_litter.png", 1)

-- Override melon and pumpkin so they don't suffocate farmer
for _,n in pairs({"farming:melon_8", "farming:pumpkin_8"}) do
	local def = minetest.registered_nodes[n]
	if def then
		local groups = table.copy(def.groups or {})
		groups.disable_suffocation = 1
		minetest.override_item(n, {
		  groups = groups
		})
	end
end
