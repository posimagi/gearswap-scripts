function get_sets()
    sets = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}
    
    include("sam/idle.lua") -- sets.idle
    include("sam/tp.lua") -- sets.tp
    include("sam/ws.lua") -- sets.ws
    include("sam/ws-multihit.lua") -- sets.ws.multihit

    include("sam/precast-meditate.lua") -- sets.precast.meditate

    send_command(
        "input /macro book 12; \
        wait 1; \
        input /macro set 1; \
        wait 5; \
		input /lockstyleset 49; \
        gs equip sets.idle")
end

function precast(spell, position)
    if spell.type == "WeaponSkill" then
        equip(sets.ws)
        if spell.english:contains("Rana") then
            equip(sets.ws.multihit)
        end
    elseif spell.type == "JobAbility" then
        if spell.english:contains("Meditate") then
            equip(sets.precast.meditate)
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
