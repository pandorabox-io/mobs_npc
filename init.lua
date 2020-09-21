
-- Load support for intllib.
local path = minetest.get_modpath(minetest.get_current_modname())
local S = minetest.get_translator and minetest.get_translator("mobs_npc") or
		dofile(path .. "/intllib.lua")
mobs.intllib = S

function mobs:npc_order(self, clicker, mob_name)

	local name = clicker:get_player_name()
	
	if self.owner and self.owner == name then

		mob_name = (self.nametag and self.nametag ~= "") and self.nametag or mob_name

		self.attack = nil

		if self.order == "follow" then

			self.order = "stand"

			self.state = "stand"
			self:set_animation("stand")
			self:set_velocity(0)

			minetest.chat_send_player(name, S("@1 stands still.", mob_name))
		else
			self.order = "follow"

			minetest.chat_send_player(name, S("@1 will follow you.", mob_name))
		end
		
		return true
	end
	
	return false
end

function mobs:npc_drop(self, clicker, mob_name, drops)

	local item = clicker:get_wielded_item()
	
	if item:get_name() == "default:gold_lump" then
		
		local name = clicker:get_player_name()

		mob_name = (self.nametag and self.nametag ~= "") and self.nametag or mob_name

		if not mobs.is_creative(name) then
			item:take_item()
			clicker:set_wielded_item(item)
		end

		local pos = self.object:get_pos()

		pos.y = pos.y + 0.5

		minetest.add_item(pos, { name = drops[math.random(#drops)] })

		minetest.chat_send_player(name, S("@1 dropped you an item for gold!", mob_name))

		return true
	end

	return false
end

-- NPCs
dofile(path .. "/npc.lua") -- TenPlus1
dofile(path .. "/trader.lua")
dofile(path .. "/igor.lua")

-- Lucky Blocks
dofile(path .. "/lucky_block.lua")

print (S("[MOD] Mobs Redo NPCs loaded"))
