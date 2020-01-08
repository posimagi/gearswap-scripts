function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("thf/idle.lua") -- sets.idle
	include("thf/th.lua") -- sets.th
	include("thf/tp.lua") -- sets.tp
	include("thf/ws.lua") -- sets.ws
	include("thf/ws-magical.lua") -- sets.ws.magical

	include("thf/precast-flee.lua") -- sets.precast.flee

	include("func/buffactive_sata.lua") -- buffactive_sata()

	send_command(
		"input /macro book 6; \
		wait 5; \
		input /lockstyleset 50; \
		gs equip sets.idle")
end

function precast(spell, position)
	if spell.type == "WeaponSkill" then
		equip(sets.ws)
		if spell.english:contains('Aeolian Edge') then
			equip(sets.ws.magical)
		end
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Flee") then
			equip(sets.precast.flee)
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
		if buffactive_sata() then
			equip(sets.th)
		end
	end
end

function status_change(new, old)
	if new == "Engaged" then
		equip(sets.tp)
		if buffactive_sata() then
			equip(sets.th)
		end
	elseif new == "Idle" then
		equip(sets.idle)
	end
end

function buff_change(name, gain, buff_details)
	if name == "Sneak Attack" or name == "Trick Attack" then
		if gain then
			equip(sets.th)
		else
			if player.status == "Engaged" then
				equip(sets.tp)
			elseif player.status == "Idle" then
				equip(sets.idle)
			end
		end
	end
end
