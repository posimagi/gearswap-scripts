function get_sets()
    sets = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}
    
	include("all/obi.lua") -- sets.obi
    include("all/precast-utsusemi.lua") -- sets.precast.utsusemi

    include("rng/idle.lua") -- sets.idle
    include("rng/fastcast.lua") -- sets.fastcast
    include("rng/tp.lua") -- sets.tp
    include("rng/ws.lua") -- sets.ws
    include("rng/ws-critical.lua") -- sets.ws.critical
    include("rng/ws-magical.lua") -- sets.ws.magical
    include("rng/ws-singlehit.lua") -- sets.ws.singlehit

    include("rng/precast-ra.lua") -- sets.precast.ra
    include("rng/precast-waltzes.lua") -- sets.precast.waltzes

    include("rng/midcast-ra.lua") -- sets.midcast.ra
    include("rng/midcast-phalanx.lua") -- sets.midcast.phalanx

    include("func/ammo_check.lua") -- ammo_check()
    include("func/obi_check.lua") -- obi_check()

    _MAGICAL_WS = T{
		"Aeolian Edge",
        "Trueflight",
        "Wildfire",
	}

    _RANGED_SKILLS = T{
        "Archery",
        "Marksmanship",
    }

    _AMMO_CONSUMING_ABILITIES = T{
        "Bounty Shot",
        "Eagle Eye Shot",
        "Shadowbind",
    }

    send_command(
        "input /macro book 11; \
        wait 1; \
        input /macro set 1; \
        wait 5; \
		input /lockstyleset 85; \
        gs equip sets.idle")
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
        if _RANGED_SKILLS:contains(spell.skill) then
            ammo_check(spell)
        end
        if _MAGICAL_WS:contains(spell.english) then
            equip(sets.ws.magical)
            obi_check(spell)
        elseif spell.english:contains("Jishnu's Radiance") then
            equip(sets.ws.critical)
        elseif spell.english:contains("Savage Blade") then
            equip(sets.ws.singlehit)
        else
            equip(sets.ws)
        end
    elseif spell.type == "JobAbility" then
        if _AMMO_CONSUMING_ABILITIES:contains(spell.english) then
            ammo_check(spell)
        end
    elseif spell.type == "Waltz" then
		equip(sets.precast.waltzes)
    elseif spell.action_type == "Ranged Attack" then
        ammo_check(spell)
        equip(sets.precast.ra)
    elseif spell.type == "Ninjutsu" then
		equip(sets.idle, sets.fastcast)
		if spell.english:contains("Utsusemi") then
			equip(sets.precast.utsusemi)
		end
    else
        equip(sets.fastcast)
    end
end

function midcast(spell)
    if spell.action_type == "Ranged Attack" then
        equip(sets.midcast.ra)
    elseif spell.english:contains("Phalanx") then
		equip(sets.midcast.phalanx)
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
