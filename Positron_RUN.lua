function get_sets()
    sets = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}

    include("run/enmity.lua") -- sets.enmity
    include("run/fastcast.lua") -- sets.fastcast
    include("run/idle.lua") -- sets.idle
    include("run/interrupt.lua") -- sets.interrupt
    include("run/tp.lua") -- sets.tp
    include("run/ws.lua") -- sets.ws

    -- sets.embolden
    
    include("run/precast-battuta.lua") -- sets.precast["Battuta"]
    include("run/precast-elementalsforzo.lua") -- sets.precast["Elemental Sforzo"]
    include("run/precast-liement.lua") -- sets.precast["Liement"]
    include("run/precast-vallation.lua") -- sets.precast["Vallation"], sets.precast["Valiance"]
    include("run/precast-vivaciouspulse.lua") -- sets.precast["Vivacious Pulse"]
    include("run/precast-enhancing.lua") -- sets.precast.enhancing
    
    include("run/midcast-enhancing.lua") -- sets.midcast.enhancing
    include("run/midcast-phalanx.lua") -- sets.midcast.phalanx
    include("run/midcast-refresh.lua") -- sets.midcast.refresh
    -- include("run/midcast-regen.lua") -- sets.midcast.regen

    _MAGIC = T{
        "WhiteMagic", 
        "BlackMagic", 
        "BlueMagic",
    }

    _ABILITY = T{
        "JobAbility",
        "Ward",
        "Effusion",
    }

    _OFFENSIVE = false
    if _OFFENSIVE then
        include("run/tp-offensive.lua") -- sets.tp
    end

    send_command(
        "wait 5; \
        input /macro book 7; \
        input /macro set 10; \
        input /lockstyle on; \
        gs equip sets.idle"
    )
end

function precast(spell, position)
    if _MAGIC:contains(spell.type) then
        equip(sets.fastcast)
    elseif spell.type == "WeaponSkill" then
        equip(sets.ws)
    elseif _ABILITY:contains(spell.type) then
        equip(sets.enmity, sets.precast[spell.name])
    end
end

function midcast(spell)
    equip(sets.interrupt, sets.enmity)
    if spell.skill == "Enhancing Magic" then
        equip(sets.midcast.enhancing)
        if spell.english:contains("Refresh") then
            equip(sets.midcast.refresh)
        elseif spell.english:contains("Phalanx") then
            equip(sets.midcast.phalanx)
        end
    end
end

function aftercast(spell)
    if player.status == "Idle" then
        equip(sets.idle)
    elseif player.status == "Engaged" then
        equip(sets.idle, sets.tp)
    end
end

function status_change(new, old)
    if new == "Engaged" then
        equip(sets.idle, sets.tp)
    elseif new == "Idle" then
        equip(sets.idle)
    end
end

function buff_change(name, gain, buff_details)
end
