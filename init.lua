--[[
                                                __                 __  .__
  ____   ______ _____      _____________  _____/  |_  ____   _____/  |_|__| ____   ____
_/ ___\ /  ___//     \     \____ \_  __ \/  _ \   __\/ __ \_/ ___\   __\  |/  _ \ /    \
\  \___ \___ \|  Y Y  \    |  |_> >  | \(  <_> )  | \  ___/\  \___|  | |  (  <_> )   |  \
 \___  >____  >__|_|  /____|   __/|__|   \____/|__|  \___  >\___  >__| |__|\____/|___|  /
     \/     \/      \/_____/__|                          \/     \/                    \/
--]]

local load_time_start = os.clock()
local modname = minetest.get_current_modname()


local prefix = "csm_protection: "

if INIT == "client" then
	local lastpos
	csm_com.register_on_receive(function(msg)
		if msg:sub(1, #prefix) == prefix then
			lastpos = msg:sub(#prefix+1)
			return true
		end
	end)
	minetest.register_on_dignode(function(pos, node)
		if lastpos == minetest.pos_to_string(pos) then
			return true
		end
	end)

elseif INIT == "game" then
	minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
		local player_name = puncher:get_player_name()
		if csm_com.player_has(player_name) and
				minetest.is_protected(pos, player_name) then
			csm_com.send(player_name, prefix..minetest.pos_to_string(pos))
		end
	end)
	-- Kicking the players would be good to force them:
	--~ minetest.register_on_protection_violation(function(pos, name)
		--~ minetest.kick_player(name, "protection violation")
	--~ end)

else
	print("csm_protection is not made for such a use!")
end


local time = math.floor(tonumber(os.clock()-load_time_start)*100+0.5)/100
local msg = "["..modname.."] loaded after ca. "..time
if time > 0.05 then
	print(msg)
else
	minetest.log("info", msg)
end
