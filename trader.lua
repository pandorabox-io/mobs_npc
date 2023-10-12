
local S = mobs.intllib

local trading_players = {}

minetest.register_on_leaveplayer(function(player)
	trading_players[player:get_player_name()] = nil
end)

-- Define table containing names for use and shop items for sale
mobs.trader = {
	names = {
		"Bob", "Duncan", "Bill", "Tom", "James", "Ian", "Lenny",
		"Dylan", "Ethan", "Jhon", "Alex", "Steve", "Rory", "Brian",
		"Joe", "Adam", "Will", "Billy", "Jhonny", "Bobby",
	},
	items = {
		-- {item, currency, min price, max price, daily stock, rarity}
		-- See trader_items.lua
	}
}

local function set_random_name(self)
	local name = tostring(mobs.trader.names[math.random(#mobs.trader.names)])
	self._nametag = S("Trader @1", name)
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
	-- Select a random trade if not supplied
	while trade == nil do
		local rt = mobs.trader.items[math.random(#mobs.trader.items)]
		if not match_trade(self.trades, rt) and math.random(100) >= rt[6] then
			trade = rt
		end
	end
	-- Randomize the trade
	local item = trade[1]
	local payment = trade[2]
	local price = math.random(trade[3], trade[4])
	local is_reverse = trade[7] == nil and math.random(3) == 1 or trade[7]
	local stock = trade[5]
	return {item, payment, price, is_reverse, stock}
end

local function setup_trader(self)
	self.day_count = minetest.get_day_count()
	self.trade_count = 0
	self.trades = {}
	-- Set random starting trades
	if #mobs.trader.items > 10 then
		for _=1, 10 do
			self.trades[#self.trades + 1] = get_random_trade(self, nil)
		end
	else
		-- Not enough to pick random trades, but can (kind of) randomize order with pairs()
		for _,v in pairs(mobs.trader.items) do
			self.trades[#self.trades + 1] = get_random_trade(self, v)
		end
	end
end

local function show_trades(self, clicker)
	if not self.day_count or not self.trade_count or not self.trades then
		setup_trader(self)
	end
	if not self._nametag or self._nametag == "" or self._nametag == " " then
		if self.nametag then
			self.update_tag()  -- Fix nametag without setting a new name
		else
			set_random_name(self)
		end
	end
	-- Check if player can trade with this trader
	local player = clicker:get_player_name()
	if self.locked and self.owner and self.owner ~= player then
		minetest.chat_send_player(player, S("@1 is owner!", self.owner))
		return
	end
	-- Temporary store the object reference
	trading_players[player] = self

	local formspec =
		"size[8,10]"..
		"label[0.0,-0.1;"..S("@1's stock:", self._nametag).."]"..
		"list[current_player;main;0,6;8,4;]"

	for i = 1, 10 do
		if self.trades[i] ~= nil then
			-- Calculate position of trade in formspec
			local x, y
			if i < 6 then
				x = 0.5
				y = i - 0.5
			else
				x = 4.5
				y = i - 5.5
			end
			-- Add trade to the formspec
			local trade = self.trades[i]
			local payment = trade[4] and trade[1] or (trade[2].." "..trade[3])
			local item = trade[4] and (trade[2].." "..trade[3]) or trade[1]
			if trade[5] > 0 then
				formspec = formspec..
					"item_image_button[".. x..","..y..";1,1;"..payment..";payment#"..i..";]"..
					"item_image_button["..(x + 2)..","..y..";1,1;"..item..";item#"..i..";]"..
					"image["..(x + 1)..","..y..";1,1;mobs_gui_arrow.png]"
			else
				-- No stock left, no buttons and cross instead of arrow
				formspec = formspec..
					"item_image["..x..","..y..";1,1;"..payment.."]"..
					"item_image["..(x + 2)..","..y..";1,1;"..item.."]"..
					"image["..(x + 1)..","..y..";1,1;mobs_gui_cross.png]"
			end
		end
	end
	minetest.show_formspec(player, "mobs_npc:trade", formspec)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "mobs_npc:trade" or not player or not fields then
		return
	end
	local name = player:get_player_name()
	if fields.quit then
		-- Clear temporary object reference
		trading_players[name] = nil
	else
		local self = trading_players[name]
		local trade_id = ""
		for k,_ in pairs(fields) do
			trade_id = tostring(k)
		end
		trade_id = tonumber(trade_id:split("#")[2])
		if self ~= nil and trade_id ~= nil and self.trades[trade_id] ~= nil then
			local trade = self.trades[trade_id]
			if trade[5] <= 0 then
				-- Out of stock, update formspec
				show_trades(self, player)
				return
			end
			local payment = trade[4] and trade[1] or (trade[2].." "..trade[3])
			local item = trade[4] and (trade[2].." "..trade[3]) or trade[1]
			local inv = player:get_inventory()
			if inv:contains_item("main", payment) then
				-- Take payment
				inv:remove_item("main", payment)
				-- Give items to player
				mobs.give_to_player(player, item)
				-- Count the trade
				self.trade_count = self.trade_count + 1
				-- Remove from stock
				self.trades[trade_id][5] = trade[5] - 1
				-- Update formspec if trade is now out of stock
				if trade[5] <= 0 then
					show_trades(self, player)
				end
			end
		end
	end
end)

local function check_trades(self)
	-- Should never be nil, but check just in case
	if self.trades == nil or self.trade_count == nil then
		return
	end
	for k,v in pairs(self.trades) do
		local trade = match_trade(mobs.trader.items, v)
		if not trade then
			-- Invalid trade, replace or remove it
			if #mobs.trader.items >= 10 then
				self.trades[k] = get_random_trade(self, nil)
			else
				table.remove(self.trades, k)
			end
		else
			if trade[7] ~= nil and v[4] ~= trade[7] then
				-- Current trade direction is not allowed, change it
				self.trades[k][4] = trade[7]
			end
			if v[3] < trade[3] or v[3] > trade[4] then
				-- Min or max price was changed, set new random price
				self.trades[k][3] = math.random(trade[3], trade[4])
			elseif self.trade_count > 0 then
				-- If not traded in the last day
				if v[5] == trade[5] and math.random(5) == 1 then
					-- Better price or change trade
					if v[3] > trade[3] and v[3] < trade[4] then

						self.trades[k][3] = v[3] + (v[4] and 1 or -1)

					elseif #mobs.trader.items > 10 then

						self.trades[k] = get_random_trade(self, nil)
					end
				-- If out of stock
				elseif v[5] <= 0 and math.random(2) == 1 then
					-- worse price
					if v[3] > trade[3] and v[3] < trade[4] then

						self.trades[k][3] = v[3] + (v[4] and -1 or 1)
					end
				end
			end
			-- Restock trade
			self.trades[k][5] = trade[5]
		end
	end
	self.trade_count = 0
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
		{"mobs_trader.png"}, -- Skin by Frerin
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
		-- Feed to tame or heal npc
		if mobs:feed_tame(self, clicker, 8, false, true) then return end
		-- Capture npc with net or lasso
		if mobs:capture_mob(self, clicker, nil, 5, 80, false, nil) then return end
		-- Lock or unlock by right-clicking with paper
		if mobs.npc_lock(self, clicker, S("Trader")) then return end
		-- Protect npc with mobs:protector
		if mobs:protect(self, clicker) then return end
		-- Right-clicking with an item shows trades
		if clicker:get_wielded_item():get_name() ~= "" then
			self.attack = nil
			show_trades(self, clicker)
			return
		end
		-- By right-clicking owner can switch npc between follow and stand
		mobs.npc_order(self, clicker, S("Trader"))
	end,
	on_spawn = function(self)
		set_random_name(self, mobs.trader)
		return true  -- Return true so on_spawn is run once only
	end,
	do_custom = function(self)
		local day_count = minetest.get_day_count()
		-- Check the day's trades
		if self.day_count and self.day_count < day_count then
			self.day_count = day_count
			check_trades(self)
		end
	end,
})

-- Register spawning abm
mobs:spawn({
	name = "mobs_npc:trader",
	nodes = {"default:sandstonebrick"},
	neighbors = {"group:grass"},
	min_light = 10,
	chance = 10000,
	min_height = 0,
	day_toggle = true,
	active_object_count = 2,
})

-- Register spawn egg
mobs:register_egg("mobs_npc:trader", S("Trader"), "default_sandstone.png", 1)

-- Compatibility
mobs:alias_mob("mobs:trader", "mobs_npc:trader")
