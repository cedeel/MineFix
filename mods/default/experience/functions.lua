-- First we'll calculate how much experience is needed per level\
local level_reference = {}
for i = 0, default.LEVEL_MAX, 1 do -- From level 1 to 40, with steps of 1
	if i <= 15 then
		level_reference[i] = {
			experience = (i * i) + 6 * (i)
		}
	elseif i <= 30 then
		level_reference[i] = {
			experience = 2.5 * (i * i) - 40.5 * (i) + 360
		}
	else
		level_reference[i] = {
			experience = 4.5 * (i * i) - 162.5 * (i) + 2220
		}
	end
end

function default.set_experience(player, value)
	if value > default.EXPERIENCE_MAX then -- Don't allow bigger than a 32-bit integer, like Minecraft
		value = default.EXPERIENCE_MAX
	elseif value < 0 then
		value = 0
	end

	player:get_inventory():set_stack("experience", 1, ItemStack({name = ":", count = value}))
end

function default.update_experience(player, modifier)
	local experience = default.get_experience(player)

	local experience_new = 0
	if experience + modifier < 0 then
		experience_new = 0
	elseif experience + modifier > default.EXPERIENCE_MAX_LEGITIMATE then
		experience_new = default.EXPERIENCE_MAX_LEGITIMATE
	else
		experience_new = experience + modifier
	end

	default.set_experience(player, experience_new)
	default.update_experience_total(player, modifier) -- Also update the total experience counter
end

function default.get_experience(player)
	return player:get_inventory():get_stack("experience", 1):get_count()
end

-- ===================================
-- Total experience (all experience gained since last respawn)
function default.set_experience_total(player, value)
	if value < 0 then
		value = 0
	end

	player:get_inventory():set_stack("experience", 2, ItemStack({name = ":", count = value}))
end

function default.update_experience_total(player, modifier)
	local experience = default.get_experience_total(player)

	local experience_new = 0
	if experience + modifier < 0 then
		experience_new = 0
	else
		experience_new = experience + modifier
	end

	default.set_experience_total(player, experience_new)
end

function default.get_experience_total(player)
	return player:get_inventory():get_stack("experience", 2):get_count()
end

-- ===================================
-- Level
function default.get_level(player)
	local experience = default.get_experience(player)

	local player_level = 0
	for level, value in pairs(level_reference) do
		if experience >= value.experience then
			player_level = level
		else
			break
		end
	end

	return player_level
end

function default.get_experience_for_level(level)
	if level > default.LEVEL_MAX then
		return default.LEVEL_MAX
	end
	return level_reference[level].experience
end