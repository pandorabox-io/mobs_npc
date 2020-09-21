
local S = mobs.intllib

-- define table containing names for use and shop items for sale
mobs.trader = {

	names = {
		"Bob", "Duncan", "Bill", "Tom", "James", "Ian", "Lenny",
		"Dylan", "Ethan", "Jhon", "Alex", "Steve", "Rory", "Brian",
		"Joe", "Adam", "Will", "Billy", "Jhonny", "Bobby",
	},

	items = {
		-- {item, currency, min price, max price, rarity, high trade amount}
		{"default:apple 10", "default:gold_ingot", 1, 3, 10, 30},
		{"farming:bread 10", "default:gold_ingot", 1, 4, 5, 30},
		{"default:clay 10", "default:gold_ingot", 2, 5, 12, 100},
		{"default:brick 10", "default:gold_ingot", 2, 6, 17, 100},
		{"default:glass 10", "default:gold_ingot", 1, 4, 17, 100},
		{"default:obsidian 10", "default:gold_ingot", 5, 15, 50, 60},
		{"default:diamond 1", "default:gold_ingot", 5, 10, 40, 25},
		{"farming:wheat 10", "default:gold_ingot", 1, 4, 17, 50},
		{"default:tree 10", "default:gold_ingot", 1, 4, 20, 80},
		{"default:stone 20", "default:gold_ingot", 1, 3, 17, 100},
		{"default:desert_stone 10", "default:gold_ingot", 1, 4, 27, 100},
		{"default:sapling 5", "default:gold_ingot", 1, 3, 7, 30},
		{"default:pick_steel 1", "default:gold_ingot", 1, 4, 7, 10},
		{"default:sword_steel 1", "default:gold_ingot", 1, 3, 17, 10},
		{"default:shovel_steel 1", "default:gold_ingot", 1, 3, 17, 10},
		{"default:cactus 5", "default:gold_ingot", 2, 5, 40, 30},
		{"default:papyrus 10", "default:gold_ingot", 2, 6, 40, 50},
		{"default:mese_crystal 1", "default:dirt_with_grass", 5, 10, 90, 100},
		{"default:mese_crystal 1", "default:gold_ingot", 4, 8, 80, 100},
		{"default:sandstone 10", "default:gold_ingot", 1, 4, 20, 80},
		{"default:dirt 10", "default:gold_ingot", 1, 3, 10, 80},
		{"bucket:bucket_water 1", "default:gold_ingot", 1, 3, 20, 10},
		{"bucket:bucket_river_water 1", "default:gold_ingot", 2, 4, 30, 20},
		{"bucket:bucket_lava 1", "default:gold_ingot", 3, 8, 50, 20},
	}
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

local function set_random_name(self)
	local name = tostring(mobs.trader.names[math.random(#mobs.trader.names)])
	self.nametag = S("Trader @1", name)
	self:update_tag()
end

local function match_trade(trades, trade)

	for _,v in pairs(trades) do
		if v[1] == trade[1] and v[2] == trade[2] then
			return v
		end
	end
	return nil
end

local function get_random_trade(self, trade)

	-- select a random trade if not supplied
	while trade == nil do
		local rt = mobs.trader.items[math.random(#mobs.trader.items)]
		if not match_trade(self.trades, rt) and math.random(100) >= rt[5] then
			trade = rt
		end
	end

	local item = trade[1]
	local payment = trade[2]
	local price = math.random(trade[3], trade[4])
	local is_reverse = math.random(3) == 1

	return {item, payment, price, is_reverse, 0}
end

local function setup_trader(self)

	self.id = (math.random(1, 1000) * math.random(1, 10000)) .. self.name .. (math.random(1, 1000) ^ 2)
	self.day_count = minetest.get_day_count()
	self.trades = {}

	if #mobs.trader.items > 10 then
		for _=1, 10 do
			self.trades[#self.trades + 1] = get_random_trade(self, nil)
		end
	else
		-- not enough to pick random trades, but can randomize order with pairs()
		for _,v in pairs(mobs.trader.items) do
			self.trades[#self.trades + 1] = get_random_trade(self, v)
		end
	end
end

local function show_trades(self, clicker)

	if not self.id or not self.day_count or not self.trades then
		setup_trader(self)
	end

	if not self.nametag or self.nametag == "" or self.nametag == " " then
		set_random_name(self)
	end

	local player = clicker:get_player_name()

	minetest.chat_send_player(player, S("[NPC] <@1> Hello, @2, have a look at my wares.", self.nametag, player))

	local formspec =
		"size[8,10]"..
		default.gui_bg_img ..
		default.gui_slots ..
		"label[0.0,-0.1;".. S("@1's stock:", self.nametag) .."]"..
		"list[current_player;main;0,6;8,4;]"

	for i = 1, 10 do

		if self.trades[i] ~= nil then

			local x, y
			if i < 6 then
				x = 0.5
				y = i - 0.5
			else
				x = 4.5
				y = i - 5.5
			end

			local trade = self.trades[i]
			local payment = trade[4] and trade[1] or (trade[2] .." ".. trade[3])
			local item = trade[4] and (trade[2] .." ".. trade[3]) or trade[1]

			formspec = formspec ..
				"item_image_button[".. x ..",".. y ..";1,1;"..
					payment ..";".. self.id .."#".. i ..";]"..
				"item_image_button[".. x + 2 ..",".. y ..";1,1;"..
					item ..";".. self.id .."#".. i ..";]"..
				"image[".. x + 1 ..",".. y ..";1,1;gui_arrow_blank.png]"
		end
	end

	minetest.show_formspec(player, "mobs_npc:trade", formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)

	if formname ~= "mobs_npc:trade" then return end

	if fields and not fields.quit then

		local itemcode = ""

		for k,_ in pairs(fields) do
			itemcode = tostring(k)
		end

		local id = itemcode:split("#")[1]
		local self = nil

		-- find the trader
		if id ~= nil then
			for _,v in pairs(minetest.luaentities) do

				if v.object and v.id and v.id == id then
					self = v
					break
				end
			end
		end

		if self ~= nil then

			local trade_id = tonumber(itemcode:split("#")[2])

			if trade_id ~= nil and self.trades[trade_id] ~= nil then

				local trade = self.trades[trade_id]
				local payment = trade[4] and trade[1] or (trade[2] .." ".. trade[3])
				local item = trade[4] and (trade[2] .." ".. trade[3]) or trade[1]
				local inv = player:get_inventory()

				if inv:contains_item("main", payment) then

					-- take payment
					inv:remove_item("main", payment)

					-- give items to player
					local leftover = inv:add_item("main", item)

					-- drop excess items at the player's feet
					if leftover:get_count() > 0 then
						minetest.add_item(player:get_pos(), leftover)
					end

					-- count the trade
					self.trades[trade_id][5] = trade[5] + 1
				end
			end
		end
	end
end)

local function check_trades(self)

	-- should never be nil, but check just in case
	if self.trades == nil then return end

	local trade_total = 0

	-- count up all the trades that have been made
	for _,v in pairs(self.trades) do
		trade_total = trade_total + (v[5] or 0)
	end

	if trade_total > 10 then

		for k,v in pairs(self.trades) do

			local trade = match_trade(mobs.trader.items, v)

			if trade then

				-- if not traded
				if v[5] == 0 and math.random(5) == 1 then

					-- better price or change trade
					if v[4] and v[3] < trade[4] then

						self.trades[k][3] = v[3] + 1

					elseif not v[4] and v[3] > trade[3] then

						self.trades[k][3] = v[3] - 1

					elseif #mobs.trader.items > 10 then

						self.trades[k] = get_random_trade(self, nil)
					end

				-- if traded too much
				elseif v[5] > trade[6] and math.random(2) == 1 then

					-- worse price
					if v[4] and v[3] > trade[3] then

						self.trades[k][3] = v[3] - 1

					elseif not v[4] and v[3] < trade[4] then

						self.trades[k][3] = v[3] + 1
					end
				end
			end

			-- reset count
			self.trades[k][5] = 0
		end
	end
end

mobs:register_mob("mobs_npc:trader", {
	type = "npc",
	passive = false,
	damage = 3,
	attack_type = "dogfight",
	attacks_monsters = true,
	attack_animals = false,
	attack_npcs = false,
	pathfinding = false,
	hp_min = 10,
	hp_max = 20,
	armor = 100,
	collisionbox = {-0.35,-1.0,-0.35, 0.35,0.8,0.35},
	visual = "mesh",
	mesh = "mobs_character.b3d",
	textures = {
		{"mobs_trader.png"}, -- by Frerin
		{"mobs_trader2.png"},
		{"mobs_trader3.png"},
	},
	makes_footstep_sound = true,
	sounds = {},
	walk_velocity = 2,
	run_velocity = 3,
	jump = false,
	drops = {
		{name = "default:gold_ingot", chance = 2, min = 1, max = 3},
		{name = "default:diamond", chance = 6, min = 0, max = 1},
	},
	water_damage = 0,
	lava_damage = 4,
	light_damage = 0,
	follow = {"default:diamond", "default:gold_ingot"},
	view_range = 15,
	owner = "",
	order = "stand",
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

		-- feed to tame or heal npc
		if mobs:feed_tame(self, clicker, 8, false, true) then return end

		-- capture npc with net or lasso
		if mobs:capture_mob(self, clicker, nil, 5, 80, false, nil) then return end

		-- protect npc with mobs:protector
		if mobs:protect(self, clicker) then return end

		-- right-clicking with an item shows trades
		if clicker:get_wielded_item():get_name() ~= "" then
			self.attack = nil
			show_trades(self, clicker)
			return
		end

		-- by right-clicking owner can switch npc between follow and stand
		mobs:npc_order(self, clicker, S("Trader"))
	end,

	on_spawn = function(self)

		set_random_name(self, mobs.trader)

		return true -- return true so on_spawn is run once only
	end,

	do_custom = function(self)

		local day_count = minetest.get_day_count()

		-- check the day's trades
		if self.day_count and self.day_count < day_count then
			self.day_count = day_count
			check_trades(self)
		end

		return true -- return true so the rest of the mob api is executed
	end,
})

-- register spawning abm
mobs:spawn({
	name = "mobs_npc:trader",
	nodes = {"default:sandstonebrick"},
	neighbors = {"group:grass"},
	min_light = 10,
	chance = 10000,
	min_height = 0,
	day_toggle = true,
})

-- register spawn egg
mobs:register_egg("mobs_npc:trader", S("Trader"), "default_sandstone.png", 1)

-- compatibility
mobs:alias_mob("mobs:trader", "mobs_npc:trader")
