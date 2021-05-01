_RANGE_MULTIPLIER = 1.642276421172564
_real_precast = precast
function precast(spell, position)
	if spell.type == "WeaponSkill" then
		if spell.target.distance > (spell.range * _RANGE_MULTIPLIER + spell.target.model_size) then
			add_to_chat(8, spell.name.." aborted due to target out of range.")
			cancel_spell()
		end
	end
	_real_precast(spell, position)
end
