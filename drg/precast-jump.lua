sets.precast['Jump'] = set_combine(sets.tp, {
	body={ name="Ptero. Mail +3", augments={'Enhances "Spirit Surge" effect',}},
	hands="Vishap F. G. +2",
	legs={ name="Ptero. Brais +2", augments={'Enhances "Strafe" effect',}},
	feet="Vishap Greaves +2",
	back={ name="Brigantia's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
})

sets.precast['High Jump'] = sets.precast['Jump']
sets.precast['Spirit Jump'] = set_combine(sets.precast['Jump'], {
	feet="Pelt. Schyn. +2",
})
sets.precast['Soul Jump'] = sets.precast['Jump']
