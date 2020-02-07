function get_sets()
    sets = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}
    
    include("mnk/idle.lua") -- sets.idle
    include("mnk/tp.lua") -- sets.tp
    include("mnk/ws.lua") -- sets.ws

    send_command("input /macro book 2; \
		wait 5; \
        input /lockstyle on; \
        gs equip sets.idle")
end

function precast(spell, position)
    if spell.type == "WeaponSkill" then
        equip(sets.ws)
    elseif spell.type == "JobAbility" then
    -- if spell.english:contains("Meditate") then
      -- equip(sets.precast.meditate)
    -- end
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
