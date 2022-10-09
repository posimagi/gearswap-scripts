-- NOTE: do not include more than one file that overwrites precast, paste contents into the real precast instead.
_RANGE_MULTIPLIER = 1.642276421172564
_real_precast = precast
function precast(spell, position)
	if spell.type == "WeaponSkill" and
		spell.target.distance > (spell.range * _RANGE_MULTIPLIER + spell.target.model_size) then
		add_to_chat(8, spell.name .. " aborted because target is out of range.")
		cancel_spell()
		return
	end
	_real_precast(spell, position)
end
