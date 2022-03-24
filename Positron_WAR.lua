function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("all/doom.lua") -- sets.doom
	include("all/precast-utsusemi.lua") -- sets.precast.utsusemi
	include("all/th.lua") -- sets.th

	include("war/enmity.lua") -- sets.enmity
	include("war/fastcast.lua") -- sets.fastcast
	include("war/fencer.lua") -- sets.fencer
	include("war/idle.lua") -- sets.idle
	include("war/tp.lua") -- sets.tp
	include("war/ws.lua") -- sets.ws
	include("war/ws-accuracy.lua") -- sets.ws.accuracy
	include("war/ws-multihit.lua") -- sets.ws.multihit

	include("war/precast-aggressor.lua") -- sets.precast.aggressor
	include("war/precast-berserk.lua") -- sets.precast.berserk
	include("war/precast-bloodrage.lua") -- sets.precast.bloodrage
	include("war/precast-defender.lua") -- sets.precast.defender
	include("war/precast-mightystrikes.lua") -- sets.precast.mightystrikes
	include("war/precast-tomahawk.lua") -- sets.precast.tomahawk
	include("war/precast-warcry.lua") -- sets.precast.warcry

	_AOE_WS = T {
		"Fell Cleave",
		"Circle Blade"
	}

	_ACCURACY_WS = T {
		"Full Break",
		"Steel Cyclone",
		"Ukko's Fury" -- hurts damage, but improves TP gain for multistep
	}

	_MULTI_HIT_WS = T {
		"Decimation",
		"Rampage",
		"Resolution",
		"Requiescat",
		"Ruinator",
		"Vorpal Blade"
	}

	_FENCER_WEAPONS = T {
		"Blurred Shield +1"
	}

	_FENCER = false
	if _FENCER then
	end

	_TH = false

	send_command(
		"input /macro book 1; \
	wait 1; \
	input /macro set 1; \
	wait 5; \
	input /lockstyleset 21; \
	gs equip sets.idle; \
	du blinking self all off;"
	)
end

function precast(spell, position)
	-- WS Engaged Check
	if spell.type == "WeaponSkill" and player.status ~= "Engaged" then
		cancel_spell()
		return
	end

	-- WS Distance Check
	_RANGE_MULTIPLIER = 1.642276421172564
	if spell.type == "WeaponSkill" and
		spell.target.distance >
		(spell.range * _RANGE_MULTIPLIER + spell.target.model_size)
	then
		add_to_chat(8, spell.name .. " aborted due to target out of range.")
		cancel_spell()
		return
	end

	if spell.type == "WeaponSkill" then
		equip(sets.ws)
		if _MULTI_HIT_WS:contains(spell.english) then
			equip(sets.ws.multihit)
		elseif _ACCURACY_WS:contains(spell.english) then
			equip(sets.ws.accuracy)
		end
		if _AOE_WS:contains(spell.english) then
			equip(sets.th)
		end
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Aggressor") then
			equip(sets.precast.aggressor)
		elseif spell.english:contains("Berserk") then
			equip(sets.precast.berserk)
		elseif spell.english:contains("Blood Rage") then
			equip(sets.precast.bloodrage)
		elseif spell.english:contains("Defender") then
			equip(sets.precast.defender)
		elseif spell.english:contains("Mighty Strikes") then
			equip(sets.precast.mightystrikes)
		elseif spell.english:contains("Provoke") then
			equip(sets.enmity, sets.th)
		elseif spell.english:contains("Tomahawk") then
			equip(sets.precast.tomahawk, sets.th)
		elseif spell.english:contains("Warcry") then
			equip(sets.precast.warcry)
		end
	elseif spell.type == "Ninjutsu" then
		equip(sets.idle, sets.fastcast)
		if spell.english:contains("Utsusemi") then
			equip(sets.precast.utsusemi)
		end
	else
		equip(sets.idle, sets.fastcast)
	end
end

function midcast(spell)
end

function aftercast(spell)
	if player.status == "Idle" then
		equip(sets.idle)
	elseif player.status == "Engaged" then
		equip(sets.tp)
		if _TH then
			equip(sets.th)
		end
	end
end

function buff_change(name, gain, buff_details)
	if name == "doom" then -- "doom" is explicitly lowercase
		if gain then
			equip(sets.doom)
			disable("neck", "left_ring")
		else
			enable("neck", "left_ring")
			if player.status == "Idle" then
				equip(sets.idle)
			elseif player.status == "Engaged" then
				equip(sets.tp)
				if _TH then
					equip(sets.th)
				end
			end
		end
	end
	-- elseif name == "Visitant" then
	-- end
end

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.tp)
		if _TH then
			equip(sets.th)
		end
	elseif new == "Idle" then
		equip(sets.idle)
	end
end

function self_command(command)
	if command == "fencer" then
		include("war/tp.lua") -- sets.tp
	elseif command == "dualwield" then
		include("war/tp-dualwield.lua") -- sets.tp
	end
end
