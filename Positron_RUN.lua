function get_sets()
    sets = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}

    include("run/engaged.lua") -- sets.engaged
    include("run/enmity.lua") -- sets.enmity
    include("run/fastcast.lua") -- sets.fastcast
    include("run/idle.lua") -- sets.idle
    include("run/interrupt.lua") -- sets.interrupt
    include("run/th.lua") -- sets.th
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
        sets.engaged = sets.tp
    end

    send_command(
        "input /macro book 7; \
        wait 1; \
        input /macro set 10; \
        wait 5; \
        input /lockstyleset 94; \
        gs equip sets.idle"
    )
end

function precast(spell, position)
    if _MAGIC:contains(spell.type) then
        equip(sets.fastcast)
    elseif spell.type == "WeaponSkill" then
        equip(sets.ws)
        if spell.name:contains("Shockwave") then
            equip(sets.th)
        end
    elseif _ABILITY:contains(spell.type) then
        equip(sets.enmity, sets.precast[spell.name])
    elseif spell.type == "Item" then
        equip(sets.cursna)
    end
end
include("func/ws_distance_check.lua")

function midcast(spell)
    equip(sets.idle, sets.interrupt, sets.enmity)
    if spell.skill == "Enhancing Magic" then
        if spell.english:contains("Foil") then
            equip(sets.idle, sets.interrupt, sets.enmity)
        elseif spell.english:contains("Refresh") then
            equip(sets.idle, sets.interrupt, sets.midcast.refresh)
        elseif spell.english:contains("Phalanx") then
            equip(sets.idle, sets.interrupt, sets.midcast.phalanx)
        end
    elseif spell.type == "Item" then
        equip(sets.idle, sets.cursna)
    end
end

function aftercast(spell)
    if player.status == "Idle" then
        equip(sets.idle)
    elseif player.status == "Engaged" then
        equip(sets.idle, sets.engaged)
    end
end

function status_change(new, old)
    if new == "Engaged" then
        equip(sets.idle, sets.engaged)
    elseif new == "Idle" then
        equip(sets.idle)
    end
end

function buff_change(name, gain, buff_details)
end
