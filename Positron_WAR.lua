function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")
	
	include("func/obi_check.lua") -- obi_check()

	include("all/doom.lua") -- sets.doom
	include("all/precast-utsusemi.lua") -- sets.precast.utsusemi
	include("all/th.lua") -- sets.th

	include("war/enmity.lua") -- sets.enmity
	include("war/fastcast.lua") -- sets.fastcast
	include("war/idle.lua") -- sets.idle
	include("war/nowsd.lua") -- sets.nowsd
	include("war/tp.lua") -- sets.tp
	include("war/ws.lua") -- sets.ws
	include("war/ws-accuracy.lua") -- sets.ws.accuracy
	include("war/ws-magical.lua") -- sets.ws.magical
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
	}

	_MAGICAL_WS = T {
		"Aeolian Edge",
		"Cloudsplitter",
		"Gust Slash",
		"Red Lotus Blade",
		"Sanguine Blade",
	}

	_MULTI_HIT_WS = T {
		"Decimation",
		"Rampage",
		"Resolution",
		"Requiescat",
		"Ruinator",
		"Vorpal Blade"
	}

	_RED_PROC_WS = T {
		"Blade: Ei",
		"Cyclone",
		"Earth Crusher",
		"Energy Drain",
		"Freezebite",
		"Raiden Thrust",
		"Red Lotus Blade",
		"Seraph Blade",
		"Seraph Strike",
		"Shadow of Death",
		"Sunburst",
		"Tachi: Jinpu",
		"Tachi: Koki",
	}

	_OMEN_WS = T {
		"Burning Blade",
		"Flat Blade",
		"Shining Blade",
	}

	send_command(macrobook_cmd..lockstyle_cmd..porter_cmd)
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
		if _RED_PROC_WS:contains(spell.english) then
			equip(sets.nowsd)
		elseif _OMEN_WS:contains(spell.english) then
			equip(sets.nowsd)
		elseif _MAGICAL_WS:contains(spell.name) then
			equip(sets.ws.magical)
			obi_check(spell)
		elseif _MULTI_HIT_WS:contains(spell.english) then
			equip(sets.ws.multihit)
		elseif _ACCURACY_WS:contains(spell.english) then
			equip(sets.ws.accuracy)
		elseif _AOE_WS:contains(spell.english) then
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
			end
		end
	end
	-- elseif name == "Visitant" then
	-- end
end

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.tp)
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
