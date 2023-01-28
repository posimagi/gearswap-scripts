function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.petmidcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")
	
	include("all/obi.lua") -- sets.obi

	include("bst/fastcast.lua") -- sets.fastcast
	include("bst/idle.lua") -- sets.idle
	include("bst/tp.lua") -- sets.tp
	include("bst/ws.lua") -- sets.ws
	include("bst/ws-magical.lua") -- sets.ws.magical

	include("bst/precast-callbeast.lua") -- sets.precast.callbeast
	include("bst/precast-sic.lua") -- sets.precast.sic
	include("bst/precast-spur.lua") -- sets.precast.spur

	include("bst/petmidcast-sic.lua") -- sets.petmidcast.sic

	include("func/obi_check.lua") -- obi_check()

	_MAGICAL_WS = T {
		"Aeolian Edge",
		"Cloudsplitter",
		"Primal Rend",
	}

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
		if _MAGICAL_WS:contains(spell.name) then
			equip(sets.ws.magical)
			obi_check(spell)
		end
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Call Beast") then
			equip(sets.callbeast)
		end	
	elseif spell.type == "Monster" then
		equip(sets.precast.sic)
	else
		equip(sets.fastcast)
	end
end

function midcast(spell)
end

function pet_midcast(spell)
	equip(sets.petmidcast.sic)
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

function pet_aftercast(spell)
	if player.status == "Idle" then
		equip(sets.idle)
	elseif player.status == "Engaged" then
		equip(sets.tp)
	end
end

function buff_change(name, gain, buff_details)
end
