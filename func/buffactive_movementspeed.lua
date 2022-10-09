_MOVEMENT_SPEED_BUFFS = T {
	"Bolter's Roll",
	"Mazurka",
	"quickening", -- lowercase on purpose
}

function buffactive_movementspeed()
	if buffactive["Bolter's Roll"] or
		buffactive['Mazurka'] or
		buffactive['Quickening'] then
		return true
	end
	return false
end
