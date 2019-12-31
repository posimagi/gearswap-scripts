function buffactive_enspell()
	if buffactive['Enfire'] or
	   buffactive['Enblizzard'] or
	   buffactive['Enaero'] or
	   buffactive['Enstone'] or
	   buffactive['Enthunder'] or
	   buffactive['Enwater'] or
	   buffactive['Enfire II'] or
	   buffactive['Enblizzard II'] or
	   buffactive['Enaero II'] or
	   buffactive['Enstone II'] or
	   buffactive['Enthunder II'] or
	   buffactive['Enwater II'] then
		return true
	end
	return false
end
