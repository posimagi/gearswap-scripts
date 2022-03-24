function ws_engaged_check(spell, player)
	if 
		spell.type == "WeaponSkill" and
		player.status ~= "Engaged" then
	add_to_chat(8, spell.name.." aborted because you are not engaged.")
	cancel_spell()
	return false
	end
	return true
end
