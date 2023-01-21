function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("common/job_change.lua")
	
	include("all/obi.lua") -- sets.obi

	include("pld/enmity.lua") -- sets.enmity
	include("pld/fastcast.lua") -- sets.fastcast
	include("pld/idle.lua") -- sets.idle
	include("pld/interrupt.lua") -- sets.interrupt
	include("pld/tp.lua") -- sets.tp
	include("pld/ws.lua") -- sets.ws
	include("pld/ws-magical.lua") -- sets.ws.magical

	include("pld/midcast-healing.lua") -- sets.midcast.healing

	include("func/obi_check.lua") -- obi_check()

	_MAGICAL_WS = T {
		"Aeolian Edge",
		"Red Lotus Blade",
		"Seraph Blade"
	}

	_TAG_SPELLS = T {
		"Banishga",
		"Geist Wall",
		"Jettatura",
		"Poisonga",
		"Sheep Song"
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
		end
	elseif spell.type == "JobAbility" then
		equip(sets.idle, sets.enmity)
	else
		equip(sets.fastcast)
	end
end

function midcast(spell)
	if _TAG_SPELLS:contains(spell.english) then
		equip(sets.idle, sets.interrupt)
	elseif spell.english:contains("Flash") then
		equip(sets.idle, sets.enmity)
	elseif spell.english:contains("Cure") then
		equip(sets.idle, sets.midcast.healing, sets.interrupt)
	end
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
