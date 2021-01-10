
local MP = minetest.get_modpath(minetest.get_current_modname())

-- Load support for intllib.
-- TODO: only use builtin transitor?
local S = minetest.get_translator and minetest.get_translator("mobs_npc")
			or dofile(minetest.get_modpath("intllib").."/init.lua")
mobs.intllib = S

-- Helper functions
dofile(MP.."/functions.lua")

-- NPCs
dofile(MP.."/npc.lua")  -- NPC by TenPlus1
dofile(MP.."/igor.lua")  -- Igor by TenPlus1
dofile(MP.."/trader.lua")  -- Trader by TenPlus1, reworked by OgelGames
dofile(MP .. "/farmer.lua") -- Farmer by OgelGames

-- Trader items
dofile(MP.."/trader_items.lua")

-- Support for Lucky Blocks
if minetest.get_modpath("lucky_block") then
	lucky_block:add_blocks({
		{"spw", "mobs:npc", 1, true, true},
		{"spw", "mobs:igor", 1, true, true, 5, "Igor"},
		{"spw", "mobs:trader", 1, false, false},
		{"lig", "fire:permanent_flame"},
	})
end

print("[MOD] Mobs Redo NPCs loaded")
