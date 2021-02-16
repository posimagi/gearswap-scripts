function get_sets()
    sets = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}
    
    include("rng/idle.lua") -- sets.idle
    include("rng/tp.lua") -- sets.tp
    include("rng/ws.lua") -- sets.ws

    include("rng/precast-ra.lua") -- sets.precast.ra

    include("rng/midcast-ra.lua") -- sets.midcast.ra

    send_command(
        "input /macro book 11; \
        input /macro set 1; \
        wait 5; \
		input /lockstyle on; \
        gs equip sets.idle")
end

function precast(spell, position)
    if spell.type == "WeaponSkill" then
        equip(sets.ws)
    elseif spell.type == "JobAbility" then
        
    elseif spell.action_type == "Ranged Attack" then
        equip(sets.precast.ra)
    end
end

function midcast(spell)
    if spell.action_type == "Ranged Attack" then
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

function buff_change(name, gain, buff_details)
end
