function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")
	
	include("all/obi.lua") -- sets.obi

	include("drk/fastcast.lua") -- sets.fastcast
	include("drk/idle.lua") -- sets.idle
	include("drk/tp.lua") -- sets.tp
	include("drk/ws.lua") -- sets.ws
	include("drk/ws-multihit.lua") -- sets.ws.multihit
	include("drk/ws-magical.lua") -- sets.ws.magical

	include("drk/precast-lastresort.lua") -- sets.precast.lastresort

	include("func/obi_check.lua") -- obi_check()

	_MAGICAL_WS = T {
		"Aeolian Edge",
	}

	_MULTI_HIT_WS = T {
		"Resolution",
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
		if _MAGICAL_WS:contains(spell.name) then
			equip(sets.ws.magical)
			obi_check(spell)
		elseif _MULTI_HIT_WS:contains(spell.name) then
			equip(sets.ws.multihit)
		end
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Last Resort") then
			equip(sets.precast.lastresort)
		end
	else
		equip(sets.fastcast)
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

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.tp)
	elseif new == "Idle" then
		equip(sets.idle)
	end
end

function buff_change(name, gain, buff_details)
end
