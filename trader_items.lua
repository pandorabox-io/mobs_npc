
mobs.trader.items = {
	-- {item, currency, min price, max price, daily stock, rarity}
	{"default:apple 10",			"default:gold_ingot",		1,		3,		30,		10},
	{"farming:bread 10",			"default:gold_ingot",		1,		4,		30,		5},
	{"default:clay 10",				"default:gold_ingot",		2,		5,		100,	12},
	{"default:brick 10",			"default:gold_ingot",		2,		6,		100,	17},
	{"default:glass 10",			"default:gold_ingot",		1,		4,		100,	17},
	{"default:obsidian 10",			"default:gold_ingot",		5,		15,		60,		50},
	{"default:diamond 1",			"default:mese_crystal",		1,		3,		25,		40},
	{"default:diamond 1",			"default:gold_ingot",		5,		10,		25,		40},
	{"farming:wheat 10",			"default:gold_ingot",		1,		4,		50,		17},
	{"default:tree 10",				"default:gold_ingot",		1,		4,		80,		20},
	{"default:stone 20",			"default:gold_ingot",		1,		3,		100,	17},
	{"default:desert_stone 10",		"default:gold_ingot",		1,		4,		100,	27},
	{"default:sapling 5",			"default:gold_ingot",		1,		3,		30,		7},
	{"default:pick_steel 1",		"default:gold_ingot",		1,		4,		10,		7},
	{"default:sword_steel 1",		"default:gold_ingot",		1,		3,		10,		17},
	{"default:shovel_steel 1",		"default:gold_ingot",		1,		3,		10,		17},
	{"default:cactus 5",			"default:gold_ingot",		2,		5,		30,		40},
	{"default:papyrus 10",			"default:gold_ingot",		2,		6,		50,		40},
	{"default:mese_crystal 1",		"default:dirt_with_grass",	6,		10,		30,		90},
	{"default:mese_crystal 1",		"default:gold_ingot",		3,		6,		30,		80},
	{"default:sandstone 10",		"default:gold_ingot",		1,		4,		80,		20},
	{"default:dirt 10",				"default:gravel",			8,		12,		80,		15},
	{"default:dirt 10",				"default:gold_ingot",		1,		3,		80,		10},
	{"bucket:bucket_water 1",		"default:gold_ingot",		1,		3,		10,		20},
	{"bucket:bucket_river_water 1",	"default:gold_ingot",		2,		4,		10,		30},
	{"bucket:bucket_lava 1",		"default:gold_ingot",		3,		8,		10,		50},
}

-- check that all trade items are good to use

local function is_valid_trade(i, t)

	local item = type(t[1]) == "string" and t[1]:split(" ") or nil

	if not item or not minetest.registered_items[item[1]] or not tonumber(item[2]) or tonumber(item[2]) <= 0 then
		return false, "trade #".. i .." item is invalid"
	end

	if not type(t[2]) == "string" or not minetest.registered_items[t[2]] then
		return false, "trade #".. i .." currency is invalid"
	end

	if not type(t[3]) == "number" or not type(t[4]) == "number" or t[3] > t[4] or t[3] < 1 or t[4] < 1 then
		return false, "trade #".. i .." price is invalid"
	end

	if not type(t[5]) == "number" or t[5] < 1 then
		return false, "trade #".. i .." stock is invalid"
	end

	if not type(t[6]) == "number" or t[6] < 0 or t[6] > 100 then
		return false, "trade #".. i .." rarity is invalid"
	end

	return true, nil
end

minetest.register_on_mods_loaded(function()
	for k,v in pairs(mobs.trader.items) do

		local valid, err_msg = is_valid_trade(k, v)

		if not valid then
			minetest.log("error", "[mobs_npc] ".. err_msg .. ", removing trade #".. k)
			table.remove(mobs.trader.items, k)
		end
	end
end)
