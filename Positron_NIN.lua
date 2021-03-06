function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("all/doom.lua") -- sets.doom

	include("nin/enmity.lua") -- sets.enmity
	include("nin/idle.lua") -- sets.idle
	include("nin/fastcast.lua") -- sets.fastcast
	include("nin/ninjutsu.lua") -- sets.ninjutsu
	include("nin/tp.lua") -- sets.tp
	include("nin/ws.lua") -- sets.ws
	include("nin/ws-singlehit.lua") -- sets.ws.singlehit

	include("nin/precast-utsusemi.lua") -- sets.precast.utsusemi

	include("nin/midcast-mb.lua") -- sets.midcast.mb
	include("nin/midcast-utsusemi.lua") -- sets.midcast.utsusemi

	_SINGLE_HIT_WS = T{
		"Blade: Hi",
		"Blade: Kamu",
	}

	_MAGICAL_WS = T{
		"Blade: Teki",
		"Blade: To",
		"Blade: Chi",
		"Blade: Ei",
		"Blade: Yu",
	}

	send_command(
		"input /macro book 13; \
		wait 1; \
		input /macro set 10; \
		wait 5; \
		input /lockstyleset 95; \
		gs equip sets.idle"
	)
	if player.sub_job == "DNC" then
		send_command(
			"wait 3; \
			input /macro set 9;"
		)
	end
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
	-- WS Engaged Check
	if
			spell.type == "WeaponSkill" and
			player.status ~= "Engaged" then
		cancel_spell()
		return
	end

	-- WS Distance Check
	_RANGE_MULTIPLIER = 1.642276421172564
	if 
			spell.type == "WeaponSkill" and
			spell.target.distance > (spell.range * _RANGE_MULTIPLIER + spell.target.model_size) then
		add_to_chat(8, spell.name.." aborted due to target out of range.")
		cancel_spell()
		return
	end

	if spell.type == "WeaponSkill" then
		equip(sets.ws)
		if 
				_SINGLE_HIT_WS:contains(spell.english) or
				_MAGICAL_WS:contains(spell.english) then
			equip(sets.ws.singlehit)
		end
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
		if 
				buffactive['Yonin'] or 
				buffactive['Enmity Boost'] then
			equip(sets.enmity)
		end
		if spell.english:contains("Utsusemi") then
			equip(sets.midcast.utsusemi)
		elseif spell.english:contains("ton: ") then
			equip(sets.midcast.mb)
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

function buff_change(name, gain, buff_details)
    if name == "Doom" then
        if gain then
            equip(sets.doom)
            disable("neck", "left_ring")
        else
            enable("neck", "left_ring")
        end
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
