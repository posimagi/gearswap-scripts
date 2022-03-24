_RANGE_MULTIPLIER = 1.642276421172564
function ws_distance_check(spell)
	if 
		spell.type == "WeaponSkill" and
		spell.target.distance > (spell.range * _RANGE_MULTIPLIER + spell.target.model_size) then
	add_to_chat(8, spell.name.." aborted because target is out of range.")
	cancel_spell()
	return false
	end
	return true
end
