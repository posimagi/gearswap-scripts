gavialis_properties = T {}
gavialis_properties["Firesday"] = {
	"Liquefaction",
	"Fusion",
	"Light",
}
gavialis_properties["Earthsday"] = {
	"Scission",
	"Gravitation",
	"Darkness",
}
gavialis_properties["Watersday"] = {
	"Reverberation",
	"Distortion",
	"Darkness",
}
gavialis_properties["Windsday"] = {
	"Detonation",
	"Fragmentation",
	"Light",
}
gavialis_properties["Iceday"] = {
	"Induration",
	"Distortion",
	"Darkness",
}
gavialis_properties["Lightningday"] = {
	"Impaction",
	"Fragmentation",
	"Light",
}
gavialis_properties["Lightsday"] = {
	"Transfixion",
	"Fusion",
	"Light",
}
gavialis_properties["Darksday"] = {
	"Compression",
	"Gravitation",
	"Darkness",
}

function gavialis(spell)
	if gavialis_properties[world.day]:contains(spell.wsA) or
		gavialis_properties[world.day]:contains(spell.wsB) or
		gavialis_properties[world.day]:contains(spell.wsC) then
		return true
	end
	return false
end
