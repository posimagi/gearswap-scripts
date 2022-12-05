function obi_check(spell)
	if 
			world.weather_element == spell.element and world.weather_intensity == 2 or
			world.weather_element == spell.element and world.day_element == spell.element then
		equip(sets.obi)
	end
end
