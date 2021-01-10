
local S = mobs.intllib

function mobs.give_to_player(player, item)
	local stack = ItemStack(item)
	local amount = stack:get_count()
	local stack_max = stack:get_stack_max()
	local inv = player:get_inventory()
	-- Item gets split into multiple stacks if there are more than the max
	while amount > 0 do
		local to_add = math.min(amount, stack_max)
		stack:set_count(to_add)
		-- Try to add to player's inventory
		local leftover = inv:add_item("main", stack)
		-- Drop excess items at the player's feet
		if leftover:get_count() > 0 then
			minetest.add_item(player:get_pos(), leftover)
		end
		amount = amount - to_add
	end
end

function mobs.npc_order(self, player, mob_name)
	local name = player:get_player_name()
	-- Only owner can order
	if self.owner and self.owner == name then
		mob_name = (self.nametag and self.nametag ~= "") and self.nametag or mob_name
		self.attack = nil
		if self.order == "stand" then
			-- Wander - makes the NPC walk around, but not following the owner
			self.order = "wander"
			minetest.chat_send_player(name, S("@1 wanders around.", mob_name))
		elseif self.order == "wander" then
			-- Follow - makes the NPC follow it's owner
			self.order = "follow"
			minetest.chat_send_player(name, S("@1 will follow you.", mob_name))
		else
			-- Stand - makes the NPC to stand where it is, not moving at all
			self.order = "stand"
			self.state = "stand"
			self:set_animation("stand")
			self:set_velocity(0)
			minetest.chat_send_player(name, S("@1 stands still.", mob_name))
		end
		return true
	end
	return false
end

function mobs.npc_drop(self, player, mob_name, drops)
	local item = player:get_wielded_item()
	if item:get_name() == "default:gold_lump" then
		local name = player:get_player_name()
		mob_name = (self.nametag and self.nametag ~= "") and self.nametag or mob_name
		-- Take one lump, if the player doesn't have creative
		if not mobs.is_creative(name) then
			item:take_item()
			player:set_wielded_item(item)
		end
		-- Give a random item to the player
		mobs.give_to_player(player, drops[math.random(#drops)])
		minetest.chat_send_player(name, S("@1 gave you an item for gold!", mob_name))
		return true
	end
	return false
end

function mobs.npc_lock(self, player, mob_name)
	local name = player:get_player_name()
	local item = player:get_wielded_item()
	if item:get_name() == "default:paper" then
		-- Only owner can set locked state
		if self.owner and self.owner == name then
			mob_name = (self.nametag and self.nametag ~= "") and self.nametag or mob_name
			if not self.locked then
				self.locked = true
				minetest.chat_send_player(name, S("@1 will not interact with other players.", mob_name))
			else
				self.locked = nil
				minetest.chat_send_player(name, S("@1 will interact with other players.", mob_name))
			end
			-- Take one paper, if the player doesn't have creative
			if not mobs.is_creative(name) then
				item:take_item()
				player:set_wielded_item(item)
			end
		else
			minetest.chat_send_player(name, S("@1 is owner!", self.owner))
		end
		return true
	end
	return false
end
