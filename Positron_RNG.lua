function get_sets()
    sets = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}
    
    include("rng/idle.lua") -- sets.idle
    include("rng/fastcast.lua") -- sets.fastcast
    include("rng/tp.lua") -- sets.tp
    include("rng/ws.lua") -- sets.ws
    include("rng/ws-magical.lua") -- sets.ws.magical

    include("rng/precast-ra.lua") -- sets.precast.ra
    include("rng/precast-waltzes.lua") -- sets.precast.waltzes

    include("rng/midcast-ra.lua") -- sets.midcast.ra
    include("rng/midcast-phalanx.lua") -- sets.midcast.phalanx

    send_command(
        "input /macro book 11; \
        wait 1; \
        input /macro set 1; \
        wait 5; \
		input /lockstyleset 85; \
        gs equip sets.idle")
end

function precast(spell, position)
    if spell.type == "WeaponSkill" then
        equip(sets.ws)
        if spell.english:contains("Aeolian Edge") or
           spell.english:contains("Wildfire") or
           spell.english:contains("Trueflight") then
            equip(sets.ws.magical)
        end
    elseif spell.type == "JobAbility" then
        
    elseif spell.type == "Waltz" then
		equip(sets.precast.waltzes)
    elseif spell.action_type == "Ranged Attack" then
        equip(sets.precast.ra)
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
