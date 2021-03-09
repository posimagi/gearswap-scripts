function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("nin/enmity.lua") -- sets.enmity
	include("nin/idle.lua") -- sets.idle
	include("nin/fastcast.lua") -- sets.fastcast
	include("nin/ninjutsu.lua") -- sets.ninjutsu
	include("nin/tp.lua") -- sets.tp
	include("nin/ws.lua") -- sets.ws

	include("nin/precast-utsusemi.lua") -- sets.precast.utsusemi

	include("nin/midcast-utsusemi.lua") -- sets.midcast.utsusemi

	_TANK = true

	send_command(
		"input /macro book 13; \
		wait 1; \
		input /macro set 9; \
		wait 5; \
		input /lockstyleset 95; \
		gs equip sets.idle"
	)
end

function sub_job_change(new, old)
	send_command(
		"input /macro book 13; \
		wait 1; \
		input /macro set 9; \
		wait 10; \
		input /lockstyleset 95; \
		gs equip sets.idle"
	)
end

function precast(spell, position)
	if spell.type == "WeaponSkill" then
		equip(sets.ws)
	elseif spell.type == "JobAbility" then
		equip(sets.enmity)
	elseif spell.type == "Ninjutsu" then
		equip(sets.fastcast)
		if spell.english:contains("Utsusemi") then
			equip(sets.precast.utsusemi)
		end
	else
		equip(sets.fastcast)
	end
end

function midcast(spell)
	if spell.type == "Ninjutsu" then
		equip(sets.ninjutsu)
		if buffactive['Yonin'] or buffactive['Enmity Boost'] then
			equip(sets.enmity)
		end
		if spell.english:contains("Utsusemi") then
			equip(sets.midcast.utsusemi)
		end
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
