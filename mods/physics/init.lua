local sprint_speed = 1.77
local gravity_rate = 1.17

minetest.register_on_joinplayer(function(player)
    minetest.register_globalstep(function(dtime)
        -- Jump tweak
        if player:get_player_control().jump then
            minetest.after(0.18, function()
                player:set_physics_override({
                    gravity = gravity_rate,
                })
            end)
        end

        -- Sprinting
        if player:get_player_control().aux1 and player:get_player_control().up then
            player:set_physics_override({
                speed = sprint_speed
            })
        else 
            player:set_physics_override({
                speed = 1.0
            })
        end
    end)
end)