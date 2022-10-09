function buffactive_aftermath()
	if buffactive['Aftermath: Lv.1'] or
		buffactive['Aftermath: Lv.2'] or
		buffactive['Aftermath: Lv.3'] then
		return true
	end
	return false
end
