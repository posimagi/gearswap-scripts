-- WS Distance Check
function ws_is_out_of_range(spell)
    _RANGE_MULTIPLIER = 1.642276421172564
	if spell.type == "WeaponSkill" and
		spell.target.distance >
		(spell.range * _RANGE_MULTIPLIER + spell.target.model_size)
	then
		return true
	end
    return false
end

function ws_distance_check(spell)
	if ws_is_out_of_range(spell) then
		if player.tp > 1000 then
			add_to_chat(8, spell.name .. " aborted because the target is out of range.")
		end
		cancel_spell()
		return true
	end
	return false
end