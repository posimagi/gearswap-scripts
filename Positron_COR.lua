function get_sets()
	sets = {}
	sets.precast = {}
	sets.midcast = {}
	sets.aftercast = {}

	include("func/obi_check.lua") -- obi_check()

	include("all/obi.lua") -- sets.obi
	include("all/precast-utsusemi.lua") -- sets.precast.utsusemi

	include("cor/fastcast.lua") -- sets.fastcast
	include("cor/idle.lua") -- sets.idle
	include("cor/tp.lua") -- sets.tp
	include("cor/ws.lua") -- sets.ws
	include("cor/ws-dark.lua") -- sets.ws.dark
	include("cor/ws-magical.lua") -- sets.ws.magical
	include("cor/ws-multihit.lua") -- sets.ws.multihit
	include("cor/ws-ranged.lua") -- sets.ws.ranged

	include("cor/precast-phantomroll.lua") -- sets.precast.phantomroll
	include("cor/precast-quickdraw.lua") -- sets.precast.quickdraw
	include("cor/precast-ra.lua") -- sets.precast.ra
	include("cor/precast-randomdeal.lua") -- sets.precast.randomdeal
	include("cor/precast-waltzes.lua") -- sets.precast.waltzes
	include("cor/precast-wildcard.lua") -- sets.precast.wildcard

	include("cor/midcast-enfeebling.lua") -- sets.midcast.enfeebling
	include("cor/midcast-phalanx.lua") -- sets.midcast.phalanx
	include("cor/midcast-ra.lua") -- sets.midcast.ra

	_DARK_WS = T{
		"Leaden Salute",
	}

	_MAGICAL_WS = T{
		"Aeolian Edge",
		"Hot Shot",
		"Red Lotus Blade",
		"Sanguine Blade",
		"Seraph Blade",
		"Wildfire",
	}

    _MULTI_HIT_WS = T{
        "Evisceration",
		"Requiescat",
    }

	_RANGED_WS = T{
		"Detonator",
		"Last Stand",
		"Numbing Shot",
		"Sniper Shot",
		"Slug Shot",
		"Split Shot",
	}

	send_command(
		"input /macro book 11; \
		wait 1; \
		input /macro set 10; \
		wait 5; \
		input /lockstyleset 37; \
		gs equip sets.idle; \
		du blinking self all off;"
	)
end

function sub_job_change(new, old)
	send_command(
		"wait 10; \
		input /lockstyleset 37; \
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
		if _DARK_WS:contains(spell.english) then
			equip(sets.ws.magical, sets.ws.dark)
			obi_check(spell)
		elseif _MAGICAL_WS:contains(spell.english) then
			equip(sets.ws.magical)
			obi_check(spell)
		elseif _MULTI_HIT_WS:contains(spell.english) then
			equip(sets.ws.multihit)
		elseif _RANGED_WS:contains(spell.english) then
			equip(sets.ws.ranged)
		end
	elseif spell.type == "CorsairRoll" then
		equip(sets.precast.phantomroll)
	elseif spell.type == "CorsairShot" then
		equip(sets.precast.quickdraw)
		obi_check(spell)
	elseif spell.type == "JobAbility" then
		if spell.english:contains("Double-Up") then
			equip(sets.precast.phantomroll)
		elseif spell.english:contains("Random Deal") then
			equip(sets.precast.randomdeal)
		elseif spell.english:contains("Wild Card") then
			equip(sets.precast.wildcard)
		end
	elseif spell.type == "Waltz" then
		equip(sets.precast.waltzes)
	elseif spell.type == "Ninjutsu" then
		equip(sets.fastcast)
		if spell.english:contains("Utsusemi") then
			equip(sets.precast.utsusemi)
		end
	elseif spell.action_type == "Ranged Attack" then
		equip(sets.precast.ra)
	else
		equip(sets.fastcast)
	end
end

function midcast(spell)
	if spell.english:contains("Phalanx") then
		equip(sets.midcast.phalanx)
	elseif spell.skill == "Enfeebling Magic" then
		equip(sets.midcast.enfeebling)
	elseif spell.action_type == "Ranged Attack" then
		equip(sets.midcast.ra)
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
