function get_sets()
    sets = {}
    sets.precast = {}
    sets.midcast = {}
    sets.aftercast = {}    

    include("all/precast-stoneskin.lua") -- sets.precast.stoneskin

    include("all/midcast-stoneskin.lua") -- sets.midcast.stoneskin

    include("geo/idle.lua") -- sets.idle
    include("geo/fastcast.lua") -- sets.fastcast
    include("geo/naked.lua") -- sets.naked
    include("geo/th.lua") -- sets.th
    include("geo/tp.lua") -- sets.tp
    include("geo/weapon.lua") -- sets.weapon
    include("geo/weapon-mb.lua") -- sets.weapon.mb
    include("geo/ws.lua") -- sets.ws

    include("geo/precast-bolster.lua") -- sets.precast.bolster
    include("geo/precast-healing.lua") -- sets.precast.healing

    include('geo/midcast-enhancing.lua') -- sets.midcast.enhancing
    include('geo/midcast-enfeebling.lua') -- sets.midcast.enfeebling
    include("geo/midcast-geocolure.lua") -- sets.midcast.geocolure
    include("geo/midcast-geomancy.lua") -- sets.midcast.geomancy
    include('geo/midcast-healing.lua') -- sets.midcast.healing
    include("geo/midcast-indicolure.lua") -- sets.midcast.indicolure
    include("geo/midcast-mb.lua") -- sets.midcast.mb
    include("geo/midcast-refresh.lua") -- sets.midcast.refresh

    _TIER_ONE_NUKES = T{
        "Fire",
        "Blizzard",
        "Aero",
        "Stone",
        "Thunder",
        "Water",
    }

    send_command(
        "input /macro book 10; \
        wait 1; \
        input /macro set 10; \
        wait 5; \
        input /lockstyleset 51; \
        gs equip sets.idle; \
        wait 1; \
        gs equip sets.weapon"
    )
end

function sub_job_change(new, old)
    send_command(
        "input /macro book 10; \
        wait 1; \
        input /macro set 10; \
        wait 10; \
        input /lockstyleset 51; \
        gs equip sets.idle"
    )
end

function precast(spell, position)
    equip(sets.fastcast)
    if spell.english:contains("Bolster") then
        equip(sets.precast.bolster)
    elseif spell.skill == "Healing Magic" then
        equip(sets.precast.healing)
    end
end

function midcast(spell)
    if spell.skill == "Geomancy" then
        equip(sets.midcast.geomancy)
        if spell.english:contains("Indi-") then
            equip(sets.midcast.indicolure)
        elseif spell.english:contains("Geo-") then
            equip(sets.midcast.geocolure)
        end
    elseif spell.skill == "Enfeebling Magic" then
        equip(sets.midcast.enfeebling)
        if spell.english:contains("Dia") then
            equip(sets.th)
        end
    elseif spell.skill == "Enhancing Magic" then
        equip(sets.midcast.enhancing)
        if spell.english:contains("Stoneskin") then
            equip(sets.midcast.stoneskin)
        elseif spell.english:contains("Refresh") then
            equip(sets.midcast.refresh)
        end
    elseif spell.skill == "Healing Magic" then
        equip(sets.midcast.healing)
    elseif spell.skill == "Elemental Magic" then
        equip(sets.midcast.mb)
        if world.area == "Outer Ra'Kaznar [U]" then
            if _TIER_ONE_NUKES:contains(spell.english) then
                equip(sets.naked)
            else
                equip(sets.weapon.mb)
            end
        end
    elseif spell.skill == "Dark Magic" then
        if spell.english:contains("Bio") then
            equip(sets.th)
        end
    end
end

function aftercast(spell)
    if world.area == "Outer Ra'Kaznar [U]" and spell.skill == "Elemental Magic" then
        equip(sets.weapon)
    end
    if player.status == "Engaged" then
        equip(sets.tp)
    elseif player.status == "Idle" then
        equip(sets.idle)
    end
end

function status_change(new, old)
    if player.status == "Engaged" then
        equip(sets.tp)
    elseif player.status == "Idle" then
        equip(sets.idle)
    end
end
