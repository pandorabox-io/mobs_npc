
-- example

-- {"default:obsidian 10", "default:gold_ingot", 5, 10, 30, 40, nil}
--[[{
	"default:obsidian 10", -- item = what will be traded, as an itemstack string.
	"default:gold_ingot", -- currency = what will used as payment, as an item string.
	5, -- min price = minimum anount of currency, as a whole number greater than 0, less than or equal to max price.
	10, -- max price = maximum anount of currency, as a whole number greater than 0, greater than or equal to min price.
	30, -- daily stock = how many times the item can be traded each day, as a whole number greater than 0.
	40, -- rarity = how likely the item will be pick as a trade, as a whole number between 0-100 (higher is more rare).
	nil -- is reverse = whether the trade will be reversed, false for never, true for always, nil for random.
}]]


-- items grouped by mod

local mod_items = {}

-- https://github.com/minetest/minetest_game/tree/master/mods/default
mod_items.default = {
	{"default:sapling 1", "default:gold_ingot", 1, 3, 10, 20, false},
	{"default:acacia_sapling 1", "default:gold_ingot", 1, 3, 10, 20, false},
	{"default:aspen_sapling 1", "default:gold_ingot", 1, 3, 10, 20, false},
	{"default:junglesapling 1", "default:gold_ingot", 1, 3, 10, 20, false},
	{"default:pine_sapling 1", "default:gold_ingot", 1, 3, 10, 20, false},
	{"default:bush_sapling 1", "default:gold_ingot", 2, 4, 10, 40, false},
	{"default:acacia_bush_sapling 1", "default:gold_ingot", 2, 4, 10, 40, false},
	{"default:blueberry_bush_sapling 1", "default:gold_ingot", 2, 4, 10, 40, false},
	{"default:pine_bush_sapling 1", "default:gold_ingot", 2, 4, 10, 40, false},
	{"default:large_cactus_seedling 1", "default:gold_ingot", 2, 5, 10, 40, false},

	{"default:dirt_with_grass 10", "default:gold_ingot", 5, 10, 20, 40, false},
	{"default:dirt_with_snow 10", "default:gold_ingot", 5, 10, 20, 40, false},
	{"default:dirt_with_dry_grass 10", "default:gold_ingot", 5, 10, 20, 40, false},
	{"default:dry_dirt_with_dry_grass 10", "default:gold_ingot", 5, 10, 20, 40, false},
	{"default:dirt_with_coniferous_litter 10", "default:gold_ingot", 5, 10, 20, 50, false},
	{"default:dirt_with_rainforest_litter 10", "default:gold_ingot", 5, 10, 20, 50, false},

	{"default:coral_cyan 1", "default:gold_ingot", 1, 3, 20, 40, nil},
	{"default:coral_green 1", "default:gold_ingot", 1, 3, 20, 40, nil},
	{"default:coral_pink 1", "default:gold_ingot", 1, 3, 20, 40, nil},
	{"default:coral_skeleton 1", "default:gold_ingot", 1, 3, 20, 40, nil},
	{"default:coral_brown 1", "default:gold_ingot", 2, 4, 20, 50, false},
	{"default:coral_orange 1", "default:gold_ingot", 2, 4, 20, 50, false},
	{"default:sand_with_kelp 1", "default:gold_ingot", 1, 3, 20, 30, nil},

	{"default:clay 20", "default:gold_ingot", 5, 10, 20, 20, nil},
	{"default:desert_sandstone 20", "default:gold_ingot", 2, 5, 50, 20, nil},
	{"default:silver_sandstone 20", "default:gold_ingot", 2, 5, 50, 20, nil},
	{"default:sandstone 20", "default:gold_ingot", 1, 4, 50, 10, nil},
	{"default:obsidian 10", "default:gold_ingot", 5, 10, 30, 40, nil},

	{"default:apple 10", "default:gold_ingot", 1, 3, 10, 5, false},
	{"default:blueberries 10", "default:gold_ingot", 2, 4, 10, 20, false},
	{"default:book 1", "default:gold_ingot", 1, 3, 10, 20, false},
	{"default:brick 10", "default:gold_ingot", 2, 5, 20, 30, false},

	{"default:copper_ingot 5", "default:gold_ingot", 3, 7, 20, 10, nil},
	{"default:steel_ingot 5", "default:gold_ingot", 3, 7, 20, 10, nil},
	{"default:tin_ingot 5", "default:gold_ingot", 3, 7, 20, 10, nil},
	{"default:coal_lump 5", "default:gold_ingot", 5, 10, 20, 10, nil},
	{"default:diamond 1", "default:gold_ingot", 10, 15, 20, 30, nil},
	{"default:mese_crystal 2", "default:gold_ingot", 5, 15, 20, 20, nil},

	{"default:stone_with_copper 5", "default:gold_ingot", 10, 15, 4, 50, false},
	{"default:stone_with_iron 5", "default:gold_ingot", 10, 15, 4, 50, false},
	{"default:stone_with_tin 5", "default:gold_ingot", 10, 15, 4, 50, false},
	{"default:stone_with_gold 5", "default:gold_ingot", 10, 15, 4, 50, false},
	{"default:stone_with_coal 5", "default:gold_ingot", 10, 15, 4, 50, false},
	{"default:stone_with_diamond 1", "default:gold_ingot", 15, 20, 20, 70, false},
	{"default:stone_with_mese 2", "default:gold_ingot", 10, 20, 10, 60, false},
}

-- https://github.com/minetest/minetest_game/tree/master/mods/bucket
mod_items.bucket = {
	{"bucket:bucket_water 1", "default:gold_ingot", 1, 3, 20, 10, nil},
	{"bucket:bucket_river_water 1", "default:gold_ingot", 2, 4, 20, 20, nil},
	{"bucket:bucket_lava 1", "default:gold_ingot", 3, 5, 20, 30, nil},

	{"bucket:bucket_empty 5", "default:gold_ingot", 1, 4, 20, 20, nil},
}

-- https://notabug.org/TenPlus1/farming
mod_items.farming = {
	{"default:gold_ingot 1", "farming:beans", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:beetroot", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:blueberries", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:cabbage", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:carrot", 1, 5, 20, 10, true},
	{"default:gold_ingot 1", "farming:chili_pepper", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:cocoa_beans", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:coffee_beans", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:corn", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:cucumber", 1, 5, 20, 10, true},
	{"default:gold_ingot 1", "farming:garlic", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:grapes", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:onion", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:pea_pod", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:pepper", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:potato", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:raspberries", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:rhubarb", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:seed_barley", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:seed_cotton", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:seed_hemp", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:seed_mint", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:seed_oat", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:seed_rice", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:seed_rye", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:seed_wheat", 1, 5, 10, 40, true},
	{"default:gold_ingot 1", "farming:tomato", 1, 5, 20, 10, true},

	{"farming:melon_8 1", "default:gold_ingot", 1, 3, 10, 40, false},
	{"farming:pumpkin_8 1", "default:gold_ingot", 1, 3, 10, 40, false},
	{"farming:pineapple 1", "default:gold_ingot", 3, 6, 10, 50, false},

	{"ethereal:banana 1", "default:gold_ingot", 10, 30, 10, 70, nil},
	{"ethereal:orange 1", "default:gold_ingot", 10, 30, 10, 50, nil},
	{"ethereal:strawberry 1", "default:gold_ingot", 10, 30, 10, 50, nil},

	{"farming:baked_potato 10", "default:gold_ingot", 1, 3, 10, 10, false},
	{"farming:bread 10", "default:gold_ingot", 1, 3, 10, 5, false},
	{"farming:chocolate_dark 5", "default:gold_ingot", 1, 3, 10, 20, false},
	{"farming:carrot_gold 5", "default:gold_ingot", 1, 3, 10, 20, false},
	{"farming:straw 10", "default:gold_ingot", 1, 3, 10, 20, nil},
}

-- https://github.com/minetest-mods/moreores
mod_items.moreores = {
	{"moreores:silver_ingot 5", "default:gold_ingot", 15, 20, 20, 30, nil},
	{"moreores:mithril_ingot 1", "default:gold_ingot", 15, 25, 20, 40, nil},

	{"moreores:mineral_silver 5", "default:gold_ingot", 30, 40, 4, 70, false},
	{"moreores:mineral_mithril 1", "default:gold_ingot", 20, 30, 20, 80, false},
}

-- https://gitlab.com/VanessaE/moretrees
mod_items.moretrees = {
	{"moretrees:beech_sapling 1", "default:gold_ingot", 1, 3, 10, 30, false},
	{"moretrees:apple_tree_sapling 1", "default:gold_ingot", 1, 3, 10, 30, false},
	{"moretrees:oak_sapling 1", "default:gold_ingot", 1, 3, 10, 30, false},
	{"moretrees:sequoia_sapling 1", "default:gold_ingot", 1, 3, 10, 30, false},
	{"moretrees:birch_sapling 1", "default:gold_ingot", 1, 3, 10, 30, false},
	{"moretrees:palm_sapling 1", "default:gold_ingot", 1, 3, 10, 30, false},
	{"moretrees:date_palm_sapling 1", "default:gold_ingot", 1, 3, 10, 30, false},
	{"moretrees:spruce_sapling 1", "default:gold_ingot", 1, 3, 10, 30, false},
	{"moretrees:cedar_sapling 1", "default:gold_ingot", 1, 3, 10, 30, false},
	{"moretrees:poplar_sapling 1", "default:gold_ingot", 1, 3, 10, 30, false},
	{"moretrees:poplar_small_sapling 1", "default:gold_ingot", 1, 3, 10, 30, false},
	{"moretrees:willow_sapling 1", "default:gold_ingot", 1, 3, 10, 30, false},
	{"moretrees:rubber_tree_sapling 1", "default:gold_ingot", 1, 3, 10, 30, false},
	{"moretrees:fir_sapling 1", "default:gold_ingot", 1, 3, 10, 30, false},

	{"default:gold_ingot 1", "moretrees:acorn", 10, 20, 20, 40, nil},
	{"default:gold_ingot 1", "moretrees:cedar_cone", 10, 20, 20, 40, nil},
	{"default:gold_ingot 1", "moretrees:fir_cone", 10, 20, 20, 40, nil},
	{"default:gold_ingot 1", "moretrees:spruce_cone", 10, 20, 20, 40, nil},
	{"default:gold_ingot 2", "moretrees:date", 10, 20, 10, 40, nil},
	{"default:gold_ingot 2", "moretrees:coconut", 10, 20, 10, 40, nil},
}

-- https://github.com/runsy/cool_trees/tree/master/cherrytree
mod_items.cherrytree = {
	{"cherrytree:sapling 1", "default:gold_ingot", 1, 3, 10, 30, false},
	{"cherrytree:cherries 5", "default:gold_ingot", 8, 10, 5, 50, nil},
}

-- https://notabug.org/TenPlus1/mobs_redo
mod_items.mobs = {
	{"mobs:leather 1", "default:gold_ingot", 1, 3, 20, 20, nil},
	{"mobs:meat_raw 5", "default:gold_ingot", 2, 4, 20, 10, nil},
	{"default:gold_ingot 1", "mobs:nametag", 1, 5, 10, 20, true},
}

-- https://notabug.org/TenPlus1/mobs_animal
mod_items.mobs_animal = {
	{"mobs:chicken_feather 1", "default:gold_ingot", 2, 5, 5, 50, nil},
	{"mobs:chicken_raw 1", "default:gold_ingot", 1, 3, 10, 50, nil},
	{"mobs:egg 12", "default:gold_ingot", 2, 5, 10, 40, nil},
	{"mobs:bucket_milk 1", "default:gold_ingot", 1, 3, 20, 40, nil},
	{"mobs:mutton_raw 2", "default:gold_ingot", 1, 3, 10, 50, nil},
	{"mobs:pork_raw 3", "default:gold_ingot", 1, 4, 10, 50, nil},
	{"mobs:rabbit_hide 1", "default:gold_ingot", 1, 3, 10, 50, nil},
	{"mobs:rabbit_raw 2", "default:gold_ingot", 1, 3, 10, 50, nil},
	{"mobs:beehive 1", "default:gold_ingot", 15, 20, 1, 50, nil},

	{"mobs_animal:rat 1", "default:gold_ingot", 5, 10, 10, 30, nil},
	{"mobs_animal:bunny_set 1", "default:gold_ingot", 10, 20, 2, 70, nil},
	{"mobs_animal:chicken_set 1", "default:gold_ingot", 10, 20, 2, 60, nil},
	{"mobs_animal:cow_set 1", "default:gold_ingot", 15, 25, 2, 70, nil},
	{"mobs_animal:kitten_set 1", "default:gold_ingot", 20, 30, 2, 80, nil},
	{"mobs_animal:panda_set 1", "default:gold_ingot", 20, 30, 2, 80, nil},
	{"mobs_animal:penguin_set 1", "default:gold_ingot", 20, 30, 2, 80, nil},
	{"mobs_animal:pumba_set 1", "default:gold_ingot", 20, 30, 2, 80, nil},
	{"mobs_animal:sheep_white_set 1", "default:gold_ingot", 10, 20, 2, 60, nil},
}

-- https://notabug.org/TenPlus1/mobs_water/src/master/mobs_fish
mod_items.mobs_fish = {
	{"mobs_fish:clownfish 1", "default:gold_ingot", 10, 20, 10, 50, nil},
	{"mobs_fish:tropical 1", "default:gold_ingot", 10, 20, 10, 50, nil},
}

-- https://notabug.org/TenPlus1/mobs_water/src/master/mobs_turtles
mod_items.mobs_turtles = {
	{"mobs_turtles:turtle_set 1", "default:gold_ingot", 15, 25, 2, 70, nil},
	{"mobs_turtles:seaturtle_set 1", "default:gold_ingot", 15, 25, 2, 70, nil},
}

-- https://github.com/pandorabox-io/planet_mars
mod_items.planet_mars = {
	{"planet_mars:blackmarble 10", "default:gold_ingot", 5, 10, 30, 50, nil},
	{"planet_mars:bluemarble 10", "default:gold_ingot", 5, 10, 30, 50, nil},
	{"planet_mars:redmarble 10", "default:gold_ingot", 5, 10, 30, 50, nil},

	{"planet_mars:stone_with_copper 5", "default:gold_ingot", 10, 15, 4, 60, false},
	{"planet_mars:stone_with_iron 5", "default:gold_ingot", 10, 15, 4, 60, false},
	{"planet_mars:stone_with_tin 5", "default:gold_ingot", 10, 15, 4, 60, false},
	{"planet_mars:stone_with_gold 5", "default:gold_ingot", 10, 15, 4, 60, false},
	{"planet_mars:stone_with_coal 5", "default:gold_ingot", 10, 15, 4, 60, false},
	{"planet_mars:stone_with_diamond 1", "default:gold_ingot", 15, 20, 20, 80, false},
	{"planet_mars:stone_with_mese 2", "default:gold_ingot", 10, 20, 10, 70, false},
}

-- https://github.com/mt-mods/technic
mod_items.technic = {
	{"technic:granite 10", "default:gold_ingot", 5, 10, 30, 30, nil},
	{"technic:marble 10", "default:gold_ingot", 5, 10, 30, 30, nil},
	{"technic:raw_latex 10", "default:gold_ingot", 1, 5, 20, 20, nil},

	{"technic:chromium_ingot 5", "default:gold_ingot", 2, 10, 20, 30, nil},
	{"technic:lead_ingot 5", "default:gold_ingot", 4, 10, 20, 30, nil},
	{"technic:uranium_ingot 5", "default:gold_ingot", 10, 20, 20, 30, nil},
	{"technic:zinc_ingot 5", "default:gold_ingot", 2, 10, 20, 30, nil},
	{"technic:sulfur_lump 5", "default:gold_ingot", 2, 10, 20, 30, nil},

	{"technic:mineral_chromium 5", "default:gold_ingot", 10, 15, 4, 60, false},
	{"technic:mineral_lead 5", "default:gold_ingot", 10, 15, 4, 60, false},
	{"technic:mineral_uranium 5", "default:gold_ingot", 20, 30, 4, 60, false},
	{"technic:mineral_zinc 5", "default:gold_ingot", 10, 15, 4, 60, false},
	{"technic:mineral_sulfur 5", "default:gold_ingot", 10, 15, 4, 60, false},
}

-- check for each of the mods, and add it's items if it exists
for k,v in pairs(mod_items) do
	if minetest.get_modpath(k) and #v > 0 then
		for i=1, #v do
			mobs.trader.items[#mobs.trader.items + 1] = v[i]
		end
	end
end


-- individual items

local items = {
	-- https://github.com/mt-mods/redwood
	["redwood:redwood_sapling"] = {"redwood:redwood_sapling 1", "default:gold_ingot", 2, 4, 10, 30, false},
	-- https://github.com/runsy/cool_trees/tree/master/bamboo
	["bamboo:sprout"] = {"bamboo:sprout 1", "default:gold_ingot", 2, 4, 10, 30, false},
	-- https://github.com/Lokrates/Biofuel
	["biofuel:fuel_can"] = {"biofuel:fuel_can 10", "default:gold_ingot", 1, 4, 10, 10, nil},
	-- https://github.com/Calinou/bedrock
	["bedrock:deepstone"] = {"bedrock:deepstone 10", "default:gold_ingot", 20, 30, 10, 60, false},
	-- https://notabug.org/TenPlus1/mobs_water/src/master/mobs_jellyfish
	["mobs_jellyfish:jellyfish"] = {"mobs_jellyfish:jellyfish 1", "default:gold_ingot", 5, 10, 10, 60, nil},
	-- https://notabug.org/TenPlus1/mob_horse
	["mob_horse:horse_set"] = {"mob_horse:horse_set 1", "default:gold_ingot", 20, 30, 2, 80, nil},
	-- https://github.com/pandorabox-io/pandorabox_custom
	["pandorabox_custom:panda_viking_set"] = {"pandorabox_custom:panda_viking_set 1","default:gold_ingot",20,30,2,80,nil},
}

-- check for each individual item, and add it if it exists
for k,v in pairs(items) do
	if minetest.registered_items[k] then
		mobs.trader.items[#mobs.trader.items + 1] = v
	end
end


-- check that all trade items are good to use after all mods have been loaded

local function is_valid_trade(i, t)

	local item = type(t[1]) == "string" and t[1]:split(" ") or nil

	if not item or not minetest.registered_items[item[1]] or not tonumber(item[2]) or tonumber(item[2]) <= 0 then
		return false, "trade #".. i .." item is invalid"
	end

	if type(t[2]) ~= "string" or not minetest.registered_items[t[2]] then
		return false, "trade #".. i .." currency is invalid"
	end

	if type(t[3]) ~= "number" or type(t[4]) ~= "number" or t[3] > t[4] or t[3] < 1 or t[4] < 1 then
		return false, "trade #".. i .." price is invalid"
	end

	if type(t[5]) ~= "number" or t[5] < 1 then
		return false, "trade #".. i .." stock is invalid"
	end

	if type(t[6]) ~= "number" or t[6] < 0 or t[6] > 100 then
		return false, "trade #".. i .." rarity is invalid"
	end

	if t[7] and type(t[7]) ~= "boolean" then
		return false, "trade #".. i .." direction is invalid"
	end

	return true, nil
end

minetest.register_on_mods_loaded(function()
	for k,v in pairs(mobs.trader.items) do
		local valid, err_msg = is_valid_trade(k, v)

		if not valid then
			minetest.log("error", "[mobs_npc] ".. err_msg)
			minetest.log("action", "[mobs_npc] removing trade: ".. dump(v))
			table.remove(mobs.trader.items, k)
		end
	end
end)
