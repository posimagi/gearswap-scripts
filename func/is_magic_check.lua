_MAGIC_TYPES = T {
	"Divine Magic",
	"Healing Magic",
	"Enhancing Magic",
	"Enfeebling Magic",
	"Elemental Magic",
	"Dark Magic",
	"Summoning Magic",
	"Ninjutsu",
	"Singing",
	-- "String",
	-- "Wind",
	"Blue Magic",
	"Geomancy",
	-- "Handbell",
}

function is_magic(spell)
	if _MAGIC_TYPES:contains(spell.skill) then
		return true
	end
	return false
end
