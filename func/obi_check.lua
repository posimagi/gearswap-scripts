function obi_check(spell)
	-- equip Hachirin-no-Obi only if it will beat Orpheus's Sash
	if world.weather_element == spell.element then
		if 
				world.weather_intensity == 2 or
				world.day_element == spell.element or
				spell.target.distance > (6 * _RANGE_MULTIPLIER + spell.target.model_size) then
			equip(sets.obi)
			end
	end
end
