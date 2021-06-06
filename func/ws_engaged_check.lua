-- NOTE: do not include more than one file that overwrites precast, paste contents into the real precast instead.
_real_precast = precast
function precast(spell, position)
	if 
			spell.type == "WeaponSkill" and
			player.status ~= "Engaged" then
		add_to_chat(8, spell.name.." aborted because you are not engaged.")
		cancel_spell()
		return
	end
	_real_precast(spell, position)
end
