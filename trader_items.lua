
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
minetest.register_on_mods_loaded(function()
	for _,v in pairs(mobs.trader.items) do
		assert(type(v[1]) == "string" and
			type(v[1]) == "string" and
			type(v[3]) == "number" and
			type(v[4]) == "number" and
			type(v[5]) == "number" and
			type(v[6]) == "number"
			,"invalid mobs trader item")
	end
end)
