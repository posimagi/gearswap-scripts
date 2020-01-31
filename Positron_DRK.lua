function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	sets.tp = {
		ammo = "Ginsen",
		head = "Flam. Zucchetto +2",
		body = "Flamma Korazin +2",
		hands = "Flam. Manopolas +2",
		legs = {name = "Carmine Cuisses +1", augments = {"Accuracy+20", "Attack+12", '"Dual Wield"+6'}},
		feet = "Flam. Gambieras +2",
		neck = "Agelast Torque",
		waist = "Sailfi Belt +1",
		left_ear = "Telos Earring",
		right_ear = "Cessance Earring",
		left_ring = "Flamma Ring",
		right_ring = "Petrov Ring",
		back = "Agema Cape"
	}

	sets.ws = {
		ammo = "Knobkierrie",
		head = "Flam. Zucchetto +2",
		body = "Flamma Korazin +2",
		hands = "Flam. Manopolas +2",
		legs = "Flamma Dirs +2",
		feet = "Flam. Gambieras +2",
		neck = "Fotia Gorget",
		waist = "Fotia Belt",
		left_ear = {name = "Moonshade Earring", augments = {"Accuracy+4", "TP Bonus +250"}},
		right_ear = "Cessance Earring",
		left_ring = "Apate Ring",
		right_ring = "Regal Ring",
		back = "Agema Cape"
	}
end

function precast(spell, position)
	if spell.type == "WeaponSkill" then
		equip(sets.ws)
	end
end

function midcast(spell)
end

function aftercast(spell)
	if player.status == "Idle" then
		--	equip(sets.idle)
	elseif player.status == "Engaged" then
		equip(sets.tp)
	end
end

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.tp)
	elseif new == "Idle" then
	--	equip(sets.idle)
	end
end
