function get_sets()
    sets = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}
    
    include("run/idle.lua") -- sets.idle
    include("run/tp.lua") -- sets.tp
    include("run/ws.lua") -- sets.ws
    include("run/enmity.lua") -- sets.enmity
    include("run/fastcast.lua") -- sets.fastcast
    include("run/interrupt.lua") -- sets.interrupt

    send_command("input /macro book 7; \
		wait 5; \
        input /lockstyle on; \
        gs equip sets.idle")
end

function precast(spell, position)
    if spell.type == "WhiteMagic" or
       spell.type == "BlueMagic" then
		equip(sets.fastcast)
	elseif spell.type == "WeaponSkill" then
        equip(sets.ws)
    elseif spell.type == "JobAbility" then
    -- if spell.english:contains("Meditate") then
      -- equip(sets.precast.meditate)
    -- end
    end
end

function midcast(spell)
    if spell.type == "BlueMagic" or
       spell.skill == "Divine Magic" then
        equip(sets.interrupt, sets.enmity)
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
