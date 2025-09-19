function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")
	
	include("mnk/footwork.lua") -- sets.footwork
	include("mnk/idle.lua") -- sets.idle
	include("mnk/impetus.lua") -- sets.impetus
	include("mnk/tp.lua") -- sets.tp
	include("mnk/ws.lua") -- sets.ws

	include("mnk/precast-chakra.lua") -- sets.precast.chakra
	include("mnk/precast-counterstance.lua") -- sets.precast.counterstance
	include("mnk/precast-focus.lua") -- sets.precast.focus
	include("mnk/precast-footwork.lua") -- sets.precast.footwork
	include("mnk/precast-hundredfists.lua") -- sets.precast.hundredfists
	include("mnk/precast-mantra.lua") -- sets.precast.mantra

	send_command(macrobook_cmd..porter_cmd..lockstyle_cmd)
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
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Chakra") then
			equip(sets.precast.chakra)
		elseif spell.english:contains("Counterstance") then
			equip(sets.precast.counterstance)
		elseif spell.english:contains("Focus") then
			equip(sets.precast.focus)
		elseif spell.english:contains("Footwork") then
			equip(sets.precast.footwork)
		elseif spell.english:contains("Hundred Fists") then
			equip(sets.precast.hundredfists)
		elseif spell.english:contains("Mantra") then
			equip(sets.precast.mantra)
		end
	end
end

function midcast(spell)
end

function aftercast(spell)
	if player.status == "Idle" then
		equip(sets.idle)
	elseif player.status == "Engaged" then
		equip(sets.tp)
		if spell.english:contains("Impetus") or buffactive['Impetus'] then
			equip(sets.impetus)
		end
		if spell.english:contains("Impetus") or buffactive['Footwork'] then
			equip(sets.footwork)
		end
	end
end

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.tp)
		if buffactive['Impetus'] then
			equip(sets.impetus)
		end
		if buffactive['Footwork'] then
			equip(sets.footwork)
		end
	elseif new == "Idle" then
		equip(sets.idle)
	end
end

function buff_change(name, gain, buff_details)
end
